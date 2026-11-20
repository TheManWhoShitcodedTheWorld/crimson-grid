/datum/discipline/daimonion
	name = "Демонион"
	desc = {"Черпайте силу у демонов и у самой преисподней. Исподволь управляйте людьми, а когда придётся, призывайте пламя и защищайте себя.
● Запах греха: Восприятие + Эмпатия против Самоконтроля цели + 4
●● Низменный страх: Смекалка + Запугивание против Смелости цели + 4
●●● Всесожжение: без проверки
●●●● Психомахия: наименьшая добродетель цели
●●●●● Проклятие: Интеллект + Оккультизм против Воли цели"}
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/daimonion
	signature_clan = VAMPIRE_CLAN_BAALI
	max_selectable_level = 5 	// CRIMSON GRID ADD END: DARK THAUMATURGY

// CRIMSON GRID ADD: DARK THAUMATURGY 2
/datum/discipline/daimonion/post_gain()
	. = ..()
	var/datum/action/ritual_drawing/dark_thaumaturgy/dark_thaumaturgy = new()
	dark_thaumaturgy.Grant(owner)
	dark_thaumaturgy.level = level
// CRIMSON GRID ADD END: DARK THAUMATURGY 2

/datum/discipline_power/daimonion
	name = "Daimonion power name"
	desc = "Daimonion power description"

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_deactivate.ogg'
	var/theirpower = 0	// CORVAX EDIT

//SENSE THE SIN
/datum/discipline_power/daimonion/sense_the_sin
	name = "Запах греха"
	desc = "Почуйте грехи и жестокости своей жертвы."

	target_type = TARGET_HUMAN
	range = 7
	level = 1
	vitae_cost = 0
	frenzy_usable = FALSE

	cancelable = TRUE
	var/datum/storyteller_roll/sense_the_sin/sense_the_sin_roll

/datum/storyteller_roll/sense_the_sin
	bumper_text = "запах греха"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/daimonion/sense_the_sin/pre_activation_checks(mob/living/target)
	if(!sense_the_sin_roll)
		sense_the_sin_roll = new()
	sense_the_sin_roll.difficulty = max(target.st_get_stat(STAT_SELF_CONTROL), target.st_get_stat(STAT_INSTINCT)) + 4
	var/roll = sense_the_sin_roll.st_roll(owner, target)
	if(roll != ROLL_SUCCESS)
		return FALSE
	else
		return TRUE

/datum/discipline_power/daimonion/sense_the_sin/activate(mob/living/carbon/human/target)
	. = ..()
	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		to_chat(owner, span_phobia("Аура цели обладает ослепительным, обжигающим сиянием. Перед вами непроницаемая стена веры."))
		owner.emote("scream")
		owner.flash_act(affect_silicon = 1)
		owner.Paralyze(max(10/max(1, range), 5))
	if(target.st_get_stat(STAT_CHARISMA) <= 2)
		to_chat(owner, span_notice("Ни обаянием, ни влиянием цель не блещет."))
	if(target.st_get_stat(STAT_PERMANENT_WILLPOWER) <= 2)
		to_chat(owner, span_notice("Воля цели слаба."))
	if(target.st_get_stat(STAT_STRENGTH) <= 2)
		to_chat(owner, span_notice("Тело цели слабо и немощно."))
	if(target.st_get_stat(STAT_DEXTERITY) <= 2)
		to_chat(owner, span_notice("Цель неуклюжа."))
	if(get_garou_splat(target))
		to_chat(owner, span_notice("Природная погибель цели - серебро..."))
	if(get_kindred_splat(target))
		var/datum/subsplat/vampire_clan/target_clan = target.get_clan()
		if(!target_clan)
			return
		var/target_sense_the_sin_weakness = target_clan.sense_the_sin_text
		baali_get_stolen_disciplines(target, owner)
		if(target_sense_the_sin_weakness)
			to_chat(owner, span_notice("[target.name] [target_sense_the_sin_weakness]"))
	if(get_ghoul_splat(target))
		var/datum/splat/vampire/ghoul/ghoul_splat = get_ghoul_splat(target)
		var/mob/living/domitor = ghoul_splat.domitor?.resolve()

		if(domitor)
			to_chat(owner, span_notice("Цель зависима от Витэ, её домитором является [domitor.real_name]"))
		else
			to_chat(owner, span_notice("Цель зависима от Витэ, но она независима и свободна."))
	/* DARKPACK TODO : Kuei-Jin
	if(iscathayan(target))
		if(target.mind.dharma?.Po == "Legalist")
			to_chat(owner, span_notice("[target] hates to be controlled!"))
		if(target.mind.dharma?.Po == "Rebel")
			to_chat(owner, span_notice("[target] doesn't like to be touched."))
		if(target.mind.dharma?.Po == "Monkey")
			to_chat(owner, span_notice("[target] is too focused on money, toys and other sources of easy pleasure."))
		if(target.mind.dharma?.Po == "Demon")
			to_chat(owner, span_notice("[target] is addicted to pain, as well as to inflicting it to others."))
		if(target.mind.dharma?.Po == "Fool")
			to_chat(owner, span_notice("[target] doesn't like to be pointed at!"))
	*/
	if(!get_kindred_splat(target) && !get_ghoul_splat(target) && !get_shifter_splat(target) /*&& !iscathayan(target)*/)
		to_chat(owner, span_notice("[target.declent_ru(NOMINATIVE)] - жалкий червь без сильных сторон и явных слабостей, обычный человек."))


			/* DARKPACK TODO: Warrior Salubri / Salubri Warrior
			if(VAMPIRE_CLAN_SALUBRI_WARRIOR)
				to_chat(owner, span_notice("[target] pursues an endless revenge."))
				return
			*/

/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_stolen_disciplines(mob/living/target, mob/living/owner)
	if(!owner || !target)
		return
	var/datum/splat/vampire/kindred/vampire = get_kindred_splat(target)
	if(!vampire)
		return
	var/datum/subsplat/vampire_clan/target_clan = vampire.clan
	for(var/datum/action/discipline/disc_action as anything in vampire.powers)
		var/datum/discipline/discipline = disc_action.discipline
		if(!discipline?.selectable)
			continue
		var/signature_clan = discipline.signature_clan
		if(!signature_clan)
			continue
		if(signature_clan != target_clan.id)
			to_chat(owner, span_warning("[target.declent_ru(NOMINATIVE)] владеет краденой Дисциплиной: [discipline.name]!"))

//FEAR OF THE VOID BELOW
/datum/discipline_power/daimonion/fear_of_the_void_below
	name = "Низменный страх"
	desc = "Вселите в цель ужас."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS

	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 30 SECONDS // CRIMSON GRID ADD: DARK THAUMATURGY
	vitae_cost = 0

	var/datum/storyteller_roll/fear_of_the_void_below/fear_of_the_void_below_roll
	// CRIMSON GRID ADD: DARK THAUMATURGY
	var/datum/storyteller_roll/fear_of_the_void_below_resist/fear_of_the_void_below_resist
	var/success_count
	// CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/storyteller_roll/fear_of_the_void_below
	bumper_text = "низменный страх"
	applicable_stats = list(STAT_WITS, STAT_INTIMIDATION)
	roll_output_type = ROLL_FLAG_ROLLER
	numerical = TRUE // CRIMSON GRID ADD: DARK THAUMATURGY

// CRIMSON GRID ADD: DARK THAUMATURGY
/datum/storyteller_roll/fear_of_the_void_below_resist
	bumper_text = "обуздание Зверя"
	applicable_stats = list(STAT_COURAGE)
	roll_output_type = NONE
	numerical = TRUE
// CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/discipline_power/daimonion/fear_of_the_void_below/pre_activation_checks(mob/living/target)
	if(!fear_of_the_void_below_roll)
		fear_of_the_void_below_roll = new()
	fear_of_the_void_below_roll.difficulty = target.st_get_stat(STAT_COURAGE) + 4
	var/roll = fear_of_the_void_below_roll.st_roll(owner, target)
	if(roll != ROLL_SUCCESS)
		to_chat(owner, span_warning("Воля [target.declent_ru(GENITIVE)] слишком сильна, внушить страх не удаётся!"))
		return FALSE
	return TRUE

// CRIMSON GRID ADD: DARK THAUMATURGY 2
/datum/discipline_power/daimonion/fear_of_the_void_below/pre_activation_checks(mob/living/target)
	. = ..()
	if(!fear_of_the_void_below_roll)
		fear_of_the_void_below_roll = new()

	theirpower = target.st_get_stat(STAT_COURAGE) + 4	// CORVAX EDIT
	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		theirpower += 10

	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/fear_of_the_void_below, difficulty = theirpower)
	if(success_count <= 0)
		to_chat(owner, span_warning("Воля [target.declent_ru(GENITIVE)] слишком сильна, внушить страх не удаётся!"))
		return FALSE
	if(get_kindred_splat(target))
		if(!fear_of_the_void_below_resist)
			fear_of_the_void_below_resist = new()
		var/resist_count = SSroll.storyteller_roll_datum(target, owner, /datum/storyteller_roll/fear_of_the_void_below_resist, difficulty = owner.st_get_stat(STAT_PERMANENT_WILLPOWER))
		if(resist_count > success_count)
			to_chat(owner, span_warning(genderize_decode(target, "Вам не удаётся окутать страхом разум [target.declent_ru(GENITIVE)]: [target.ru_p_they()] усмиря%(ет,ют)% своего Зверя!")))
			return FALSE
// CRIMSON GRID ADD END: DARK THAUMMATURGY 2

/datum/discipline_power/daimonion/fear_of_the_void_below/activate(mob/living/carbon/human/target)
	. = ..()
	// CRIMSON GRID ADD: DARK THAUMATURGY
	target.apply_status_effect(/datum/status_effect/daimonion_dread) // CRIMSON GRID ADD: DARK THAUMATURGY 2
	target.emote("tremble")
	target.emote(pick("scream","cry"))
	to_chat(target, span_warning("Вас захлёстывает самый большой ваш страх!"))
	switch(success_count)
		if(1)
			target.adjust_confusion(3 SECONDS)
		if(2)
			GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown, 1 SCENES)
			to_chat(target, span_userdanger("Б Е Г И !"))
		if(3 to INFINITY)
			target.Immobilize(3 SECONDS)
			if(target.body_position == STANDING_UP)
				target.toggle_resting()
			target.adjust_temp_blindness(3 SECONDS) // You're "unconscious"
	// CRIMSON GRID ADD END: DARK THAUMATURGY

//CONFLAGRATION
/datum/discipline_power/daimonion/conflagration
	name = "Всесожжение"
	desc = "Призовите разрушительную сущность Запределья."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING | TARGET_TURF | TARGET_OBJ // CRIMSON GRID ADD: DARK THAUMATURGY
	range = 7
	cooldown_length = 30 SECONDS // CRIMSON GRID ADD: DARK THAUMATURGY 2
	activate_sound = 'modular_darkpack/modules/powers/sounds/daimonion_fireball.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE
	vitae_cost = 1	// CORVAX EDIT

/obj/projectile/flames/baali
	color = "#1c1f1d"
	damage = 40 //CRIMSON GRID ADD: DARK THAUMATURGY
	damage_type = BURN // CRIMSON GRID ADD END: DARK THAUMATURGY
	// CRIMSON GRID ADD: DARK THAUMATURGY 2
	ignite_chance = 100
	fire_turf_chance = 100
	ignite_color = COLOR_VERY_DARK_LIME_GREEN
	fire_turf_type = /obj/effect/abstract/turf_fire/infernal
	hit_prone_targets = TRUE
	// CRIMSON GRID ADD END: DARK THAUMATURGY 2

// CRIMSON GRID ADD: DAIMOINON -> DAIMONION
/datum/discipline_power/daimonion/conflagration/activate(atom/target)
// CRIMSON GRID ADD END: DAIMOINON -> DAIMONION
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/flames/baali/created_fireball = new(start)
	created_fireball.firer = owner
	var/angle = get_angle(owner, target)
	created_fireball.fire(angle, target)

//PSYCHOMANIA
/datum/discipline_power/daimonion/psychomania
	name = "Психомахия"
	desc = "Воплотите наяву самый большой страх цели."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	target_type = TARGET_LIVING
	range = 7
	cooldown_length = 30 SECONDS // CRIMSON GRID ADD: DARK THAUMATURGY
	vitae_cost = 1	// CORVAX EDIT

	violates_masquerade = FALSE

	var/datum/storyteller_roll/psychomania/psychomania_roll

/datum/storyteller_roll/psychomania
	bumper_text = "психомания"
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/daimonion/psychomania/pre_activation_checks(mob/living/target)
	if(!psychomania_roll)
		psychomania_roll = new()

	// CRIMSON GRID ADD: DARK THAUMATURGY
	var/list/humanity_virtues = list(STAT_CONSCIENCE, STAT_SELF_CONTROL, STAT_COURAGE)
	var/list/enlightenment_virtues = list(STAT_CONVICTION, STAT_INSTINCT, STAT_COURAGE)
	var/list/current_virtues = target.is_enlightenment() ? enlightenment_virtues : humanity_virtues
	// CRIMSON GRID ADD END: DARK THAUMATURGY

	//forces the subject's player to roll her lowest Virtue
	var/datum/st_stat/virtue/lowest_virtue
	for(var/virtue_type in current_virtues) // CRIMSON GRID ADD: DARK THAUMATURGY
		var/datum/st_stat/virtue/target_stat = target.storyteller_stats[virtue_type]
		if(!lowest_virtue || target_stat.get_score() < lowest_virtue.get_score())
			lowest_virtue = target_stat

	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		theirpower += 10

	psychomania_roll.difficulty = theirpower	// CORVAX EDIT

	psychomania_roll.applicable_stats = list(lowest_virtue)
	var/roll = psychomania_roll.st_roll(target, owner)

	if(roll != ROLL_SUCCESS)
		to_chat(owner, span_cult("[capitalize(target.declent_ru(ACCUSATIVE))] ждут великие муки."))
		return TRUE

	to_chat(owner, span_warning("Душа [target.declent_ru(GENITIVE)] слишком чиста, и страхи не обретают плоть!"))
	return FALSE

/datum/discipline_power/daimonion/psychomania/activate(mob/living/target)
	. = ..()

	var/datum/splat/werewolf/shifter/garou_splat = get_shifter_splat(target)
	if(garou_splat)
		garou_splat.tribe.psychomania_effect(target, owner)
		return

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(target)
	if(kindred_splat)
		kindred_splat.clan.psychomania_effect(target, owner)
		return

	to_chat(target, span_cult("ЧТО-ТО ПРИБЛИЖАЕТСЯ! ЧТО ЭТО?!!"))
	var/obj/effect/client_image_holder/baali_demon/demon = new(get_turf(target), list(target))
	RegisterSignal(demon, COMSIG_BAALI_DEMON_REACHED_TARGET, PROC_REF(on_demon_contact))
	return

/datum/discipline_power/daimonion/psychomania/proc/on_demon_contact(obj/effect/client_image_holder/baali_demon/source, mob/living/victim)
	SIGNAL_HANDLER
	source.on_contact(victim)
	step_away(victim, get_turf(source))

//CONDEMNATION
/datum/discipline_power/daimonion/condemnation
	name = "Проклятие"
	desc = "Обреките душу на страдания."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	violates_masquerade = TRUE
	vitae_cost = 0
	var/datum/storyteller_roll/condemnation/condemnation_roll
	var/list/available_curses
	frenzy_usable = FALSE

/datum/storyteller_roll/condemnation
	bumper_text = "проклятие"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/daimonion/condemnation/activate(mob/living/target)
	. = ..()

	if(target.has_status_effect(/datum/status_effect/condemnation))
		to_chat(owner, span_warning("Цель уже проклята!"))
		return

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(owner)
	if(!available_curses)
		for(var/curse_type in subtypesof(/datum/status_effect/condemnation))
			var/datum/status_effect/condemnation/curse = curse_type
			if(kindred_splat.generation <= curse.genrequired)
				LAZYSET(available_curses, curse.name, curse_type)

	var/chosen_curse_name = tgui_input_list(owner, "Какое проклятие падёт на обречённого?", "Выбор проклятия", available_curses)
	if(!chosen_curse_name)
		return

	var/datum/status_effect/condemnation/chosen_curse_datum = available_curses[chosen_curse_name]

	if(!condemnation_roll)
		condemnation_roll = new()

	var/theirpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)	// CORVAX EDIT
	if(HAS_TRAIT(target, TRAIT_TRUE_FAITH))	// CORVAX EDIT
		theirpower += 10

	condemnation_roll.difficulty = theirpower
	var/roll = condemnation_roll.st_roll(owner, target)
	if(roll != ROLL_SUCCESS)
		to_chat(owner, span_warning("Пробиться в чужой разум не удалось, и проклятие не коснулось цели."))
		//not sure if target should get a to_chat?
		return

	target.apply_status_effect(chosen_curse_datum)
	owner.maxbloodpool -= chosen_curse_datum.bloodcost
	owner.bloodpool = clamp(owner.bloodpool, 0, owner.maxbloodpool)


