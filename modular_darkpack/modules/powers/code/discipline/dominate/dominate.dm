#define TRAIT_MESMERIZED "mesmerized"

/datum/discipline/dominate
	name = "Доминирование"
	desc = {"Подавляет волю жертв и заставляет их подчиняться вам, если только их воля не сильнее вашей.
● Приказ: Манипуляция + Запугивание
●● Внушение: Манипуляция + Лидерство
●●● Забвение: Смекалка + Хитрость
●●●● Порабощение: Обаяние + Лидерство
●●●●● Вселение: Обаяние + Запугивание
●●●●● ● Власть над телом: Обаяние + Лидерство"}	// CORVAX EDIT
	icon_state = "dominate"
	power_type = /datum/discipline_power/dominate
	var/list/botched_targets //a lazylist of weakrefs

/datum/discipline/dominate/post_gain(post_gain_applied)
	. = ..()
	if(level >= 4)
		RegisterSignal(owner, COMSIG_MOB_EMOTE, PROC_REF(on_snap))

/datum/discipline/dominate/post_loss()
	UnregisterSignal(owner, COMSIG_MOB_EMOTE)
	return ..()

/datum/discipline/dominate/proc/on_snap(atom/source, datum/emote/emote_args)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_snap), source, emote_args)

/datum/discipline/dominate/proc/handle_snap(atom/source, datum/emote/emote_args)
	var/list/emote_list = list("snap", "snap2", "snap3", "whistle")
	if(!emote_list.Find(emote_args.key))
		return
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, owner))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(conditioner != owner)
			continue
		switch(emote_args.key)
			if("snap")
				target.SetSleeping(0)
				target.dir = get_dir(target, owner)
				target.emote("me", 1, "внимательно поворачивается к <b>[owner.declent_ru(DATIVE)]</b>.", TRUE)
				to_chat(target, span_phobia("ВНИМАНИЕ"))
				target.dominate_feedback("ВНИМАНИЕ") // CORVAX EDIT
			if("snap2")
				target.dir = get_dir(target, owner)
				target.Immobilize(50)
				target.emote("me",1,"вздрагивает от щелчка пальцев <b>[owner.declent_ru(GENITIVE)]</b>.", TRUE)
				to_chat(target, span_phobia("СТОЯТЬ"))
				target.dominate_feedback("СТОЯТЬ") // CORVAX EDIT
			if("snap3")
				target.Knockdown(50)
				target.Immobilize(80)
				target.emote("me",1,"оседает на подкосившихся коленях.",TRUE)
				target.do_jitter_animation(0.1 SECONDS)
				to_chat(target, span_phobia("ЛЕЖАТЬ"))
				target.dominate_feedback("ЛЕЖАТЬ") // CORVAX EDIT
			if("whistle")
				target.apply_status_effect(STATUS_EFFECT_AWE, owner)
				to_chat(target, span_phobia("КО МНЕ"))
				target.dominate_feedback("КО МНЕ") // CORVAX EDIT


/datum/discipline_power/dominate
	name = "Dominate power name"
	desc = "Dominate power description"
	vitae_cost = 0 //No Dominate 1-5 abilities cost blood.
	frenzy_usable = FALSE

	activate_sound = 'modular_darkpack/modules/powers/sounds/dominate.ogg'

/datum/discipline_power/dominate/activate(mob/living/carbon/human/target)
	. = ..()

	var/mob/living/carbon/human/dominate_target = target
	dominate_target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/dominate_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/dominate.dmi', "dominate", -POWERS_LAYER)
	dominate_overlay.pixel_z = 2
	dominate_target.overlays_standing[POWERS_LAYER] = dominate_overlay
	dominate_target.apply_overlay(POWERS_LAYER)

	//dominate compels the target to have their gaze absolutely entrapped by the dominator
	dominate_target.face_atom(owner)
	to_chat(dominate_target, span_phobia("Взгляд [owner.declent_ru(GENITIVE)] приковывает вас целиком. Вы не в силах ни отвести глаза, ни позвать на помощь, ни хотя бы попытаться сопротивляться. Молитесь, чтобы кто-нибудь пришёл на выручку и оттащил или оттолкнул вас."))	// CORVAX EDIT
	owner.face_atom(dominate_target)
	addtimer(CALLBACK(dominate_target, TYPE_PROC_REF(/mob/living/carbon/human, post_dominate_checks), dominate_target), 2 SECONDS)
	return TRUE

//dicerolling
//all dominate rolls involve rolling some stat against the victim's permanent willpower with many caveats. this proc rolls and considers those caveats
/datum/discipline_power/dominate/proc/dominate_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, owner_stat = list(), numerical = FALSE)
	var/datum/discipline/dominate/parent_disc = discipline

	if(HAS_TRAIT(owner, TRAIT_NO_EYE_CONTACT))
		to_chat(owner, span_warning("Вам не удаётся встретиться взглядом!"))
		return FALSE

	//someone has botched a dominate against this human
	if(LAZYLEN(parent_disc.botched_targets))
		for(var/datum/weakref/ref in parent_disc.botched_targets)
			var/mob/living/carbon/human/botched = ref.resolve()
			if(!botched)
				LAZYREMOVE(parent_disc.botched_targets, ref)
				continue
			if(botched == target)
				to_chat(owner, span_warning("После вашего прошлого провала [target.declent_ru(NOMINATIVE)] до конца ночи не поддаётся вашему Доминированию."))
				return FALSE

	//automatically succeed against my conditioned servant
	var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
	if(owner == conditioner)
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	if(HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	var/theirpower = target.st_get_stat(STAT_PERMANENT_WILLPOWER)	// CORVAX EDIT

	if(HAS_TRAIT(target, TRAIT_IN_FRENZY))	// CORVAX EDIT
		to_chat(owner, span_warning("Зверь в [target.declent_ru(PREPOSITIONAL)] не подчиняется Доминированию — цель в Ярости."))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_IRON_WILL))
		theirpower += 3

	//tremere have built-in safeguards to easily dominate their stone servitors
	if(HAS_TRAIT(target, TRAIT_WEAK_TO_DOMINATE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_WEAK_WILLED))
		theirpower -= 2

	if((!(owner.obscured_slots & HIDEFACE))&(HAS_TRAIT(owner, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		theirpower += 2

	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		theirpower += 15

	if(!get_kindred_splat(target)) // Is our target mortal?
		if(HAS_TRAIT(owner, TRAIT_GRAVE_SMELL)) // Are we stinky?
			theirpower += 1
		if((HAS_TRAIT(owner, TRAIT_GLOWING_EYES)) && (!owner.is_eyes_covered()) && (STAT_INTIMIDATION in owner_stat)) // Are we intimidating a mortal with uncovered eyes?
			theirpower -= 1

	//wearing dark sunglasses makes it harder for the Dominator to capture the victim's gaze and raises difficulty -- V20 'Dominate' section titled 'Eye Contact'
	var/total_tint = 0
	var/mob/living/carbon/human/human_target = target
	for(var/obj/item/clothing/worn_item in human_target.get_equipped_items(INCLUDE_ABSTRACT))
		total_tint += worn_item.tint

	if(total_tint > 0)
		if(total_tint >= 2)
			theirpower += 2
		else
			theirpower += 1

	//if anyone else tries to dominate my conditioned servant its much harder for them but not for me
	if(target.conditioner?.resolve())
		theirpower += 3

	// This var needs to go after everything that changes theirpower.
	var/mypower = SSroll.storyteller_roll_datum(owner, target, difficulty = theirpower, applic_stats = owner_stat, numerical = TRUE)

	//i've botched so now this person is immune to dominate for the rest of the round
	if(mypower < 0)
		LAZYADD(parent_disc.botched_targets, WEAKREF(target))
		to_chat(owner, span_warning("Попытка Доминирования обернулась провалом! Теперь [target.declent_ru(NOMINATIVE)] до конца ночи не поддаётся вашему Доминированию."))
		return FALSE

	var/datum/splat/vampire/kindred/owner_splat = get_kindred_splat(owner)
	var/datum/splat/vampire/kindred/target_splat = get_kindred_splat(target)
	if(target_splat)
		if(owner_splat.generation > target_splat.generation)
			to_chat(owner, span_warning("Подчинить [target.declent_ru(ACCUSATIVE)] не удаётся: [target.ru_p_them()] кровь сильнее вашей!"))
			return FALSE

	if(HAS_TRAIT(target, TRAIT_MERIT_UNTAMABLE))
		to_chat(owner, span_warning("Подчинить [target.declent_ru(ACCUSATIVE)] не удаётся: этого зверя не укротить!"))
		return FALSE

	if(numerical == TRUE)
		return mypower

	//did we succeed or fail the roll
	return (mypower > 0)

//dominate involves capturing the victim's gaze, leaving them completely helpless as you hypnotically invade their mind.
/datum/discipline_power/dominate/proc/immobilize_target(mob/living/carbon/human/target, duration = 5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)
	target.dominate_feedback("Взгляд сковал вас!") // CORVAX EDIT
	ADD_TRAIT(target, TRAIT_PACIFISM, "dominate") // CRIMSON EDIT ADD - DOM PACIFY
	RegisterSignals(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(on_target_attacked))
	if(do_after(owner, duration, target))
		release_target(target)
		return TRUE
	else
		release_target(target)
		return FALSE

/datum/discipline_power/dominate/proc/on_target_attacked(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/target = source
	release_target(target)
	to_chat(owner, span_warning("На [target.declent_ru(ACCUSATIVE)] напали, и ваша сосредоточенность нарушена!"))
	to_chat(target, span_phobia("На вас напали, и чужая хватка на вашем разуме разжимается!"))	// CORVAX EDIT

/datum/discipline_power/dominate/proc/release_target(mob/living/carbon/human/target)
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
	to_chat(target, span_phobia("Ваши мысли снова принадлежат вам, и от властного взгляда наконец можно отвести глаза."))	// CORVAX EDIT
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)
	REMOVE_TRAIT(target, TRAIT_PACIFISM, "dominate") // CRIMSON EDIT ADD - DOM PACIFY

/mob/living/carbon/human/proc/post_dominate_checks(mob/living/carbon/human/dominate_target)
	dominate_target?.remove_overlay(POWERS_LAYER)

// CRIMSON EDIT ADD START - Dominate Feedback
/// Combat-visible Dominate cue: purple screen flash plus floating text above the victim, shown only to the victim.
/mob/living/carbon/human/proc/dominate_feedback(text)
	flash_color(src, "#b066ff", 2 SECONDS)
	balloon_alert(src, html_encode(text))
// CRIMSON EDIT ADD END - Dominate Feedback

//COMMAND
/datum/discipline_power/dominate/command
	name = "Приказ"
	desc = "Произнесите одно слово, и вам подчинятся."
	level = 1
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 7
	var/successes
	var/custom_command = ""

//successes for dominate 1
/datum/discipline_power/dominate/command/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "слабое рвение, недолгое действие"
		if(2)
			return "обычное принуждение"
		if(3)
			return "заметное рвение, продолжительное действие"
		if(4)
			return "большое рвение, долгое действие"
		if(5)
			return "сверхъестественное рвение"
		else
			return "немедленное и ревностное исполнение"

/datum/discipline_power/dominate/command/pre_activation_checks(mob/living/carbon/human/target)

	custom_command = tgui_input_text(owner, "Приказ Доминирования", "Каков ваш приказ?", encode = FALSE)
	owner.say(custom_command)

	successes = dominate_check(owner, target, list(STAT_MANIPULATION, STAT_INTIMIDATION), numerical = TRUE)
	if(successes > 0)
		var/command_strength = get_success_message(successes)
		to_chat(owner, span_notice("Ваш Приказ подействует на цель. Сила воздействия: [command_strength]!"))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(owner != conditioner)
			//V20 Dominate 'Command' section
			if(length(splittext(custom_command, " ")) > 1)
				to_chat(owner, span_warning("Приказ должен состоять из ОДНОГО слова!"))
				return FALSE
		if(!custom_command)
			return FALSE
		return TRUE

	to_chat(owner, span_warning("[capitalize(target.declent_ru(NOMINATIVE))] сопротивляется вашему Доминированию!"))
	to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] пристально смотрит на вас."))	// CORVAX EDIT
	do_cooldown(TRUE)
	return FALSE

/datum/discipline_power/dominate/command/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("Вы подчинили себе разум [target.declent_ru(GENITIVE)]!"))
	log_combat(owner, target, "Dominated with Command: [custom_command]")
	to_chat(target, span_phobia("[custom_command]"))
	target.dominate_feedback("Приказ: [custom_command]") // CORVAX EDIT
	var/command_strength = get_success_message(successes)
	to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] подчиняет ваш разум (успехов: [successes]). Вы не в силах ослушаться приказа \"[custom_command]\". Сила воздействия: [command_strength]."))	// CORVAX EDIT
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// MESMERIZE
/datum/discipline_power/dominate/mesmerize
	name = "Внушение"
	desc = "Заложите в голову цели гипнотическое внушение, которое будет снова и снова отдаваться эхом в её разуме."
	level = 2
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 30 SECONDS
	range = 7
	var/custom_message = ""
	var/pulse_interval
	var/datum/weakref/current_target_ref
	var/datum/weakref/end_action_ref
	var/pulse_active = FALSE

/datum/discipline_power/dominate/mesmerize/pre_activation_checks(mob/living/carbon/human/target)
	//you can't mesmerize someone already mesmerized
	if(HAS_TRAIT(target, TRAIT_MESMERIZED))
		to_chat(owner, span_warning("[capitalize(target.declent_ru(NOMINATIVE))] уже находится под гипнотическим внушением!"))
		return FALSE

	if(pulse_active)
		to_chat(owner, span_warning("Одно ваше Внушение уже действует!"))
		return FALSE

	var/successes = dominate_check(owner, target, list(STAT_MANIPULATION, STAT_LEADERSHIP), numerical = TRUE)
	if(successes > 0)
		custom_message = tgui_input_text(owner, "Гипнотическое внушение", "Какие слова будут звучать эхом в чужом разуме?", encode = FALSE)
		if(!custom_message)
			return FALSE
		pulse_interval = successes
		return TRUE
	pulse_interval = 0

	to_chat(owner, span_warning("[capitalize(target.declent_ru(NOMINATIVE))] сопротивляется вашему Доминированию!"))
	to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] пристально смотрит на вас."))

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/mesmerize/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_warning("Сосредоточенность нарушена: внушить что-либо [target.declent_ru(DATIVE)] не удалось!"))
		return
	target.throw_alert("mesmerize", /atom/movable/screen/alert/mesmerize)
	log_combat(owner, target, "Dominated with Mesmerize: [custom_message]")
	to_chat(owner, span_warning("Вы заложили гипнотическое внушение в разум [target.declent_ru(GENITIVE)]!"))
	owner.say(custom_message)
	to_chat(target, span_phobia("В вашем разуме засела настойчивая мысль, идущая откуда-то из подсознания. Вы не понимаете, откуда она взялась, но она пульсирует снова и снова и подчиняет себе все остальные мысли."))	// CORVAX EDIT
	to_chat(target, span_hypnophrase(custom_message))
	target.dominate_feedback(custom_message) // CORVAX EDIT
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	current_target_ref = WEAKREF(target)
	ADD_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)

	//allow the dominator to end the mesmerization pulses early if the target completes the directive, assuming its an objective rather than a hypnotic suggestion (which is allowed)
	var/datum/action/vampire/end_mesmerization/end_action = new(owner, src)
	end_action.Grant(owner)
	end_action_ref = WEAKREF(end_action)
	pulse_active = TRUE
	start_mesmerization_cycle(target)

/datum/discipline_power/dominate/mesmerize/proc/start_mesmerization_cycle(mob/living/carbon/human/target)
	if(!pulse_active)
		return

	//the message pangs in the victim's mind every couple minutes depending on successes rolled.
	var/interval_minutes = max(1, 5 - pulse_interval)
	var/interval_deciseconds = interval_minutes * 60 * 10
	addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval_deciseconds, 1), interval_deciseconds)

/datum/discipline_power/dominate/mesmerize/proc/mesmerization_pulse(mob/living/carbon/human/target, interval, pulse_count)
	if(!pulse_active || !target || target.stat == DEAD)
		if(target)
			REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		cleanup_mesmerization()
		return

	to_chat(target, span_hypnophrase("<b>[custom_message]</b>"))	// CORVAX EDIT
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg', volume = 30))
	target.dominate_feedback(custom_message) // CORVAX EDIT

	//once its pulsed 5 times, end the mesmerization. we don't need people seeing 'shit yourself' every minute til roundend.
	if(pulse_count >= 5)
		REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		to_chat(target, span_phobia("Пульсация внушённой мысли стихает: то ли мысль пустила корни, то ли тихо угасла. Сознание понемногу возвращается в обычное состояние."))	// CORVAX EDIT
		cleanup_mesmerization()
		return

	if(pulse_active)
		addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval, pulse_count + 1), interval)

//for use in the /datum/action/vampire/end_mesmerization
/datum/discipline_power/dominate/mesmerize/proc/force_end_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	if(!current_target || !pulse_active)
		return
	pulse_active = FALSE
	REMOVE_TRAIT(current_target, TRAIT_MESMERIZED, TRAIT_GENERIC)
	to_chat(current_target, span_hypnophrase("<font size='4'><b>[custom_message]</b></font>"))
	to_chat(current_target, span_phobia("Пульсация внушённой мысли стихает: то ли мысль пустила корни, то ли тихо угасла. Сознание понемногу возвращается в обычное состояние."))	// CORVAX EDIT
	current_target.clear_alert("mesmerize")
	cleanup_mesmerization()

/datum/discipline_power/dominate/mesmerize/proc/cleanup_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	pulse_active = FALSE
	if(current_target)
		current_target.clear_alert("mesmerize")
	current_target_ref = null
	var/datum/action/vampire/end_mesmerization/action = end_action_ref?.resolve()
	if(action)
		action.Remove(owner)
	end_action_ref = null

/datum/action/vampire/end_mesmerization
	name = "Прервать Внушение"
	desc = "Досрочно прекратить действующее Внушение."
	button_icon_state = "dominate"
	var/datum/discipline_power/dominate/mesmerize/linked_power

/datum/action/vampire/end_mesmerization/New(Target, datum/discipline_power/dominate/mesmerize/power)
	..()
	linked_power = power

/datum/action/vampire/end_mesmerization/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	if(!linked_power)
		Remove(owner)
		return FALSE
	linked_power.force_end_mesmerization()

// THE FORGETFUL MIND
/datum/discipline_power/dominate/the_forgetful_mind
	name = "Забвение"
	desc = "Вторгнитесь в чужой разум и перекроите воспоминания."
	level = 3
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 1 MINUTES
	duration_length = 3 SECONDS
	range = 7
	var/custom_memory = ""
	var/successes

/datum/discipline_power/dominate/the_forgetful_mind/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "одно воспоминание стирается навсегда, но его место ничто не занимает, и при подходящих обстоятельствах подлинная память может всплыть из этой пустоты"
		if(2)
			return "несколько воспоминаний можно стереть навсегда, но не изменить, и подлинная память способна вернуться из пустоты, если жертва будет упорно вспоминать"
		if(3)
			return "несколько воспоминаний можно навсегда изменить или стереть, но без тонкой и точной работы подлинная память со временем может проступить снова"
		if(4)
			return "память поддаётся глубоким и сильным изменениям: можно стереть или целиком переписать целые события и разговоры"
		if(5 to INFINITY)
			return "подсознание рушится полностью, и можно перекроить или стереть целые периоды жизни"

/datum/discipline_power/dominate/the_forgetful_mind/pre_activation_checks(mob/living/carbon/human/target)

	successes = dominate_check(owner, target, list(STAT_WITS, STAT_SUBTERFUGE), numerical = TRUE)
	if(successes > 0)
		var/mindwipe_strength = get_success_message(successes)
		to_chat(owner, span_notice("Ваш гипнотический взгляд завладел разумом [target.declent_ru(GENITIVE)]: [mindwipe_strength]."))
		custom_memory = tgui_input_text(owner, "Изменение памяти", "Какое воспоминание вы вложите или измените?", encode = FALSE)
		if(!custom_memory)
			return FALSE
		return TRUE
	to_chat(owner, span_warning("[capitalize(target.declent_ru(NOMINATIVE))] сопротивляется вашему Доминированию!"))
	to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] пристально смотрит на вас."))	// CORVAX EDIT
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/the_forgetful_mind/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_danger("Сосредоточенность нарушена, и подчинить [target.declent_ru(ACCUSATIVE)] не удаётся..."))
		return
	log_combat(owner, target, "Dominated with The Forgetful Mind: [custom_memory]")
	to_chat(owner, span_warning("Вы вторглись в разум [target.declent_ru(GENITIVE)] и изменили [target.ru_p_them()] воспоминания!"))
	owner.say(custom_memory, forced = FALSE, bubble_type = SPEECH_BUBBLE_TYPE)
	to_chat(target, span_hypnophrase(custom_memory))
	target.dominate_feedback("Ваша память изменена") // CORVAX EDIT
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	SEND_SIGNAL(target, COMSIG_ALL_MASQUERADE_REINFORCE)
	var/mindwipe_strength = get_success_message(successes)
	to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] подчиняет ваш разум (успехов: [successes]). Сила гипноза такова: [mindwipe_strength]."))	// CORVAX EDIT

// CONDITIONING
/datum/discipline_power/dominate/conditioning
	name = "Порабощение"
	desc = "Постепенно сломите чужой разум и подчините его своей воле."
	level = 4
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 6 SECONDS
	range = 2

/datum/discipline_power/dominate/conditioning/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target, list(STAT_CHARISMA, STAT_LEADERSHIP))
	if(!roll_success)
		to_chat(owner, span_warning("Разум [target.declent_ru(GENITIVE)] сопротивляется вашему Доминированию!"))
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/conditioning/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_phobia("СМОТРИ НА МЕНЯ"))	// CORVAX EDIT
	owner.say("Смотри на меня.")
	if(!immobilize_target(target, 20 SECONDS))
		to_chat(owner, span_warning("Ваша сосредоточенность нарушена!"))
		to_chat(target, span_phobia("Гнетущее чужое присутствие внезапно покидает ваш разум."))	// CORVAX EDIT
		return
	target.conditioner = WEAKREF(owner)
	target.throw_alert("conditioning", /atom/movable/screen/alert/conditioning)
	to_chat(target, span_hypnophrase("Все ваши мысли занимает [owner.declent_ru(NOMINATIVE)]. Каждое [owner.ru_p_them()] слово, каждый жест полны для вас огромного значения."))
	target.dominate_feedback("Вы порабощены") // CORVAX EDIT
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// POSSESSION
/datum/discipline_power/dominate/possession
	name = "Вселение"
	desc = "Полностью подчините себе разум и тело цели."
	level = 5
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 5 MINUTES
	range = 7
	var/datum/weakref/active_possession

/datum/discipline_power/dominate/possession/pre_activation_checks(mob/living/carbon/human/target)

	if(get_kindred_splat(target) || get_garou_splat(target)) // DARKPACK TODO: reimplement Kuei-Jin
		to_chat(owner, span_warning("Нельзя вселиться в [get_kindred_splat(target) ? "другого Сородича" : "это существо: зверь внутри него сопротивляется"]!"))
		return FALSE

	if(target.possessed)
		to_chat(owner, span_warning("В этого смертного уже кто-то вселился!"))
		return FALSE

	var/roll_success = dominate_check(owner, target, list(STAT_CHARISMA, STAT_INTIMIDATION))
	if(!roll_success)
		to_chat(owner, span_warning("[capitalize(target.declent_ru(NOMINATIVE))] сопротивляется вашему Доминированию!"))
		to_chat(target, span_phobia("[capitalize(owner.declent_ru(NOMINATIVE))] пристально смотрит на вас."))	// CORVAX EDIT
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/possession/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_phobia("Тело цепенеет: в ваш разум вторгается чья-то неодолимая воля..."))	// CORVAX EDIT

	to_chat(owner, span_warning("Вы начинаете вплетать своё сознание в разум [target.declent_ru(GENITIVE)]..."))

	if(!immobilize_target(target, 30 SECONDS))
		to_chat(owner, span_warning("Ваша сосредоточенность нарушена!"))
		to_chat(target, span_notice("Гнетущее чужое присутствие внезапно покидает ваш разум."))
		return
	var/datum/possession_controller/controller = new(owner, target, src)
	active_possession = WEAKREF(controller)
	to_chat(owner, span_warning("Вы завладели телом [target.declent_ru(GENITIVE)]!"))
	to_chat(target, span_phobia("Чужой разум грубо вытесняет ваше сознание и забирает власть над телом!"))
	target.dominate_feedback("Ваше тело захвачено") // CORVAX EDIT
	target.possessed = TRUE
	log_combat(owner, target, "Possessed via Dominate Possession")
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

//AUTONOMIC MASTERY
/datum/discipline_power/dominate/autonomic_mastery
	name = "Власть над телом"
	desc = "Управляйте непроизвольными функциями тела цели."

	level = 6

	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE	// CORVAX EDIT
	target_type = TARGET_HUMAN

	cooldown_length = 15 SECONDS
	range = 7

/datum/discipline_power/dominate/autonomic_mastery/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target, list(STAT_CHARISMA, STAT_LEADERSHIP))	// CORVAX EDIT
	if(roll_success)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/autonomic_mastery/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("Вы подчинили себе тело [target.declent_ru(GENITIVE)]!"))
	var/list/orders = list("Удушье", "Дыхание", "Сон", "Пробуждение")	// CORVAX EDIT
	var/order = tgui_input_list(owner, "Выберите приказ","Выбор приказа", orders)
	if(!order)
		return
	switch(order)	// CORVAX EDIT
		if("Удушье")
			owner.say("Задохнись")
			target.adjust_oxy_loss(80, FALSE)
			target.adjust_stamina_loss(90, FALSE)
			target.emote("gasp")
			to_chat(target, span_phobia("Горло сжимается: вы не можете вдохнуть!"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Дыхание")
			owner.say("Дыши")
			target.adjust_oxy_loss(-60, FALSE)
			to_chat(target, span_phobia("Воздух с силой врывается в лёгкие!"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Сон")
			owner.say("Спи")
			target.Sleeping(200)
			to_chat(target, span_phobia("На вас внезапно наваливается усталость"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("Пробуждение")
			owner.say("Проснись")
			target.SetSleeping(0)
			to_chat(target, span_phobia("Вас внезапно переполняет бодрость"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

#undef TRAIT_MESMERIZED
