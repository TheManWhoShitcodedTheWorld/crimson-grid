/obj/structure/roofstuff
	var/descent_time = 5 SECONDS
	var/vent_context_registered = FALSE

/obj/structure/roofstuff/on_mouse_enter(client/client)
	// Register once on demand, keeping upstream initialization unchanged.
	if(type == /obj/structure/roofstuff && !vent_context_registered)
		register_context()
		vent_context_registered = TRUE
	return ..()

/obj/structure/roofstuff/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(type != /obj/structure/roofstuff)
		return .
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Пролезть"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/roofstuff/click_alt(mob/user)
	if(type != /obj/structure/roofstuff || !isliving(user))
		return NONE
	var/mob/living/climber = user
	if(!fits_air_duct(climber))
		to_chat(climber, span_warning("Вы слишком большой"))
		return CLICK_ACTION_SUCCESS
	if(!can_descend(climber))
		to_chat(climber, span_warning("Сейчас вы не можете пролезть в этот воздуховод."))
		return CLICK_ACTION_SUCCESS
	if(!get_descent_exit())
		to_chat(climber, span_warning("Под решёткой нет свободного выхода на нижний этаж."))
		return CLICK_ACTION_SUCCESS
	to_chat(climber, span_notice("Вы начинаете протискиваться в воздуховод..."))
	if(!do_after(climber, descent_time, target = src, extra_checks = CALLBACK(src, PROC_REF(can_descend), climber)))
		return CLICK_ACTION_SUCCESS
	descend(climber)
	return CLICK_ACTION_SUCCESS

/obj/structure/roofstuff/proc/fits_air_duct(mob/living/climber)
	return fits_but_make_noise(climber) || is_stealth_type(climber)

/obj/structure/roofstuff/proc/fits_but_make_noise(mob/living/climber)
	return istype(climber, /mob/living/basic/mouse/rat) || istype(climber, /mob/living/basic/bat/protean)

/obj/structure/roofstuff/proc/is_stealth_type(mob/living/climber)
	if(istype(climber, /mob/living/basic/mist) || istype(climber, /mob/living/basic/samedi_ash_pile))
		return TRUE
	if(is_species(climber, /datum/species/tzimisce_blood_form))
		return TRUE
	var/datum/discipline/obtenebration/discipline = climber.get_discipline(/datum/discipline/obtenebration)
	var/datum/discipline_power/obtenebration/tenebrous_form/shadow_form = discipline?.get_power(/datum/discipline_power/obtenebration/tenebrous_form)
	return shadow_form?.active && shadow_form.owner == climber

/obj/structure/roofstuff/proc/can_descend(mob/living/climber)
	if(QDELETED(src) || type != /obj/structure/roofstuff || QDELETED(climber) || !isturf(climber.loc) || !climber.Adjacent(src))
		return FALSE
	if(IS_UNCONSCIOUS_OR_CRIT(climber) || HAS_TRAIT(climber, TRAIT_IMMOBILIZED) || HAS_TRAIT(climber, TRAIT_HANDS_BLOCKED))
		return FALSE
	if(climber.buckled || climber.has_buckled_mobs())
		return FALSE
	return fits_air_duct(climber)

/obj/structure/roofstuff/proc/get_descent_exit()
	var/turf/exit = get_step_multiz(src, DOWN)
	if(!isfloorturf(exit) || exit.is_blocked_turf())
		return
	return exit

/obj/structure/roofstuff/proc/descend(mob/living/climber)
	// Recheck after do_after: the exit can become blocked while crawling.
	if(!can_descend(climber))
		return FALSE
	var/turf/exit = get_descent_exit()
	if(!exit)
		to_chat(climber, span_warning("Выход из воздуховода на нижнем этаже заблокирован."))
		return FALSE
	climber.stop_pulling()
	if(!climber.forceMove(exit))
		return FALSE
	to_chat(climber, span_notice("Вы выбираетесь из воздуховода на этаж ниже."))
	if(fits_but_make_noise(climber))
		var/result = SSroll.storyteller_roll_datum(climber, roll_datum = /datum/storyteller_roll/roof_vent_stealth)
		if(result != ROLL_SUCCESS)
			playsound(exit, 'sound/misc/metal_creak.ogg', 75, TRUE, extrarange = 5, ignore_walls = TRUE)
	return TRUE

/datum/storyteller_roll/roof_vent_stealth
	bumper_text = "тихое проникновение через вентиляцию"
	applicable_stats = list(STAT_DEXTERITY, STAT_STEALTH)
	difficulty = 6
	successes_needed = 3
	numerical = FALSE
	roll_output_type = ROLL_FLAG_ROLLER
