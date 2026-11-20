/datum/discipline/melpominee	// CORVAX EDIT
	name = "Мельпомения"
	desc = {"Мельпомения, названная в честь греческой музы трагедии, - уникальная Дисциплина Дочерей Какофонии. Она раскрывает силу голоса, который потрясает слушателей до глубины души и позволяет вампиру творить со звуком невозможное.
● Блуждающий голос: пассивно
●● Незримый собеседник: Смекалка + Исполнение
●●● Мадригал: Обаяние + Исполнение против Смекалки + Бдительности цели
●●●● Зов сирены: Манипуляция + Исполнение против Воли
●●●●● Виртуозность: пассивно, расширяет другие силы
●●●●●● Пронзительное крещендо: Манипуляция + Запугивание."}
	icon_state = "melpominee"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/melpominee

/datum/discipline_power/melpominee
	name = "Melpominee power name"
	desc = "Melpominee power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg'

	vitae_cost = 1 // All Melpominee powers below 5 dots cost blood except for Missing Voice
	var/obj/effect/abstract/particle_holder/particle_generator
	frenzy_usable = FALSE

/datum/discipline_power/melpominee/proc/setup_particles()
	if(!particle_generator)
		particle_generator = new(owner, /particles/melpominee, PARTICLE_ATTACH_MOB)

/particles/melpominee
	icon = 'modular_darkpack/modules/phones/icons/phone.dmi'
	icon_state = list("note" = 1)
	width = 32
	height = 48
	count = 5
	spawning = 0.5
	lifespan = 5 SECONDS
	fade = 1.5 SECONDS
	gravity = list(0, 0.1)
	position = generator(GEN_SPHERE, 0, 16, NORMAL_RAND)
	spin = generator(GEN_NUM, -1, 1, NORMAL_RAND)

/**
 * • The Missing Voice - p453
 *
 * The character can “throw” her voice anywhere within her line of sight. This enables the Daughter to carry on surreptitious conversations,
 * sing duets with herself, or cause any number of distractions. This power can also be combined with other Melpominee powers to
 * disguise their source (and some Daughters use it to conceal the fact that Melpominee powers do not function through recorded media).
 *
 * The Daughter clicks on an object, mob, or turf and sends a message from that location.
 *
 */
/obj/effect/the_missing_voice
	name = "disembodied voice"
	desc = "Вы что, умеете читать по губам у призраков?"

/datum/discipline_power/melpominee/the_missing_voice
	name = "Блуждающий голос"
	desc = "Заставьте свой голос звучать из любого места, которое видите."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_MOB | TARGET_OBJ | TARGET_TURF
	range = 7
	vitae_cost = 0

/datum/discipline_power/melpominee/the_missing_voice/activate(atom/movable/target)
	. = ..()
	var/new_say = tgui_input_text(owner, "Что вы скажете?")
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
	if(!owner.try_speak(new_say))
		return

	if(findtext(new_say, "*"))
		to_chat(owner, span_danger("Сила \"[name]\" не передаёт эмоуты!"))
		return

	var/obj/dummy = new /obj/effect/the_missing_voice(get_turf(target)) // snowflake code but it's more robust than engineering some evil to_chat mechanism
	if(!(dummy in view(world.view, owner)))
		to_chat(owner, span_warning("Нужно видеть место, откуда должен звучать ваш голос."))
		return

	dummy.name = "\proper голос ([owner.get_generic_name(FALSE, TRUE)])" // CORVAX EDIT CHANGE - ORIGINAL: dummy.name = "голос ([owner.get_generic_name(FALSE, TRUE)])"
	// CORVAX EDIT ADD START - TTS
	var/datum/tts_seed/owner_tts_seed = owner.get_tts_seed()
	if(owner_tts_seed)
		dummy.AddComponent(/datum/component/tts_component, owner_tts_seed)
	// CORVAX EDIT ADD END
	dummy.say(message = new_say, forced = "melpominee 1")
	QDEL_IN(dummy, 2 TURNS)

/**
 * •• Phantom Speaker  - p453
 *
 * The Daughter can project her voice to any individual she has personally met. Distance is no object,
 * but it must be night wherever the target presently is. The vampire can sing, talk, or otherwise project her voice in
 * any way she sees fit (including other uses of Melpominee), but she cannot hear what she is saying,
 * and therefore suffers a +1 difficulty to any rolls accompanying her utterance. For instance, the vampire could
 * project her voice to an enemy in an attempt to intimidate him, but would suffer a +1 to the difficulty of the Charisma + Intimidation roll.
 *
 * The Daughter selects a mob from their guestbook and sends a message to them, provided she succedes a Wits + Performance roll. The next N messages
 * do not require a roll and do not expend blood
 *
 */
/datum/storyteller_roll/phantom_speaker
	bumper_text = "незримый собеседник"
	difficulty = 7
	successes_needed = 1
	applicable_stats = list(STAT_WITS, STAT_PERFORMANCE)
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER
	spammy_roll = TRUE

/datum/discipline_power/melpominee/phantom_speaker
	name = "Незримый собеседник"
	desc = "Донесите свой голос до любого, с кем знакомы, и говорите с ним издалека."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 5 SECONDS
	// the guys we last talked to
	var/list/free_speakers

/datum/discipline_power/melpominee/phantom_speaker/activate()
	. = ..()
	if(!owner.mind.guestbook.known_names) // Who do we know
		to_chat(owner, span_warning("Похоже, сейчас среди ваших знакомых нет никого, с кем можно заговорить...")) // You have no friends.
		return
	// Guys we add to the input below
	var/list/targets = list()

	for(var/mob/living/character in GLOB.player_list)
		if(character == owner) // Skip ourselves
			continue
		if(owner.mind.guestbook.known_names[character.real_name] && character.client) // Everyone we know who has a client
			targets += character

	var/list/mob/living/listener_list = list()
	var/mob/living/listener

	if(!HAS_TRAIT_FROM(owner, TRAIT_VIRTUOSA, type))
		listener = tgui_input_list(owner, "До кого вы хотите донести свой голос?", "Незримый собеседник", targets)
		if(!listener)
			return
		listener_list[WEAKREF(listener)] = 0
	else // We can talk to mulitple people (Melpominee 5)
		listener_list = tgui_input_checkboxes(owner, "До кого вы хотите донести свой голос?", "Незримый собеседник", targets)

	if(!length(listener_list)) // We didn't pick anyone
		return

	var/input_message = tgui_input_text(owner, "Что вы хотите сказать?", title = "Незримый собеседник")
	if (!input_message)
		return

	//sanitisation!
	input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
	if(!owner.try_speak(input_message))
		return

	if(findtext(input_message, "*"))
		to_chat(owner, span_danger("Сила \"[name]\" не передаёт эмоуты!"))
		return

	var/language = owner.get_selected_language()
	var/message = owner.compose_message(owner, language, input_message)
	// Composed message of all the people in listener_list
	var/those_who_hear = "[english_list(listener_list)]."

	var/datum/storyteller_roll/phantom_speaker/roll_datum = new()
	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		roll_datum.difficulty -= 2
	var/roll_result = roll_datum.st_roll(owner)	// CORVAX EDIT

	if(roll_result < ROLL_SUCCESS)
		to_chat(owner, span_notice("Ваш голос не достиг слушателей: [those_who_hear]."))
		return

	var/freebie = FALSE	// CORVAX EDIT
	if(!isnull(free_speakers))
		for(var/mob/living/guy in listener_list)
			if(guy in free_speakers && free_speakers[guy] > 0)
				free_speakers[guy]--
				freebie = TRUE
				break

	if(!freebie)	// CORVAX EDIT
		owner.adjust_blood_pool(-1)

	if(isnull(free_speakers))	// CORVAX EDIT
		free_speakers = list()
	for(var/mob/living/guy in listener_list)
		if(!(guy in free_speakers))	// CORVAX EDIT
			free_speakers[guy] = roll_result

	for(var/mob/living/final_listeners in listener_list)
		to_chat(final_listeners, span_boldannounce("<i>В вашей голове звучит голос...</i>"))
		final_listeners.Hear(owner, language, span_purple(message), message_mods = list(MODE_SING, MODE_TTS_MESSAGE_OVERRIDE = input_message))	// CORVAX EDIT

	to_chat(owner, span_notice("Ваш голос достиг слушателей: [those_who_hear]."))

/**
 * ••• Madrigal - p453-454
 *
 * Music has the power to sway the listener, engendering specific emotions through artful lyrics, pounding crescendo,
 * or haunting melody. The Daughters of Cacophony can tap into music’s power, forcing listeners to feel whatever they wish. The emotion becomes so
 * powerful that the listener must act, though what a listener does isn’t something the Siren can directly control.
 *
 * The Daughter chooses an emotion and anyone who fails a Wits + Awareness check against her roll will begin to feel that emotion
 *
 */
/datum/discipline_power/melpominee/madrigal
	name = "Мадригал"
	desc = "Спойте песнь сирены и подчините себе чувства всех, кто вас слышит."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	cooldown_length = 1 SCENES
	duration_length = 1 SCENES
	var/list/audience = list()

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	var/our_difficulty = 7
	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		our_difficulty -= 2
	var/our_power = SSroll.storyteller_roll_datum(owner, difficulty = our_difficulty, applic_stats = list(STAT_CHARISMA, STAT_PERFORMANCE), numerical = TRUE)	// CORVAX EDIT
	var/list/emotion_labels = aura_emotion_labels()
	var/emotion = emotion_labels[tgui_input_list(owner, "Какое чувство вы хотите пробудить?", "Мадригал", emotion_labels)]

	for(var/mob/living/carbon/member in ohearers(7, owner))
		audience += member
		var/their_difficulty = 7
		if(HAS_TRAIT(member, TRAIT_COLDLY_LOGICAL))
			their_difficulty -= 1
		var/their_power = SSroll.storyteller_roll_datum(member, difficulty = their_difficulty, applic_stats = list(STAT_WITS, STAT_ALERTNESS), numerical = TRUE)	// CORVAX EDIT
		if(our_power > their_power)
			set_emotion(member, emotion)

/datum/discipline_power/melpominee/madrigal/proc/set_emotion(mob/living/target, emotion)
	target.set_emotion(emotion)
	ADD_TRAIT(target, TRAIT_FORCED_EMOTION, type)

	to_chat(target, span_purple("Вас переполняет одно чувство: [GLOB.emotion_to_quality[emotion]]."))
	var/datum/status_effect/forced_emotion/emoji = target.apply_status_effect(/datum/status_effect/forced_emotion)
	emoji.linked_alert.desc = "Что-то заставляет вас целиком отдаться одному чувству: [GLOB.emotion_to_quality[emotion]]."

/datum/discipline_power/melpominee/madrigal/deactivate()
	. = ..()
	for(var/mob/living/carbon/member in audience)
		if(HAS_TRAIT_FROM(member, TRAIT_FORCED_EMOTION, type))
			to_chat(member, span_nicegreen("Чувство, которое вас переполняло, отступает: [GLOB.emotion_to_quality[member.current_emotion]]."))
			REMOVE_TRAIT(member, TRAIT_FORCED_EMOTION, type)
		else if(HAS_TRAIT(member, TRAIT_FORCED_EMOTION))
			to_chat(member, span_nicegreen("Навязанное чувство слабеет: [GLOB.emotion_to_quality[member.current_emotion]]."))
			REMOVE_TRAIT(member, TRAIT_FORCED_EMOTION, type)

	audience = list()

/**
 * •••• Siren's Beckoning  - p454
 *
 * The Daughters of Cacophony don’t spread madness as surely (or as visibly) as the Malkavians, but their songs are definitely
 * detrimental to one’s sanity. With this power, the Daughter can drive any listener to madness. Most of the time, the victim is
 * too fascinated to realize that he should leave the area and block out the music from his mind.
 *
 * The Daughter sings a haunting sound that causes the victim to remain and listen, provided they fail a willpower roll.
 *
 */
/datum/storyteller_roll/sirens_beckoning // Difficulty is the victim's willpower
	bumper_text = "зов сирены"
	applicable_stats = list(STAT_MANIPULATION, STAT_PERFORMANCE)	// CORVAX EDIT
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET
	spammy_roll = TRUE

/datum/storyteller_roll/sirens_beckoning/victim	// CORVAX EDIT
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/melpominee/sirens_beckoning
	name = "Зов сирены"
	desc = "Спойте неземную песнь, от которой цепенеют все вокруг."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	effect_sound = 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg'
	range = 7
	duration_length = 4 TURNS
	cooldown_length = 1 MINUTES
	duration_override = TRUE
	target_type = TARGET_LIVING
	var/list/listener_list = list()
	var/list/listeners_failed = list()
	var/channeling = FALSE
	var/list/cumulative_list = list()
	var/list/cumulative_our_power = list()
	var/turns_left = 4

/datum/discipline_power/melpominee/sirens_beckoning/can_activate(atom/target)
	if(HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		target_type = NONE
	else
		target_type = TARGET_LIVING

	. = ..()

/datum/discipline_power/melpominee/sirens_beckoning/activate(mob/living/target) // TODO: sliding difficulty for willpower
	. = ..()
	setup_particles()
	to_chat(owner, span_purple("Вы затягиваете мелодию, от которой стынет душа."))

	owner.Stun(1 TURNS)
	channeling = TRUE

	if(!HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		if(!target)
			return
	else
		if(!length(ohearers(owner, 7)))
			return

	run_effect(target)

/datum/discipline_power/melpominee/sirens_beckoning/proc/run_effect(mob/living/carbon/target)
	if(turns_left > 0)
		turns_left--
	else
		deactivate(target, TRUE)
		return FALSE
	playsound(owner, 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg', 50)

	if(!HAS_TRAIT(owner, TRAIT_VIRTUOSA))
		listener_list = list(target)
	else
		listener_list = ohearers(owner, 7)

	for(var/mob/living/carbon/listener in listener_list)
		var/our_difficulty = listener.st_get_stat(STAT_PERMANENT_WILLPOWER)	// CORVAX EDIT
		if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
			our_difficulty -= 2
		var/our_power = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/sirens_beckoning, 0, difficulty = our_difficulty)	// CORVAX EDIT
		cumulative_our_power[listener] += our_power

		var/their_difficulty = owner.st_get_stat(STAT_APPEARANCE) + owner.st_get_stat(STAT_PERFORMANCE)
		if(HAS_TRAIT(listener, TRAIT_COLDLY_LOGICAL))
			their_difficulty -= 1
		var/their_power = SSroll.storyteller_roll_datum(listener, owner, /datum/storyteller_roll/sirens_beckoning/victim, 0, difficulty = their_difficulty)
		cumulative_list[listener] += their_power
		if(our_power > their_power && should_run_effect(listener))
			effect(listener)
		else
			listener_list -= listener
			listener.remove_overlay(POWERS_LAYER)
			cumulative_our_power[listener] = null
			cumulative_list[listener] = null

	if(do_after(owner, 1 TURNS, timed_action_flags = IGNORE_HELD_ITEM | IGNORE_INCAPACITATED | IGNORE_SLOWDOWNS) && channeling && length(listener_list))
		run_effect(target)
	else
		deactivate(target, TRUE)

/datum/discipline_power/melpominee/sirens_beckoning/proc/should_run_effect(mob/living/listener)
	if(!owner.can_speak())
		return FALSE
	return TRUE

/datum/discipline_power/melpominee/sirens_beckoning/proc/effect(mob/living/carbon/listener)
	listener.Stun(1 TURNS)
	listener.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/song_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "song", -POWERS_LAYER)
	listener.overlays_standing[POWERS_LAYER] = song_overlay
	listener.apply_overlay(POWERS_LAYER)
	if(cumulative_our_power[listener] >= 20)
		listener.add_quirk(/datum/quirk/darkpack/derangement)

	if(cumulative_list[listener] <= cumulative_our_power[listener]-6)
		if(listener.add_quirk(/datum/quirk/darkpack/derangement))
			addtimer(CALLBACK(src, PROC_REF(remove_derangement), listener), 1 SCENES)

/datum/discipline_power/melpominee/sirens_beckoning/proc/remove_derangement(mob/living/carbon/listener)
	listener.remove_quirk(/datum/quirk/darkpack/derangement)

/datum/discipline_power/melpominee/sirens_beckoning/deactivate(mob/living/carbon/target)
	. = ..()
	for(var/mob/living/carbon/listener in listener_list)
		listener.remove_overlay(POWERS_LAYER)

	owner.visible_message(span_purple("Жуткая песнь [owner.declent_ru(GENITIVE)] смолкает."), span_purple("Вы перестаёте петь."))
	channeling = FALSE
	QDEL_NULL(particle_generator)
	turns_left = 4

	// These can still be a source of hardels if they happen mid ability.
	// But it would need a bigger refactor so we only have to handle 1 weakref/1 list per guy to avoid nightmare code.
	listener_list = list()
	listeners_failed = list()
	cumulative_list = list()
	cumulative_our_power = list()

/**
 * ••••• Shattering Crescendo - p454
 *
 * Most of the low-level Melpominee powers can only be used on one target at a time.
 * When the Daughter reaches this level of mastery in her Discipline, she can "entertain” a
 * wider audience. Each member of the audience hears the same message.
 *
 * The Siren toggles the ability, augmenting the function of •• Phantom Speaker and •••• Siren's Beckoning
 *
 */
/datum/discipline_power/melpominee/virtuosa
	name = "Виртуозность"
	desc = "Усиливает ваши способности: некоторые силы можно применять сразу к нескольким целям."

	level = 5
	toggled = TRUE
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	vitae_cost = 0

/datum/discipline_power/melpominee/virtuosa/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_VIRTUOSA, type)

/datum/discipline_power/melpominee/virtuosa/deactivate(atom/target, direct)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_VIRTUOSA, type)

/**
 * ••••• • Shattering Crescendo - p454
 *
 * The Daughter can sing powerfully enough to rend flesh, split skin, and crack bone. While some Kindred unfortunate enough to witness
 * this power make reference to the fact that even mortal singers can shatter glass at the right frequency, others note that volume and
 * intensity don’t seem to matter when a Daughter employs Shattering Crescendo. The Siren can sing a soothing lullaby and still kill a target.
 *
 * The Siren selects a target and deals a high amount of damage in brute and to the target's ears.
 *
 */
/datum/discipline_power/melpominee/death_of_the_drum
	name = "Пронзительное крещендо"
	desc = "Издайте крик немыслимой высоты, от которого ломаются тела ваших врагов."

	level = 6
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	target_type = TARGET_MOB

	effect_sound = null // Sound handled by activate

	range = 7
	duration_length = 1 TURNS
	cooldown_length = 3 TURNS

/datum/discipline_power/melpominee/death_of_the_drum/activate(mob/living/carbon/human/target)	// CORVAX EDIT
	. = ..()
	playsound(owner, 'modular_darkpack/modules/powers/sounds/melpominee/melpominee.ogg', 50)

	if(!ishuman(target))
		return

	var/difficulty = target.st_get_stat(STAT_STAMINA) + 3
	var/successes = SSroll.storyteller_roll_datum(owner, target, difficulty = difficulty, applic_stats = list(STAT_MANIPULATION, STAT_INTIMIDATION), numerical = TRUE)

	if(successes <= 0)
		to_chat(owner, span_warning("Ваш крик не достигает нужной частоты, чтобы ранить [target.declent_ru(ACCUSATIVE)]."))
		to_chat(target, span_notice("Пронзительный вопль [owner.declent_ru(GENITIVE)] заставляет вас вздрогнуть, но вреда не наносит."))
		return

	var/damage = successes
	target.apply_damage(damage * 10, AGGRAVATED, BODY_ZONE_HEAD)
	target.Stun(1 TURNS)
	target.sound_damage(damage * 5, 3 TURNS)

	target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/song_overlay = mutable_appearance('modular_darkpack/modules/deprecated/icons/icons.dmi', "song", -POWERS_LAYER)
	target.overlays_standing[POWERS_LAYER] = song_overlay
	target.apply_overlay(POWERS_LAYER)

	addtimer(CALLBACK(src, PROC_REF(deactivate), target), 1 TURNS)

/datum/discipline_power/melpominee/death_of_the_drum/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)
