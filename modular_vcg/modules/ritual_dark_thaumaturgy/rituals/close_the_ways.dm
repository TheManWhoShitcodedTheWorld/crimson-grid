/obj/ritual_rune/dark/close_the_ways
	name = "close the ways"
	ru_name = "Закрыть пути"
	desc = "Обрушивает на вашу цель волну ужасных несчастий."
	icon_state = "rune5"
	word = "VIAS'SEMITAS"
	level = 5
	cost = 1
	var/flames_extinguished = 0
	var/flames_needed = 14
	var/mob/living/carbon/human/owner
	var/mob/living/carbon/human/target
	var/duration

/obj/ritual_rune/dark/close_the_ways/complete()
	. = ..()
	if(ishuman(usr))
		owner = usr
		var/target_name = tgui_input_text(owner, "Выберите имя цели:", "Руна проклятия")
		if(!target_name || !owner.Adjacent(src)) // Check if user is still nearby
			to_chat(owner, span_warning("Вы должны указать цель и оставаться рядом с руной!"))
			return
		if(last_sucess_amount <= 0)
			to_chat(owner, span_warning("Ритуал не может закрепиться."))
			qdel(src)
			return
		duration = last_sucess_amount * 15 MINUTES // Much longer times in lore, but would be unbalanced
		for(var/mob/living/carbon/human/human_target in GLOB.player_list)
			if(human_target.real_name == target_name)
				target = human_target
				RegisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_candle_equip))
				to_chat(owner, span_notice("Ритуал успешен. Теперь погасите [flames_needed] свечей."))
				log_combat(owner, human_target, "Подготовка «Закрыть пути»")
				return
		to_chat(owner, span_warning("Такой цели нет, ритуал не может закрепиться."))
		qdel(src)

/obj/ritual_rune/dark/close_the_ways/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
	return ..()

/obj/ritual_rune/dark/close_the_ways/proc/on_candle_equip(datum/source, obj/item/item)
	SIGNAL_HANDLER

	if(!istype(item, /obj/item/flashlight/flare/candle))
		return
	INVOKE_ASYNC(src, PROC_REF(handle_candle_equip), item)

/obj/ritual_rune/dark/close_the_ways/proc/handle_candle_equip(obj/item/flashlight/flare/candle/candle)
	if(QDELETED(target))
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
		qdel(src)
		return
	if(!owner.Adjacent(src))
		return
	if(!istype(candle))
		return
	if(candle.light_on)
		owner.say(target.real_name)
		candle.visible_message(span_warning("Свеча исчезает в облачке дыма."))
		qdel(candle)
		flames_extinguished++
		to_chat(owner, span_notice("Осталось свечей: [flames_needed-flames_extinguished]."))
	if(flames_extinguished >= flames_needed)
		owner.st_change_stat(STAT_PERMANENT_WILLPOWER, -2)
		to_chat(owner, span_warning("Когда вы гасите последнюю свечу, ритуал закрепляется."))
		log_combat(owner, target, "Закрыть пути")
		UnregisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM)
		target.apply_status_effect(/datum/status_effect/close_the_ways, duration)
		qdel(src)
