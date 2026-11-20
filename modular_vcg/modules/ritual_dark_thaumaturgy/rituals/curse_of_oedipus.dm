/obj/ritual_rune/dark/curse_of_oedipus
	name = "curse of oedipus"
	ru_name = "Проклятие Эдипа"
	desc = "Полностью ослепляет вашу цель."
	icon_state = "rune6"
	word = "OED'IPI"
	level = 1
	sacrifices = list(/obj/item/flashlight/flare/candle) // There's no incense

/obj/ritual_rune/dark/curse_of_oedipus/complete()
	. = ..()
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		var/target_name = tgui_input_text(user, "Выберите имя цели:", "Руна проклятия")
		if(!target_name || !user.Adjacent(src)) // Check if user is still nearby
			to_chat(user, span_warning("Вы должны указать цель и оставаться рядом с руной!"))
			return
		for(var/mob/living/carbon/human/human_target in GLOB.player_list)
			if(human_target.real_name == target_name)
				var/duration = (5 - human_target.st_get_stat(STAT_STAMINA)) SCENES
				if(duration <= 0)
					log_combat(last_activator, human_target, "Неудачное проклятие Эдипа")
					to_chat(user, span_warning("Цель слишком сильна, ритуал не может закрепиться."))
					qdel(src)
					return
				human_target.apply_status_effect(/datum/status_effect/curse_of_oedipus, duration)
				log_combat(last_activator, human_target, "Проклятие Эдипа")
				playsound(human_target.loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
		to_chat(user, span_warning("Такой цели нет, ритуал не может закрепиться."))
		qdel(src)
