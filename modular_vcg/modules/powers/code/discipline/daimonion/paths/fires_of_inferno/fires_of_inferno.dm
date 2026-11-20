/datum/discipline/path/inferno
	name = "Огни Преисподней"
	desc = "Путь Демониона, дающий власть над огнём. Нарушает Маскарад."
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "inferno"
	power_type = /datum/discipline_power/daimonion/path/inferno

/datum/discipline_power/daimonion/path/inferno
	name = "Dark Thaumaturgy: Fires of Inferno Power Name"
	desc = "Dark Thaumaturgy: Fires of Inferno Power Description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE
	range = 7

	cooldown_length = 3 TURNS
	var/success_count

/datum/storyteller_roll/fires_of_inferno
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE

/datum/discipline_power/daimonion/path/inferno/activate(atom/target)
	. = ..()
	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/fires_of_inferno, difficulty = (level + 3))
	if(success_count < 0)
		owner.visible_message(span_notice("[owner] вспыхивает!"), \
			span_notice("Вы вспыхиваете!"))
		inferno_botch_effect()
		return TRUE
	else if(success_count == 0)
		to_chat(owner, span_notice("Ваша магия рассеивается впустую!"))
		return TRUE
	return FALSE

/datum/discipline_power/daimonion/path/inferno/proc/inferno_botch_effect()
	to_chat(owner, span_userdanger("У вас внутри словно вспыхнуло солнце!"))
	owner.adjust_fire_stacks(5, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	owner.ignite_mob()

/datum/discipline_power/daimonion/path/inferno/post_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_AURA_OF_INFERNO, FIRES_OF_INFERNO_TRAIT)
	SEND_SIGNAL(owner, COMSIG_MOB_UPDATE_AURA)

/datum/discipline_power/daimonion/path/inferno/lighter
	name = "Зажигалка"
	desc = "Воплотите инферно — станьте невосприимчивы к Ротшреку."

	level = 1
	range = 1
	target_type = TARGET_SELF
	duration_length = 3 TURNS

/datum/discipline_power/daimonion/path/inferno/lighter/activate(mob/living/target)
	if(..())
		return
	to_chat(owner, span_notice("Вы становитесь воплощением инферно!"))
	to_chat(owner, span_notice("Вы больше не боитесь огня."))
	ADD_TRAIT(owner, ROTSCHRECK_IMMUNITY, FIRES_OF_INFERNO_TRAIT)

/datum/discipline_power/daimonion/path/inferno/lighter/deactivate(atom/target, direct)
	. = ..()
	to_chat(owner, span_notice("Ваш страх перед огнём возвращается."))
	REMOVE_TRAIT(owner, ROTSCHRECK_IMMUNITY, FIRES_OF_INFERNO_TRAIT)

/datum/discipline_power/daimonion/path/inferno/stovetop
	name = "Конфорка"
	desc = "Метните в цель адское пламя и подожгите её."

	level = 2
	range = 2
	target_type = TARGET_MOB

/datum/discipline_power/daimonion/path/inferno/stovetop/activate(mob/living/target)
	if(..())
		return
	var/throwtarget = get_edge_target_turf(owner, get_dir(owner, get_step_away(target, owner)))
	target.safe_throw_at(throwtarget, 3, 1, src, spin = TRUE, force = MOVE_FORCE_VERY_STRONG, gentle = TRUE)
	target.Knockdown(0.1 SECONDS)
	target.apply_damage(5 * success_count, BURN)
	target.adjust_fire_stacks(1, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	owner.visible_message(span_warning("[owner] мечет адское пламя в [target.declent_ru(ACCUSATIVE)]!"), \
			span_notice("Вы мечете адское пламя в [target.declent_ru(ACCUSATIVE)]!"))

/datum/discipline_power/daimonion/path/inferno/blowtorch
	name = "Паяльная лампа"
	desc = "Направьте на цель сосредоточенный луч адского огня."

	level = 3
	range = 7
	target_type = TARGET_MOB

/datum/discipline_power/daimonion/path/inferno/blowtorch/activate(mob/living/target)
	if(..())
		return
	var/beam_duration = clamp(success_count*2 SECONDS, 2 SECONDS, 10 SECONDS)
	var/datum/beam/blowtorch/new_beam = new(owner, target, 'icons/effects/beam.dmi', "sm_arc_supercharged", beam_duration, 9, /obj/effect/ebeam/reacting/blowtorch, COLOR_VERY_DARK_LIME_GREEN)
	INVOKE_ASYNC(new_beam, TYPE_PROC_REF(/datum/beam/, Start))
	owner.visible_message(span_warning("[owner] бьёт в [target.declent_ru(ACCUSATIVE)] жгучим лучом адского огня!"), \
			span_notice("Вы бьёте в [target.declent_ru(ACCUSATIVE)] жгучим лучом адского огня!"))

/datum/discipline_power/daimonion/path/inferno/flamethrower
	name = "Огнемёт"
	desc = "Залейте участок перед собой конусом адского огня."

	level = 4
	range = 7
	target_type = TARGET_TURF

/datum/discipline_power/daimonion/path/inferno/flamethrower/activate(turf/target_turf)
	if(..())
		return
	var/turf/owner_turf = get_turf(owner)
	var/dir = get_cardinal_dir(owner_turf, target_turf)
	owner.setDir(dir)
	var/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/flamethrower = new(owner)
	flamethrower.cast(owner)
	owner.visible_message(span_warning("[owner] выпускает испепеляющее облако адского пламени!"), \
			span_notice("Вы выпускаете испепеляющее облако адского пламени!"))

/datum/discipline_power/daimonion/path/inferno/conflagration
	name = "Пожарище"
	desc = "Вызовите бурю зелёного пламени, которая разрастается во все стороны."

	level = 5
	range = 7
	target_type = TARGET_TURF | TARGET_LIVING

/datum/discipline_power/daimonion/path/inferno/conflagration/activate(atom/target)
	if(..())
		return

	to_chat(owner, span_notice("Вы начинаете призывать смертоносное пекло..."))

	var/turf/center = get_turf(target)

	new /obj/effect/temp_visual/inferno_warning/infernal(center)
	owner.visible_message(span_warning("В воздухе пляшут искры зелёного пламени, становится всё жарче... Сейчас случится что-то страшное!"))

	if(!do_after(owner, 2 SECONDS))
		to_chat(owner, span_warning("Вас прервали - призвать пекло не удалось!"))
		for(var/obj/effect/temp_visual/inferno_warning/infernal/warning in center)
			qdel(warning)
		return

	var/base_damage = 40 + (success_count * 5)
	var/fire_stacks_amount = 3 + success_count
	var/ignite_chance = min(60 + (success_count * 10), 95)

	// fire at center
	for(var/obj/effect/temp_visual/inferno_warning/infernal/warning in center)
		qdel(warning)
	new /obj/effect/abstract/turf_fire/infernal(center, 20, COLOR_VERY_DARK_LIME_GREEN)
	do_inferno_effect(center, base_damage, fire_stacks_amount, ignite_chance)

	// ghost flame 1x1
	for(var/turf/selected_turf in orange(1, center))
		new /obj/effect/temp_visual/inferno_warning/infernal(selected_turf)

	// 3x3 fire
	addtimer(CALLBACK(src, PROC_REF(spread_fire), center, 1, base_damage, fire_stacks_amount, ignite_chance), 2 SECONDS)

	// ghost flame 5x5
	addtimer(CALLBACK(src, PROC_REF(create_ghost_fire), center, 2), 2 SECONDS)

	// 5x5 fire
	addtimer(CALLBACK(src, PROC_REF(spread_fire), center, 2, base_damage, fire_stacks_amount, ignite_chance), 4 SECONDS)

	playsound(center, effect_sound, 100, TRUE)
	owner.visible_message(span_danger("[owner] обрушивает всепожирающее пекло!"))

	switch(success_count)
		if(1)
			to_chat(owner, span_bolddanger("Пекло вышло не слишком сильным."))
		if(2)
			to_chat(owner, span_bolddanger("Пекло бушует в полную силу."))
		if(3 to INFINITY)
			to_chat(owner, span_bolddanger("Пекло ревёт с сокрушительной, сверхъестественной яростью!"))

/datum/discipline_power/daimonion/path/inferno/conflagration/proc/spread_fire(turf/selected_turf, dist, base_damage, fire_stacks_amount, ignite_chance)
	for(var/turf/open/open_turf in orange(dist, selected_turf))
		for(var/obj/effect/temp_visual/inferno_warning/infernal/inferno_fire in open_turf)
			qdel(inferno_fire)
		if(!open_turf.turf_fire)
			new /obj/effect/abstract/turf_fire/infernal(open_turf, 20, COLOR_VERY_DARK_LIME_GREEN)
		do_inferno_effect(open_turf, base_damage, fire_stacks_amount, ignite_chance)

/datum/discipline_power/daimonion/path/inferno/conflagration/proc/do_inferno_effect(turf/selected_turf, base_damage, fire_stacks_amount, ignite_chance)
	for(var/mob/living/living_target in selected_turf)
		if(living_target == owner)
			continue
		living_target.adjust_fire_loss(base_damage)
		if(prob(ignite_chance))
			living_target.adjust_fire_stacks(fire_stacks_amount, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
			living_target.ignite_mob()
		to_chat(living_target, span_userdanger("Вы попали в сверхъестественное пекло!"))

/datum/discipline_power/daimonion/path/inferno/conflagration/proc/create_ghost_fire(turf/selected_turf, dist)
	for(var/turf/open/open_turf in orange(dist, selected_turf))
		if(!open_turf.turf_fire)
			new /obj/effect/temp_visual/inferno_warning/infernal(open_turf)
