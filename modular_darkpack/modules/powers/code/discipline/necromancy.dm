// necromancy zombies located in npc module, beastmaster/necromancy_zombies.dm

/datum/discipline/necromancy
	name = "Некромантия"
	desc = {"Дарует власть над иной реальностью, миром мёртвых.
● Взгляд за Завесу: Восприятие + Шестое чувство (сложность 7)
●● Призрачная орда: Смекалка + Оккультизм (сложность 6)
●●● Пепел к пеплу: Смекалка + Оккультизм (сложность 6)
●●●● Могильный холод: Смекалка + Оккультизм (сложность 6)
●●●●● Гнилая орда: Смекалка + Оккультизм (сложность 6)"}
	icon_state = "necromancy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/necromancy
	signature_clan = VAMPIRE_CLAN_GIOVANNI

/datum/discipline/necromancy/post_gain(post_gain_applied)
	. = ..()
	if(!post_gain_applied)
		var/datum/action/ritual_drawing/necromancy/ritualist = new()
		ritualist.Grant(owner)
		ritualist.level = level

/datum/discipline/necromancy/post_loss()
	. = ..()
	for(var/datum/action/action as anything in owner.actions)
		if(istype(action, /datum/action/ritual_drawing/necromancy))
			qdel(action)

/datum/discipline_power/necromancy/pre_activation_checks(mob/living/target)
	. = ..()
	return SSroll.storyteller_roll_datum(owner, applic_stats = list(STAT_WITS, STAT_OCCULT))

/datum/discipline_power/necromancy
	name = "Necromancy power name"
	desc = "Necromancy power description"
	frenzy_usable = FALSE

//SHROUDSIGHT V20 p. 163
/datum/storyteller_roll/shroudsight
	bumper_text = "взгляд за Завесу"
	applicable_stats = list(STAT_PERCEPTION, STAT_AWARENESS)
	difficulty = 7
	roll_output_type = ROLL_FLAG_ROLLER

/datum/discipline_power/necromancy/shroudsight
	name = "Взгляд за Завесу"
	desc = "Видьте и говорите с призраками поблизости."
	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1on.ogg'
	deactivate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1off.ogg'

	cooldown_length = 10 SECONDS
	duration_length = 1 SCENES

	var/datum/storyteller_roll/shroudsight/roll_datum

/datum/discipline_power/necromancy/shroudsight/pre_activation_checks(mob/living/target)
	if(!roll_datum)
		roll_datum = new()
	var/roll_result = roll_datum.st_roll(owner)
	if(roll_result == ROLL_SUCCESS)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/necromancy/shroudsight/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)
	ADD_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, NECROMANCY_TRAIT)
	owner.update_sight()

	to_chat(owner, span_notice("Вы заглядываете за Завесу."))

/datum/discipline_power/necromancy/shroudsight/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, NECROMANCY_TRAIT)
	owner.update_sight()

	to_chat(owner, span_warning("Ваш взгляд возвращается в мир смертных."))

//ETHEREAL HORDE
/datum/discipline_power/necromancy/ethereal_horde
	name = "Призрачная орда"
	desc = "Призовите из Земель Теней пару Трутней, которые встанут на вашу защиту."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	vitae_cost = 1

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg'

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/cold_of_the_grave,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/discipline_power/necromancy/ethereal_horde/activate()
	. = ..()
	owner.visible_message(span_warning("Из тени [owner.declent_ru(GENITIVE)] выступают стенающие духи."))
	owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level1)
	owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level1)

//ASHES TO ASHES
/datum/discipline_power/necromancy/ashes_to_ashes
	name = "Пепел к пеплу"
	desc = "Обратите труп в прах и заберите его жизненную силу или похитьте её у призрака."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB | TARGET_GHOST
	range = 3 //to not wallbang people mid-surgery at the hospital
	vitae_cost = 0

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy3.ogg'

	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/cold_of_the_grave,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/discipline_power/necromancy/ashes_to_ashes/activate(mob/target)
	. = ..()

	if(isavatar(target))
		to_chat(owner, span_warning("Этот дух ещё связан с телесной оболочкой.")) // cant absorb auspex ghosts
		return

	if (isobserver(target))
		var/mob/dead/observer/ghost = target
		to_chat(target, span_notice("[capitalize(owner.declent_ru(NOMINATIVE))] вытягивает вашу плазму и крадёт частицу вашего существа, чтобы поддержать собственное."))

		if(!ghost.soul_taken)
			to_chat(owner, span_warning("Вы утолили Голод Страстью призрака. Вы получаете <b>КРОВЬ</b> и <b>ДУШУ</b>."))
			owner.adjust_blood_pool(1)
			if(isliving(owner))
				owner.collected_souls += 1
				to_chat(owner, span_cult("Вы заключаете душу усопшего в свой некромантический гримуар. Теперь её сущность будет помогать вашим изысканиям из-за Завесы..."))

			ghost.soul_taken = TRUE
		else
			to_chat(owner, span_warning("Вы утолили Голод Страстью призрака. Вы получаете <b>КРОВЬ</b>, но душа уже ускользнула."))
			owner.adjust_blood_pool(1)
		return

	if (isliving(target) && target.stat == DEAD)
		var/mob/living/dusted = target
		owner.visible_message(span_warning("[capitalize(owner.declent_ru(NOMINATIVE))] делает жест в сторону [target.declent_ru(GENITIVE)]."))
		dusted.visible_message(span_danger("Тело [target.declent_ru(GENITIVE)] прямо на глазах рассыпается в прах!"))
		to_chat(owner, span_warning("Вы поглотили остатки жизненной силы, ещё теплившиеся в теле. Вы получаете <b>КРОВЬ</b> и <b>ДУШУ</b>."))
		dusted.dust(just_ash = TRUE)
		owner.adjust_blood_pool(2) // corpses = 2 blood
		if(isliving(owner))
			owner.collected_souls += 1
			to_chat(owner, span_cult("Вы заключаете душу усопшего в свой некромантический гримуар. Теперь её сущность будет помогать вашим изысканиям из-за Завесы..."))
		return

	to_chat(owner, span_warning("Смерть ещё не забрала эту жертву, поживиться тут нечем."))


//COLD OF THE GRAVE
/datum/discipline_power/necromancy/cold_of_the_grave
	name = "Могильный холод"
	desc = "Погрузите выбранную цель (можно и себя) в состояние, подобное смерти."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_SELF | TARGET_LIVING
	range = 5
	vitae_cost = 1

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy4.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	multi_activate = TRUE
	cooldown_length = 20 SECONDS
	duration_length = 20 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/movespeed_modifier/corpsebuff
	multiplicative_slowdown = 0.4

/datum/movespeed_modifier/corpsenerf
	multiplicative_slowdown = 0.8 //lasts for a while

/datum/discipline_power/necromancy/cold_of_the_grave/activate(mob/living/target)
	. = ..()

	owner.visible_message(span_warning("[capitalize(owner.declent_ru(NOMINATIVE))] делает жест в сторону [target.declent_ru(GENITIVE)]."))
	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		// removed iscathayan(target) || from line 183 DARKPACK TODO - readd KJs Kuei-Jin
		if(get_kindred_splat(target) || target.has_status_effect(/datum/status_effect/zombie)) //undead become spongier, but move slightly slower
			corpsebuff.visible_message(span_danger("Тело [target.declent_ru(GENITIVE)] сковывает трупное окоченение."), span_danger("Ваши чувства глохнут: нет больше ни боли, ни всего остального."))

			for(var/obj/item/bodypart/part as anything in corpsebuff.bodyparts)
				part.brute_modifier = max(0.2, part.brute_modifier - 0.3)

			ADD_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			ADD_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			ADD_TRAIT(corpsebuff, TRAIT_ANALGESIA, NECROMANCY_TRAIT)
			corpsebuff.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
			corpsebuff.do_jitter_animation(2 SECONDS)
		else //everyone else eats tox and CC
			corpsebuff.visible_message(span_danger("Кожа [target.declent_ru(GENITIVE)] сереет, тело охватывает страшная болезнь."), span_userdanger("Вам невыносимо дурно."))
			corpsebuff.vomit()

			corpsebuff.apply_status_effect(/datum/status_effect/dizziness, 10 SECONDS)

			corpsebuff.apply_status_effect(/datum/status_effect/confusion, 10 SECONDS)

			corpsebuff.apply_damage(50, TOX)
			corpsebuff.Stun(3 SECONDS) // ignored by tough flesh and shapeshifted werewolves
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.do_jitter_animation(2 SECONDS)

	else
		target.apply_damage(100, BRUTE)
		target.visible_message(span_danger("[capitalize(target.declent_ru(NOMINATIVE))] съёживается и усыхает!"))

/datum/discipline_power/necromancy/cold_of_the_grave/deactivate(mob/living/target)
	. = ..()

	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		// || iscathayan(target) removed that from line 211 DARKPACK TODO -- readd KJS Kuei-Jin
		if(get_kindred_splat(target))
			corpsebuff.visible_message(span_notice("Тело [target.declent_ru(GENITIVE)] вновь обретает прежний вид."), span_notice("Чувства разом возвращаются в ваше тело."))
			for(var/obj/item/bodypart/part as anything in corpsebuff.bodyparts)
				part.brute_modifier = initial(part.brute_modifier)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			REMOVE_TRAIT(corpsebuff, TRAIT_ANALGESIA, NECROMANCY_TRAIT)
			corpsebuff.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
		else
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.visible_message(span_notice("Тело [target.declent_ru(GENITIVE)] вновь обретает прежний вид."), span_notice("Неестественная хворь отступает."))


//SHAMBLING HORDE
/datum/discipline_power/necromancy/shambling_horde
	name = "Гнилая орда"
	desc = "Поднимайте из трупов свирепых зомби: чем крупнее было тело, тем они опаснее. Живых эта сила калечит, а разумную нежить восстанавливает."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 5 //less range than thaum, nerf if 2stronk

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy5.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/cold_of_the_grave

	)

/datum/discipline_power/necromancy/shambling_horde/activate(mob/living/target)
	. = ..()
	if (target.stat == DEAD)
		owner.visible_message(span_warning("[capitalize(owner.declent_ru(NOMINATIVE))] водит руками над трупом [target.declent_ru(GENITIVE)]."))
		target.visible_message(span_danger("[capitalize(target.declent_ru(NOMINATIVE))] дёргается и встаёт, словно марионетка в руках невидимой силы."))
		if(iscarbon(target))
			owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level4)
			qdel(target)
		else
			switch(target.maxHealth)
				if (-INFINITY to 20) //rats and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level2)
					qdel(target)
				if (20 to 70) //cats and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level3)
					qdel(target)
				if (70 to 150) //dogs/biters and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level4)
					qdel(target)
				if (150 to INFINITY) //szlachta and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level5)
					qdel(target)

	else if(target.has_status_effect(/datum/status_effect/zombie))
		owner.visible_message(span_warning("[capitalize(owner.declent_ru(NOMINATIVE))] резким жестом указывает на [target.declent_ru(ACCUSATIVE)]!"))
		target.visible_message(span_warning("Плоть [target.declent_ru(GENITIVE)] срастается!"), span_danger("Ваша гнилая плоть восстанавливается!"))
		var/mob/living/carbon/human/zombie = target
		zombie.heal_ordered_damage(120, list(BRUTE, TOX, BURN, AGGRAVATED, OXY, BRAIN))
		zombie.adjust_blood_pool(3)
		if(length(zombie.all_wounds))
			var/datum/wound/wound = pick(zombie.all_wounds)
			wound.remove_wound()
	else
		owner.visible_message(span_warning("[capitalize(owner.declent_ru(NOMINATIVE))] резким жестом указывает на [target.declent_ru(ACCUSATIVE)]!"))
		target.visible_message(span_warning("На [target.declent_ru(ACCUSATIVE)] обрушивается некромантическая энергия!"), span_danger("Вы гниёте изнутри!"))
		target.apply_damage(55, AGGRAVATED, owner.zone_selected) // 1/5 of a 5-dot "healthbar" in aggravated damage, on level with thaumaturgy's average output
		target.emote("scream")

