/// How often street informants look around for player characters
#define STREET_SIGHTING_INTERVAL (20 SECONDS)
/// How long street informants remember where they saw someone
#define STREET_SIGHTING_MEMORY (15 MINUTES)
/// How long street informants remember crimes
#define STREET_CRIME_MEMORY (10 MINUTES)
/// How long a crime takes to reach the street, so informants are never faster than the police scanner
#define STREET_CRIME_DELAY (1 MINUTES)
/// Reports of the same crime in the same place closer than this are one ongoing incident
#define STREET_CRIME_MERGE_WINDOW (1 MINUTES)
/// How stale the information about a person is with a single success
#define STREET_SIGHTING_BASE_DELAY (3 MINUTES)
/// Freshest information about a person, no matter how many successes
#define STREET_SIGHTING_MIN_DELAY (1 MINUTES)
/// Each success beyond the first makes the information this much fresher
#define STREET_SIGHTING_DELAY_PER_SUCCESS (1 MINUTES)
/// Each dot of the subject's Stealth makes the information this much staler
#define STREET_SIGHTING_DELAY_PER_STEALTH (1 MINUTES)
/// How long an asked informant refuses further questions
#define STREET_ANSWER_COOLDOWN (1 MINUTES)
/// Longest an informant stands still for one talker
#define STREET_TALK_DURATION (30 SECONDS)
/// Most crimes an informant retells; each success reveals one, up to this cap
#define STREET_CRIMES_TOLD 3

#define SIGHTING_AREA_NAME 1
#define SIGHTING_FIRST_SEEN 2
#define SIGHTING_LAST_SEEN 3

#define CRIME_RUMOR_TYPE 1
#define CRIME_RUMOR_AREA_NAME 2
#define CRIME_RUMOR_FIRST_TIME 3
#define CRIME_RUMOR_LAST_TIME 4

#define STREET_QUESTION_PERSON "Спросить о человеке"
#define STREET_QUESTION_CRIME "Спросить о происшествиях"

/// Records where street informants see player characters and which crimes happen around the city.
SUBSYSTEM_DEF(street_rumors)
	name = "Street Rumors"
	wait = STREET_SIGHTING_INTERVAL
	ss_flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	/// Players still to be checked during the current run
	var/list/currentrun = list()
	/// Recent street crimes, oldest first: list(list(crime type, area name, first report, last report))
	var/list/crime_rumors = list()

/datum/controller/subsystem/street_rumors/Initialize()
	RegisterSignal(SSdcs, COMSIG_GLOB_REPORT_CRIME, PROC_REF(on_crime_reported))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/street_rumors/fire(resumed = FALSE)
	if(!resumed)
		currentrun = GLOB.alive_player_list.Copy()

	var/list/to_check = currentrun
	while(length(to_check))
		var/mob/living/carbon/human/player = to_check[length(to_check)]
		to_check.len--
		if(ishuman(player) && !QDELETED(player) && is_seen_on_street(player))
			player.record_street_sighting(get_area_name(player))
		if(MC_TICK_CHECK)
			return

/// Whether any conscious street informant can currently see and recognize this player character.
/datum/controller/subsystem/street_rumors/proc/is_seen_on_street(mob/living/carbon/human/player)
	if(player.stat == DEAD)
		return FALSE
	// Inside a vehicle, locker or shapeshift holder nobody sees the person themselves
	if(!isturf(player.loc))
		return FALSE
	// Only the plain human body counts, transformed shapes are not recognized as the same person
	if(!ishomid(player) && player.dna?.species?.type != /datum/species/human)
		return FALSE
	if(player.is_face_obscured())
		return FALSE

	// Guards, shopkeepers, police and anyone indoors keep what they see to themselves
	for(var/mob/living/carbon/human/npc/witness in viewers(DEFAULT_SIGHT_DISTANCE, player))
		if(!witness.is_street_informant())
			continue
		if(IS_UNCONSCIOUS_OR_CRIT(witness) || witness.is_blind())
			continue
		if(player.invisibility > witness.see_invisible)
			continue
		return TRUE
	return FALSE

/datum/controller/subsystem/street_rumors/proc/on_crime_reported(datum/source, crime, turf/location)
	SIGNAL_HANDLER

	// Emergency alarms are calls to the police, not something the street gossips about
	if(crime == CRIME_EMERGENCY || !location)
		return
	// Same rule as the police scanner: only the streets of the city, not sewers or hidden places
	var/area/vtm/crime_area = astype(get_area(location))
	if(!crime_area || crime_area.zone_type != ZONE_MASQUERADE)
		return

	var/area_name = get_area_name(crime_area)
	// Repeated reports of the same crime in the same place (every gunshot of one firefight) are one incident
	for(var/list/rumor as anything in crime_rumors)
		if(rumor[CRIME_RUMOR_TYPE] != crime || rumor[CRIME_RUMOR_AREA_NAME] != area_name)
			continue
		if(world.time - rumor[CRIME_RUMOR_LAST_TIME] <= STREET_CRIME_MERGE_WINDOW)
			rumor[CRIME_RUMOR_LAST_TIME] = world.time
			return
		// Too long ago, this is a new incident in the same place
		crime_rumors -= list(rumor)
		break
	crime_rumors += list(list(crime, area_name, world.time, world.time))
	forget_old_crimes()

/datum/controller/subsystem/street_rumors/proc/forget_old_crimes()
	var/forget_before = world.time - STREET_CRIME_MEMORY
	for(var/list/rumor as anything in crime_rumors.Copy())
		if(rumor[CRIME_RUMOR_LAST_TIME] < forget_before)
			crime_rumors -= list(rumor)

/// Returns up to `amount` of the most recent crimes that already reached the street, newest first.
/datum/controller/subsystem/street_rumors/proc/get_recent_crimes(amount)
	forget_old_crimes()
	. = list()
	var/known_before = world.time - STREET_CRIME_DELAY
	for(var/i in length(crime_rumors) to 1 step -1)
		if(length(.) >= amount)
			return
		var/list/rumor = crime_rumors[i]
		if(rumor[CRIME_RUMOR_FIRST_TIME] > known_before)
			continue
		. += list(rumor)

/datum/controller/subsystem/street_rumors/proc/crime_to_text(crime)
	switch(crime)
		if(CRIME_GUNSHOTS)
			return "стреляли"
		if(CRIME_FIREFIGHT)
			return "на кого-то напали"
		if(CRIME_MURDER)
			return "кого-то убили"
		if(CRIME_BURGLARY)
			return "кого-то обнесли"
		if(CRIME_ATM_TAMPERING)
			return "раскурочили банкомат"
	return "что-то случилось"

/mob/living/carbon/human
	/// Where street informants saw this human, oldest first: list(list(area name, first seen, last seen))
	var/list/street_sightings

/mob/living/carbon/human/proc/record_street_sighting(area_name)
	if(!area_name)
		return
	var/list/last_sighting = LAZYACCESS(street_sightings, LAZYLEN(street_sightings))
	if(last_sighting && last_sighting[SIGHTING_AREA_NAME] == area_name)
		last_sighting[SIGHTING_LAST_SEEN] = world.time
	else
		LAZYADD(street_sightings, list(list(area_name, world.time, world.time)))

	var/forget_before = world.time - STREET_SIGHTING_MEMORY
	while(length(street_sightings) && street_sightings[1][SIGHTING_LAST_SEEN] < forget_before)
		street_sightings.Cut(1, 2)

/**
 * Where street informants saw this human, as of `delay` ago.
 *
 * Returns list(area name, time of that sighting) or null if nobody remembers.
 */
/mob/living/carbon/human/proc/get_delayed_street_sighting(delay)
	var/known_before = world.time - delay
	var/forget_before = world.time - STREET_SIGHTING_MEMORY
	for(var/i in length(street_sightings) to 1 step -1)
		var/list/sighting = street_sightings[i]
		if(sighting[SIGHTING_FIRST_SEEN] > known_before)
			continue
		if(sighting[SIGHTING_LAST_SEEN] < forget_before)
			return null
		return list(sighting[SIGHTING_AREA_NAME], min(sighting[SIGHTING_LAST_SEEN], known_before))
	return null

/// "N минут назад", at least one minute.
/proc/street_minutes_ago(time)
	var/minutes = max(1, round((world.time - time) / (1 MINUTES)))
	return "[minutes] [declension_ru(minutes, "минуту", "минуты", "минут")] назад"

/// Asking the street folk: homeless and bandits
/datum/storyteller_roll/street_rumor
	bumper_text = "расспросы на улице"
	applicable_stats = list(STAT_MANIPULATION, STAT_STREETWISE)
	roll_output_type = ROLL_FLAG_ROLLER
	numerical = TRUE

/// Asking ordinary and well-off passers-by
/datum/storyteller_roll/street_rumor/polite
	bumper_text = "вежливые расспросы"
	applicable_stats = list(STAT_CHARISMA, STAT_ETIQUETTE)

/mob/living/carbon/human
	/// Asking anyone on the street about anything puts the asker on this cooldown
	COOLDOWN_DECLARE(street_ask_cooldown)

/mob/living/carbon/human/npc
	/// Whether this NPC notices things on the street and can be asked about them
	var/street_informant = FALSE
	/// Roll used when this NPC is asked a question
	var/street_roll_type = /datum/storyteller_roll/street_rumor
	/// After answering a question the NPC refuses to talk for a while
	COOLDOWN_DECLARE(street_answer_cooldown)
	/// Player currently talking to this informant; the informant stands still while they stay adjacent
	var/mob/living/street_talker

/mob/living/carbon/human/npc/hobo
	street_informant = TRUE

/mob/living/carbon/human/npc/bandit
	street_informant = TRUE

/mob/living/carbon/human/npc/walkby
	street_informant = TRUE
	street_roll_type = /datum/storyteller_roll/street_rumor/polite

/mob/living/carbon/human/npc/business
	street_informant = TRUE
	street_roll_type = /datum/storyteller_roll/street_rumor/polite

/// Informants only gossip while out on the street: the same NPC types placed inside clubs or offices stay silent.
/mob/living/carbon/human/npc/proc/is_street_informant()
	if(!street_informant || initial(staying))
		return FALSE
	var/area/our_area = get_area(src)
	return our_area?.outdoors

/mob/living/carbon/human/npc/examine(mob/user)
	. = ..()
	if(ishuman(user) && is_street_informant())
		INVOKE_ASYNC(src, PROC_REF(on_street_examine), user)

/mob/living/carbon/human/npc/proc/can_talk_on_street(mob/living/carbon/human/asker)
	if(!is_street_informant() || !ishuman(asker) || asker == src || asker.incapacitated)
		return FALSE
	if(IS_UNCONSCIOUS_OR_CRIT(src) || key || danger_source)
		return FALSE
	return TRUE

/// Shift-click right next to the informant stops it and opens the questions.
/mob/living/carbon/human/npc/proc/on_street_examine(mob/living/carbon/human/asker)
	if(!can_talk_on_street(asker) || !in_range(src, asker))
		return
	open_street_questions(asker)

/// Makes a walking informant stand still and face the talker until they step away, act against it or time runs out.
/mob/living/carbon/human/npc/proc/hold_for_talk(mob/living/talker)
	// NPCs that always stand still are left alone
	if(initial(staying))
		return
	if(street_talker != talker)
		release_from_talk()
		street_talker = talker
		RegisterSignal(talker, COMSIG_MOVABLE_MOVED, PROC_REF(check_talk_distance))
		RegisterSignal(talker, COMSIG_QDELETING, PROC_REF(release_from_talk))
		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_talk_distance))
	GLOB.move_manager.stop_looping(src)
	staying = TRUE
	face_atom(talker)
	addtimer(CALLBACK(src, PROC_REF(release_from_talk)), STREET_TALK_DURATION, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/carbon/human/npc/proc/check_talk_distance(datum/source)
	SIGNAL_HANDLER
	if(!street_talker || !in_range(src, street_talker))
		release_from_talk()

/mob/living/carbon/human/npc/proc/release_from_talk()
	SIGNAL_HANDLER
	// Only undo our own hold: other code (club dancers) changes `staying` on its own
	if(!street_talker)
		return
	UnregisterSignal(street_talker, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	street_talker = null
	staying = FALSE

// Grabbing or provoking the informant ends the conversation and its normal behaviour takes over
/mob/living/carbon/human/npc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	. = ..()
	release_from_talk()

/mob/living/carbon/human/npc/Aggro(mob/living/victim, attacked = FALSE)
	release_from_talk()
	return ..()

/// Brushes the asker off while they or the informant are still on cooldown from a previous question. Returns TRUE if refused.
/mob/living/carbon/human/npc/proc/refuse_if_annoyed(mob/living/carbon/human/asker)
	if(COOLDOWN_FINISHED(src, street_answer_cooldown) && COOLDOWN_FINISHED(asker, street_ask_cooldown))
		return FALSE
	if(prob(50))
		to_chat(asker, span_warning("[capitalize(declent_ru(NOMINATIVE))] огрызается: \"Отвали.\""))
	else
		to_chat(asker, span_warning("[capitalize(declent_ru(NOMINATIVE))] отводит взгляд: \"Я ничего не знаю.\""))
	return TRUE

/// The conversation is still on: the informant holds for this asker, who stands next to it, and nothing broke it off.
/mob/living/carbon/human/npc/proc/is_talking_with(mob/living/carbon/human/asker)
	return street_talker == asker && in_range(src, asker) && can_talk_on_street(asker)

/mob/living/carbon/human/npc/proc/open_street_questions(mob/living/carbon/human/asker)
	hold_for_talk(asker)

	var/static/list/questions = list(
		STREET_QUESTION_PERSON = image(icon = 'icons/obj/toys/dice.dmi', icon_state = "d10"),
		STREET_QUESTION_CRIME = image(icon = 'icons/obj/toys/dice.dmi', icon_state = "d10"),
	)
	// Closes on its own once the asker steps away, grabs or attacks the informant, or the hold times out
	var/question = show_radial_menu(asker, src, questions, radius = 38, require_near = TRUE, custom_check = CALLBACK(src, PROC_REF(is_talking_with), asker))
	if(!question || !is_talking_with(asker))
		return
	// The menu always opens so the informant visibly reacts; a fresh answer still has to wait for the cooldown
	if(refuse_if_annoyed(asker))
		return

	switch(question)
		if(STREET_QUESTION_PERSON)
			ask_about_person(asker)
		if(STREET_QUESTION_CRIME)
			ask_about_crimes(asker)

/// Rolls for a street question and puts both the asker and the informant on cooldown. Returns the number of successes, or null if refused.
/mob/living/carbon/human/npc/proc/roll_street_answer(mob/living/carbon/human/asker)
	// Someone else may have asked while the menus were open
	if(refuse_if_annoyed(asker))
		return null
	// One roll datum per type, shared by every informant using it
	var/static/list/street_rolls = list()
	var/datum/storyteller_roll/street_rumor/roll = street_rolls[street_roll_type]
	if(!roll)
		roll = new street_roll_type()
		street_rolls[street_roll_type] = roll
	var/successes = roll.st_roll(asker, src)
	COOLDOWN_START(src, street_answer_cooldown, STREET_ANSWER_COOLDOWN)
	COOLDOWN_START(asker, street_ask_cooldown, STREET_ANSWER_COOLDOWN)
	return successes

/mob/living/carbon/human/npc/proc/ask_about_person(mob/living/carbon/human/asker)
	var/mob/living/carbon/human/subject = asker.mind?.guestbook?.pick_known_guy(asker)
	// The list of known people cannot watch the informant, so the conversation is rechecked after picking
	if(isnull(subject) || !is_talking_with(asker))
		return
	if(!ishuman(subject) || subject == asker || subject == src)
		to_chat(asker, span_warning("[capitalize(declent_ru(NOMINATIVE))] не понимает, о ком вы."))
		return

	var/successes = roll_street_answer(asker)
	if(isnull(successes))
		return

	var/subject_name = GET_GUESTBOOK_NAME(asker, subject)
	var/list/sighting
	if(successes >= 1)
		// Every success beyond the first gives fresher news, the subject's Stealth makes it staler
		var/delay = STREET_SIGHTING_BASE_DELAY \
			- (successes - 1) * STREET_SIGHTING_DELAY_PER_SUCCESS \
			+ subject.st_get_stat(STAT_STEALTH) * STREET_SIGHTING_DELAY_PER_STEALTH
		sighting = subject.get_delayed_street_sighting(max(delay, STREET_SIGHTING_MIN_DELAY))
	if(!sighting)
		to_chat(asker, span_notice("[capitalize(declent_ru(NOMINATIVE))] пожимает плечами: \"[subject_name]? Не, не видел.\""))
		return

	var/when = street_minutes_ago(sighting[2])
	var/where = sighting[1]
	if(prob(50))
		to_chat(asker, span_notice(genderize_decode(src, "[capitalize(declent_ru(NOMINATIVE))] кивает: \"Видел%(,а,о,и)% [when], место - [where].\"")))
	else
		var/friend_name = pick(GLOB.first_names_male)
		to_chat(asker, span_notice(genderize_decode(subject, "[capitalize(declent_ru(NOMINATIVE))] чешет затылок: \"[friend_name] говорил, что видел %(его,её,его,их)% [when], место - [where].\"")))

/mob/living/carbon/human/npc/proc/ask_about_crimes(mob/living/carbon/human/asker)
	var/successes = roll_street_answer(asker)
	if(isnull(successes))
		return

	// One crime per success, at most STREET_CRIMES_TOLD
	var/list/crimes = (successes >= 1) ? SSstreet_rumors.get_recent_crimes(min(successes, STREET_CRIMES_TOLD)) : null
	if(!length(crimes))
		to_chat(asker, span_notice("[capitalize(declent_ru(NOMINATIVE))] пожимает плечами: \"Тихо всё вроде. Ничего не слышал.\""))
		return

	// One line per rumor so separate incidents read as separate stories
	var/list/lines = list("[capitalize(declent_ru(NOMINATIVE))] понижает голос:")
	for(var/list/rumor as anything in crimes)
		lines += "— \"[capitalize(SSstreet_rumors.crime_to_text(rumor[CRIME_RUMOR_TYPE]))]. Место - [rumor[CRIME_RUMOR_AREA_NAME]], [street_minutes_ago(rumor[CRIME_RUMOR_FIRST_TIME])].\""
	to_chat(asker, span_notice(jointext(lines, "<br>")))

#undef STREET_SIGHTING_INTERVAL
#undef STREET_SIGHTING_MEMORY
#undef STREET_CRIME_MEMORY
#undef STREET_SIGHTING_BASE_DELAY
#undef STREET_SIGHTING_MIN_DELAY
#undef STREET_SIGHTING_DELAY_PER_SUCCESS
#undef STREET_SIGHTING_DELAY_PER_STEALTH
#undef STREET_ANSWER_COOLDOWN
#undef STREET_TALK_DURATION
#undef STREET_CRIMES_TOLD
#undef SIGHTING_AREA_NAME
#undef SIGHTING_FIRST_SEEN
#undef SIGHTING_LAST_SEEN
#undef CRIME_RUMOR_TYPE
#undef CRIME_RUMOR_AREA_NAME
#undef CRIME_RUMOR_FIRST_TIME
#undef CRIME_RUMOR_LAST_TIME
#undef STREET_CRIME_DELAY
#undef STREET_CRIME_MERGE_WINDOW
#undef STREET_QUESTION_PERSON
#undef STREET_QUESTION_CRIME
