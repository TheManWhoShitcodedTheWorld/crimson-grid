/datum/storyteller_roll/eye_drink
	bumper_text = "питьё глаз"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	numerical = TRUE

/datum/action/cooldown/power/gift/eye_drink
	name = "Питьё глаз"
	desc = "Выпейте глаза мертвеца, чтобы узнать тайну его гибели."
	button_icon_state = "eye_drink"
	cooldown_time = 1 SCENES
	innate_ability = TRUE
	click_to_activate = TRUE

/datum/action/cooldown/power/gift/eye_drink/Activate(atom/target)
	var/mob/living/carbon/human/human_target = astype(target)
	if(!human_target)
		return
	if(!(human_target in range(1, owner)))
		return
	if(human_target.stat != DEAD)
		to_chat(owner, span_warning("Этот Дар действует только на мертвецов."))
		return
	var/obj/item/organ/eyes/victim_eyeballs = human_target.get_organ_slot(ORGAN_SLOT_EYES)
	if(!victim_eyeballs)
		to_chat(owner, span_warning("У этого трупа нет глаз, пить нечего!"))
		return

	. = ..()

	if(!do_after(owner, 1 TURNS))
		return TRUE

	var/datum/storyteller_roll/eye_drink/roll_datum = new()
	var/successes = roll_datum.st_roll(owner, human_target)

	var/mob/prompting_mob
	if(human_target.client)
		prompting_mob = human_target
	else
		prompting_mob = human_target.get_ghost(TRUE, TRUE)

	if(prompting_mob)
		var/permission = tgui_alert(prompting_mob, "Позволите ли вы персонажу [owner.real_name] увидеть вашу смерть? Проверка Восприятие + Эмпатия принесла успехов: [successes]. (Помните: рассказывать нужно правду, какой её видел ваш персонаж!)", "Выбор", list("Да","Нет","Не помню") ,"Yes", 1 MINUTES)
		if(permission != "Да")
			to_chat(owner, span_warning("Дух явно не желает отдавать вам свои глаза... и вы отступаетесь."))
			return TRUE
	else
		if(successes <= 0)
			return TRUE

	to_chat(owner, span_notice("Вы выпиваете глаза [human_target.declent_ru(GENITIVE)], и ваш разум заполняет видение..."))
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "выпивает глаза мертвеца") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

	var/deathdesc
	if(prompting_mob)
		deathdesc = tgui_input_text(
			prompting_mob,
			"Питьё глаз",
			"Опишите видение последних мгновений перед вашей смертью. Успехов у смотрящего: [successes]. Чем их больше, тем яснее должно быть видение.",
			max_length = 300,
			multiline = TRUE,
			timeout = 5 MINUTES
		)
	else if(human_target.last_death_info)
		var/datum/death_report/death_info = human_target.last_death_info
		var/list/info_list = list()
		if(death_info.area)
			info_list += "Видение начинается здесь: [get_area_name(death_info.area)]."
		if(death_info.last_attacker_name)
			info_list += "На жертву нападает некто, с виду [death_info.last_attacker_name]."
		if(death_info.last_words)
			info_list += "Губы жертвы шевелятся, но слов не разобрать."

		if(death_info.suicide)
			info_list += "Перед вами во всех подробностях встаёт сцена самоубийства."
		else
			info_list += "Видение обрывается раньше, чем становится ясно, как именно пришла смерть."
		deathdesc += jointext(info_list, " ")

	if(!deathdesc)
		to_chat(owner, span_warning("Видение туманно, подробностей почти не разобрать..."))
	else
		to_chat(owner, "Разум затопляют видения: <i>[deathdesc]</i>")

	if(isnpc(human_target)) // Dont have granuliaty for removing one eye and this shows the empty sockets
		qdel(victim_eyeballs)
	else // Fuck a real player a little less.
		victim_eyeballs.apply_scar(pick(LEFT_EYE_SCAR, RIGHT_EYE_SCAR))

	return TRUE
