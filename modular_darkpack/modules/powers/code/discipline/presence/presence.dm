#define TRAIT_PRESENCE_IMMUNE "presence_immune"

/datum/discipline/presence	// CORVAX EDIT
	name = "Величие"
	desc = {"Сверхъестественное обаяние и игра на чужих чувствах: вы притягиваете, убеждаете и подчиняете себе толпу.
● Благоговение: Обаяние + Исполнение (сложность 7)
●● Устрашающий взор: Обаяние + Запугивание против Смелости + 3
●●● Очарование: Привлекательность + Эмпатия против Воли
●●●● Приглашение: Обаяние + Хитрость (сложность 6 — «встречал один раз»)
●●●●● Преклонение: Обаяние + Запугивание против Смелости + 3 (макс. 10)
●●●●● ● Любовь: Обаяние + Эмпатия против Воли + 3"}
	icon_state = "presence"
	power_type = /datum/discipline_power/presence

/datum/discipline/presence/post_gain(post_gain_applied)
	. = ..()
	ADD_TRAIT(owner, TRAIT_CHARMER, DISCIPLINE_TRAIT(src))

/datum/discipline/presence/post_loss()
	REMOVE_TRAIT(owner, TRAIT_CHARMER, DISCIPLINE_TRAIT(src))
	return ..()

/datum/discipline_power/presence
	name = "Presence power name"
	desc = "Presence power description"
	activate_sound = 'modular_darkpack/modules/powers/sounds/presence_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/presence_deactivate.ogg'
	var/courage = 0	// CORVAX EDIT

//lets not have people be able to cast this through walls


/datum/discipline_power/presence/proc/presence_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, using_stats, difficulty)
	if(!ishuman(target))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_PRESENCE_IMMUNE))
		to_chat(owner, span_warning("Попытка применить Величие к этой цели закончилась провалом: до конца ночи Дисциплина на неё не подействует."))
		return FALSE

	var/theirpower = difficulty || target.st_get_stat(STAT_PERMANENT_WILLPOWER)	// CORVAX EDIT

	// Do we have traits to modify our difficulties?
	if((!(owner.obscured_slots & HIDEFACE))&(HAS_TRAIT(owner, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		theirpower += 2 // Increase the difficulty by two.

	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_COLDLY_LOGICAL))
		theirpower += 1

	if(HAS_TRAIT(target, TRAIT_IN_FRENZY))
		theirpower += 2

	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		theirpower += 10

	if(target.st_get_stat(STAT_COURAGE) > 0)	// CORVAX EDIT
		courage += target.st_get_stat(STAT_COURAGE) + 3

	if(!get_kindred_splat(target)) // Is our target mortal?
		if(HAS_TRAIT(owner, TRAIT_GRAVE_SMELL)) // Are we stinky?
			theirpower += 1
		if((HAS_TRAIT(owner, TRAIT_GLOWING_EYES)) && (!owner.is_eyes_covered()) && (STAT_INTIMIDATION in using_stats)) // Are we intimidating a mortal with uncovered eyes?
			theirpower -= 1

	var/successes = SSroll.storyteller_roll_datum(owner, target, difficulty = theirpower, applic_stats = using_stats, numerical = TRUE)

	//botch
	if(successes < 0)
		ADD_TRAIT(target, TRAIT_PRESENCE_IMMUNE, TRAIT_GENERIC)
		to_chat(owner, span_warning("Попытка применить Величие к этой цели закончилась провалом: до конца ночи Дисциплина на неё не подействует."))
		return FALSE

	//number of successes is rather critical for the efficacy of the power
	return successes

/datum/discipline_power/presence/proc/apply_presence_overlay(mob/living/carbon/target)
	target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/presence.dmi', "presence", -POWERS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[POWERS_LAYER] = presence_overlay
	target.apply_overlay(POWERS_LAYER)
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/presence_activate.ogg'))

//used in awe - v20 book states that awe affects the targets of lowest willpower first if affecting multiple targets.
/datum/discipline_power/presence/proc/sort_targets_by_willpower(list/targets)
	var/list/sorted = list()
	for(var/mob/living/carbon/target in targets)
		var/target_willpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
		var/inserted = FALSE

		for(var/i = 1; i <= length(sorted); i++)
			var/mob/living/carbon/existing = sorted[i]
			if(target_willpower < existing.st_get_stat(STAT_TEMPORARY_WILLPOWER))
				sorted.Insert(i, target)
				inserted = TRUE
				break

		if(!inserted)
			sorted += target
	return sorted


/datum/storyteller_roll/presence_awe
	difficulty = 7
	applicable_stats = list(STAT_CHARISMA, STAT_PERFORMANCE)
	numerical = TRUE

/datum/storyteller_roll/presence_awe/using_difficulty(mob/living/roller, atom/target)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_ENCHANTING_VOICE))
		. -= 2

// AWE
/datum/discipline_power/presence/awe
	name = "Благоговение"
	desc = "Окружающие восхищаются вами и стремятся быть к вам поближе."
	level = 1
	vitae_cost = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = FALSE
	cancelable = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 1 SCENES
	vitae_cost = 1
	var/successes = 0
	var/list/affected_targets = list()
	frenzy_usable = FALSE

/datum/discipline_power/presence/awe/pre_activation_checks()
	. = ..()

	//charisma + performance
	successes = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/presence_awe)
	if(successes > 0)
		return TRUE

	to_chat(owner, span_warning("Никого вокруг увлечь не удаётся."))
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/awe/activate()
	. = ..()

	var/list/potential_targets = list()
	for(var/mob/living/carbon/target in hearers(range, owner))
		if(target != owner)
			potential_targets += target

	if(!length(potential_targets))
		to_chat(owner, span_warning("Рядом нет никого, кто мог бы вами восхититься."))
		return

	var/list/target_counts = list(1, 2, 6, 20, length(potential_targets)) //V20 core rulebook presence -> awe
	var/targets_to_affect = target_counts[clamp(successes, 1, 5)]

	potential_targets = sort_targets_by_willpower(potential_targets)
	affected_targets = list()

	for(var/i = 1; i <= min(targets_to_affect, length(potential_targets)); i++)
		var/mob/living/carbon/target = potential_targets[i]
		apply_presence_overlay(target)
		to_chat(target, span_yellowteamradio(genderize_decode(owner, "Вас неудержимо тянет к [owner.declent_ru(DATIVE)], и каждое слово звучит убедительно - что бы [owner.ru_p_they()] ни говорил%(,а,о,и)%!")))
		target.apply_status_effect(STATUS_EFFECT_AWE, owner)
		affected_targets += target

	var/affected_count = length(affected_targets)
	if(affected_count > 0)
		to_chat(owner, span_warning("Вы покоряете своим обаянием [affected_count] [declension_ru(affected_count, "человека", "человек", "человек")]!"))
	else
		to_chat(owner, span_warning("Ваше обаяние ни на кого не подействовало."))

/datum/discipline_power/presence/awe/deactivate()
	. = ..()
	for(var/mob/living/carbon/target in affected_targets)
		target.remove_status_effect(STATUS_EFFECT_AWE)
		target.remove_overlay(POWERS_LAYER)
	affected_targets.Cut()

// DREAD GAZE
/datum/discipline_power/presence/dread_gaze
	name = "Устрашающий взор"
	desc = "Одного вашего слова и взгляда довольно, чтобы вселить страх."
	level = 2
	vitae_cost = 1	// CORVAX EDIT
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS
	var/successes = 0


/datum/discipline_power/presence/dread_gaze/pre_activation_checks(mob/living/target)

	successes = presence_check(owner, target, list(STAT_CHARISMA, STAT_INTIMIDATION), difficulty = courage)	// CORVAX EDIT
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	apply_presence_overlay(target)
	to_chat(owner, span_warning("Ваш устрашающий взор вселяет ужас в сердце [target.declent_ru(GENITIVE)]!"))	// CORVAX EDIT

	if(successes >= 3)	// CORVAX EDIT
		var/extended_action_prompt = tgui_input_list(owner, "Заставить жертву сжаться от ужаса? Это длительное действие: оно займёт время, зато оглушит и ослабит противника!", "Устрашение", list("Да", "Нет"), "Нет")
		if(extended_action_prompt == "Да")
			ADD_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
			if(do_after(owner, 3 SECONDS))
				to_chat(owner, span_warning("Одним своим видом вы заставляете [target.declent_ru(ACCUSATIVE)] сжаться от страха!"))
				to_chat(target, span_phobia("Вас захлёстывает всепоглощающий ужас. Ноги подкашиваются, всё внутри переворачивается - остаётся лишь съёжиться перед [owner.declent_ru(INSTRUMENTAL)]!"))
				target.Stun(1 TURNS)
				target.emote("tremble")
				target.emote(pick("scream","cry"))
				target.apply_status_effect(/datum/status_effect/dread_gaze)
			REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
			return TRUE
		to_chat(target, span_phobia("Вас переполняет невыносимый ужас! Прочь, как можно дальше от [owner.declent_ru(GENITIVE)]!"))
		to_chat(owner, span_warning("[target] в ужасе бежит от вас прочь!"))
		GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown, 1 SCENES)
	else if(successes == 2)
		to_chat(target, span_phobia("Вас переполняет невыносимый ужас! Вы вынуждены отступить от [owner.declent_ru(GENITIVE)]!"))
		to_chat(owner, span_warning("[target] в ужасе отступает от вас!"))
		GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown, 6 SECONDS)
	else
		to_chat(target, span_phobia("[owner] внушает вам неодолимый ужас! Вы не в силах поднять на [owner.ru_p_them()] руку до конца сцены."))
		to_chat(owner, span_warning("Ваш взгляд парализует волю [target.declent_ru(GENITIVE)] к сопротивлению."))
		ADD_TRAIT(target, TRAIT_PACIFISM, "Dread Gaze")
		addtimer(CALLBACK(src, PROC_REF(remove_dread_pacifism), target), 1 SCENES)

/datum/discipline_power/presence/dread_gaze/proc/remove_dread_pacifism(mob/living/carbon/human/target)	// CORVAX EDIT
	if(target)
		REMOVE_TRAIT(target, TRAIT_PACIFISM, "Dread Gaze")

/datum/discipline_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// ENTRANCEMENT
/datum/discipline_power/presence/entrancement
	name = "Очарование"
	desc = "Подчиняйте чужой разум, играя на чувствах."
	level = 3
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0
	frenzy_usable = FALSE

/datum/discipline_power/presence/entrancement/pre_activation_checks(mob/living/target)

	successes = presence_check(owner, target, list(STAT_APPEARANCE, STAT_EMPATHY))
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/entrancement/activate(mob/living/carbon/human/target)	// CORVAX EDIT
	. = ..()
	if(!.)
		to_chat(owner, span_warning("Ваши слова, похоже, не очаровали [target.declent_ru(ACCUSATIVE)]."))
		return
	target.throw_alert("entrancement", /atom/movable/screen/alert/entrancement)
	log_combat(owner, target, "Used Presence Entrancement")

	apply_presence_overlay(target)
	to_chat(target, span_hypnophrase(genderize_decode(owner, "[owner] всецело очаровывает вас. Отныне вы с радостью служите %(ему,ей,ему,им)%.")))
	to_chat(target, span_phobia("Теперь вы по доброй воле служите [owner.declent_ru(DATIVE)]: стараетесь угодить и исполнить любое желание. Впрочем, это наваждение скоро пройдёт."))
	addtimer(CALLBACK(src, PROC_REF(end_entrancement), target), successes * 1 MINUTES)

/datum/discipline_power/presence/entrancement/proc/end_entrancement(mob/living/carbon/human/target)
	to_chat(target, span_hypnophrase("Желание во всём угождать [owner.declent_ru(DATIVE)] проходит."))
	target.clear_alert("entrancement")

/datum/discipline_power/presence/entrancement/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// SUMMON
/datum/discipline_power/presence/summon
	name = "Приглашение"
	desc = "Призовите к себе любого, с кем когда-либо встречались."
	level = 4
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 10 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0
	var/mob/living/carbon/human/summon_target
	frenzy_usable = FALSE

/datum/discipline_power/presence/summon/pre_activation_checks(mob/living/target)	// CORVAX EDIT
	var/mob/living/selected_target = owner?.mind?.guestbook.pick_known_guy(owner)
	if(!istype(selected_target))
		to_chat(owner, span_warning("Вы не можете никого призвать."))
		return FALSE

	successes = presence_check(owner, selected_target, list(STAT_CHARISMA, STAT_SUBTERFUGE), 6)
	if(successes > 0)
		summon_target = selected_target
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	if(!. || !summon_target)
		to_chat(owner, span_warning("[summon_target ? summon_target.real_name : "Адресат"] не слышит вашего зова."))
		return

	apply_presence_overlay(summon_target)	// CORVAX EDIT

	var/turf/owner_turf = get_turf(owner)
	var/location_info = "[get_area_name(owner_turf)], X:[owner_turf.x] Y:[owner_turf.y] Z:[owner_turf.z]"
	to_chat(summon_target, span_yellowteamradio("[owner.real_name] зовёт вас к себе. Сейчас [owner.ru_p_they()] здесь: [location_info]"))

	//V20 presence -> 'summon' section for this flavortext
	var/list/flavor_texts = list(
		"[owner.real_name] едва ощутимо манит вас к себе. Вы идёте на зов медленно и нерешительно.",
		"[owner.real_name] зовёт, и вы нехотя отправляетесь на поиски, хотя любое препятствие легко собьёт вас с пути.",
		"[owner.real_name] зовёт, и вас всерьёз тянет откликнуться. Вы идёте на зов, не мешкая.",
		"[owner.real_name] зовёт, и вы спешите на зов, одолевая любые препятствия, но не рискуя собой.",
		"[owner.real_name] зовёт, и важнее этого нет ничего. Вы бросаетесь на зов и пойдёте на всё, лишь бы добраться."
	)

	var/flavor_index = clamp(successes, 1, 5)
	to_chat(summon_target, span_yellowteamradio(flavor_texts[flavor_index]))
	to_chat(summon_target, span_info("Приглашение действует только на тех, кто в самом деле встречался с призывающим. Если ваш персонаж, по логике вещей, никогда с ним не встречался, способность не действует."))
	to_chat(owner, span_warning("[summon_target.real_name] слышит ваш зов! ([successes] [declension_ru(successes, "успех", "успеха", "успехов")])"))
	summon_target.do_jitter_animation(3 SECONDS)

/datum/discipline_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	summon_target?.remove_overlay(POWERS_LAYER)

// MAJESTY
/datum/discipline_power/presence/majesty
	name = "Преклонение"
	desc = "Вы исполнены такого величия, что ослушаться вас или поднять на вас руку почти невозможно."
	level = 5
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 2 MINUTES
	vitae_cost = 0
	willpower_cost = 1
	violates_masquerade = TRUE
	var/list/affected_targets = list()
	frenzy_usable = FALSE

/datum/discipline_power/presence/majesty/pre_activation_checks(mob/living/target)
	return TRUE

/datum/discipline_power/presence/majesty/activate(mob/living/carbon/human/target)	// CORVAX EDIT
	. = ..()
	affected_targets = list()

	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/hearer in get_hearers_in_view(range, owner))
		if(hearer == owner)
			continue
		potential_targets += hearer

	if(!length(potential_targets))
		to_chat(owner, span_warning("Рядом нет никого, кто узрел бы ваше величие."))
		return

	var/highest_courage = 0
	var/mob/living/carbon/human/highest_courage_target = null
	for(var/mob/living/carbon/human/t in potential_targets)
		var/t_courage = t.st_get_stat(STAT_COURAGE)
		if(t_courage > highest_courage)
			highest_courage = t_courage
			highest_courage_target = t
	var/difficulty = min(10, highest_courage + 3)

	var/successes = SSroll.storyteller_roll_datum(owner, highest_courage_target, difficulty = difficulty, applic_stats = list(STAT_CHARISMA, STAT_INTIMIDATION), numerical = TRUE)
	if(successes <= 0)
		to_chat(owner, span_warning("Ваше величие не произвело впечатления."))
		return

	potential_targets = sort_targets_by_willpower(potential_targets)

	var/count = min(successes, length(potential_targets))
	for(var/i = 1; i <= count; i++)
		var/mob/living/carbon/human/hearer = potential_targets[i]
		apply_presence_overlay(hearer)
		affected_targets[hearer] = TRUE
		watch_for_attacks(hearer) // CRIMSON EDIT
		ADD_TRAIT(hearer, TRAIT_PACIFISM, "Majesty")
		to_chat(hearer, span_hypnophrase(genderize_decode(owner, "Величие [owner.declent_ru(GENITIVE)] подавляет вас. Перечить %(ему,ей,ему,им)% трудно. Поднять на [owner.ru_p_theirs()] руку немыслимо.")))

	to_chat(owner, span_warning("Ваше величие подавляет волю [count] [declension_ru(count, "свидетеля", "свидетелей", "свидетелей")]!"))

/datum/discipline_power/presence/majesty/deactivate(mob/living/carbon/human/target)	// CORVAX EDIT
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "Majesty")
	UnregisterSignal(owner, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY))
	for(var/mob/living/carbon/human/affected_target in affected_targets)
		if(affected_target)
			UnregisterSignal(affected_target, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY))
			affected_target.remove_overlay(POWERS_LAYER)
			to_chat(affected_target, span_hypnophrase(genderize_decode(owner, "Подавляющее величие [owner.declent_ru(GENITIVE)] меркнет, и воля возвращается к вам. Вы помните, что %(он,она,оно,они)% с вами сделал%(,а,о,и)%.")))
			REMOVE_TRAIT(affected_target, TRAIT_PACIFISM, "Majesty")
	affected_targets.Cut()

// CRIMSON EDIT ADD START - Majesty pacifism breaks after being attacked
/datum/discipline_power/presence/majesty/proc/watch_for_attacks(mob/living/carbon/human/attacked_mob)
	RegisterSignal(attacked_mob, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damaged))
	RegisterSignal(attacked_mob, COMSIG_ATOM_HITBY, PROC_REF(on_hit_by_thrown))

/datum/discipline_power/presence/majesty/proc/on_damaged(mob/living/carbon/human/attacked_mob, damage, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction)
	SIGNAL_HANDLER
	if(damagetype == STAMINA || isnull(attack_direction))
		return
	break_majesty(attacked_mob)

/datum/discipline_power/presence/majesty/proc/on_hit_by_thrown(mob/living/carbon/human/attacked_mob, atom/movable/hitting_atom)
	SIGNAL_HANDLER
	if(!isitem(hitting_atom))
		return
	var/obj/item/thrown_item = hitting_atom
	if(thrown_item.damtype == STAMINA)
		return
	break_majesty(attacked_mob)

/datum/discipline_power/presence/majesty/proc/break_majesty(mob/living/carbon/human/attacked_mob)
	UnregisterSignal(attacked_mob, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY))
	affected_targets -= attacked_mob
	REMOVE_TRAIT(attacked_mob, TRAIT_PACIFISM, "Majesty")
	if(attacked_mob == owner)
		to_chat(attacked_mob, span_phobia("Кровь и боль разбивают ваше царственное спокойствие. Теперь вы можете дать отпор."))	// CORVAX EDIT
		return
	attacked_mob.remove_overlay(POWERS_LAYER)
	to_chat(attacked_mob, span_phobia("Боль рассеивает наваждение. Теперь вы можете дать отпор."))	// CORVAX EDIT
// CRIMSON EDIT ADD END - Majesty pacifism breaks after being attacked

// LOVE
/datum/discipline_power/presence/love
	name = "Любовь"
	desc = "Влюбите в себя жертву так, словно она связана с вами узами крови."
	level = 6
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 15 SECONDS
	willpower_cost = 1	// CORVAX EDIT
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/love/pre_activation_checks(mob/living/target)

	presence_succeeded = presence_check(owner, target, list(STAT_CHARISMA, STAT_EMPATHY), target.st_get_stat(STAT_PERMANENT_WILLPOWER) + 3)	// CORVAX EDIT
	if(presence_succeeded)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/love/activate(mob/living/carbon/human/target)	// CORVAX EDIT
	. = ..()
	if(!presence_succeeded || HAS_TRAIT(src, TRAIT_UNBONDABLE))
		to_chat(owner, span_warning("Разум [target.declent_ru(GENITIVE)] не поддался вашим чарам!"))
		message_admins("[ADMIN_LOOKUPFLW(target)] has attempted to bloodbond [ADMIN_LOOKUPFLW(src)] (UNBONDABLE/UNBONDING).")
		to_chat(target, span_phobia("От [owner.declent_ru(GENITIVE)] исходит властная аура, требующая любви... но вы ожесточаете сердце и отворачиваетесь от этого противоестественного очарования."))
		log_game("[key_name(target)] has attempted to use love [key_name(src)].")
	else
		target.apply_status_effect(/datum/status_effect/blood_bond, owner)
		to_chat(owner, span_warning("Вы пленили [target.declent_ru(ACCUSATIVE)] и привязали к себе!"))
		message_admins("[ADMIN_LOOKUPFLW(target)] has bloodbonded [ADMIN_LOOKUPFLW(src)].")
		log_game("[key_name(target)] has bloodbonded [key_name(src)] by presence l.6")

#undef TRAIT_PRESENCE_IMMUNE
