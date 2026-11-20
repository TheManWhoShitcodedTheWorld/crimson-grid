/datum/surgery_operation/limb/sex_change
	name = "Смена пола" //  someone come back and woke-ify this
	desc = "Изменение пола пациента."
	implements = list(
		TOOL_HEMOSTAT = 1.15,
		TOOL_SCREWDRIVER = 2.85,
		/obj/item/pen = 6.67,
	)
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_MORBID
	required_bodytype = ~BODYTYPE_ROBOTIC
	time = 20 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_ORGANS_CUT|SURGERY_VESSELS_CLAMPED|SURGERY_BONE_SAWED

/datum/surgery_operation/limb/sex_change/get_default_radial_image()
	return image(/obj/item/scalpel)

/datum/surgery_operation/limb/sex_change/state_check(obj/item/bodypart/chest/limb)
	return limb.body_zone == BODY_ZONE_CHEST

/datum/surgery_operation/limb/sex_change/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/patient = get_patient(operating_on)
	display_results(
		surgeon,
		patient,
		span_notice("Вы начинаете перекраивать тело [patient.declent_ru(GENITIVE)]..."),
		span_notice("[surgeon] начинает творить с плотью [patient.declent_ru(GENITIVE)] нечто поистине ужасное!"),
		span_notice("[surgeon] начинает творить с плотью [patient.declent_ru(GENITIVE)] нечто поистине ужасное!"),
	)
	display_pain(patient, "Ваша плоть словно шевелится сама собой!")

/datum/surgery_operation/limb/sex_change/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(operating_on)

	var/chosen_sex = tgui_input_list(surgeon, "Выберите пол.", "Смена пола", list("Мужской", "Женский", "Множественный", "Средний"))
	if(!chosen_sex)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	switch(chosen_sex)
		if("Мужской")
			patient.gender = MALE
		if("Женский")
			patient.gender = FEMALE
		if("Множественный")
			patient.gender = PLURAL
		if("Средний")
			patient.gender = NEUTER
	to_chat(surgeon, span_notice("Вы меняете пол [patient.declent_ru(GENITIVE)]."))
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)

	var/chosen_physique = tgui_input_list(surgeon, "Изменить заодно и телосложение?", "Смена пола", list("Мужское", "Женское"))
	if(!chosen_physique)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.physique = (chosen_physique == "Мужское") ? MALE : FEMALE
	patient.dna.update_ui_block(/datum/dna_block/identity/gender)
	patient.update_body(is_creating = TRUE) // or else physique won't change properly
	patient.update_appearance(UPDATE_OVERLAYS)
	patient.update_clothing(ITEM_SLOT_ICLOTHING) // update gender shaped clothing
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(surgeon, span_notice("Вы меняете телосложение [patient.declent_ru(GENITIVE)]."))

	display_results(
		surgeon,
		patient,
		span_notice("Вы завершаете смену пола [patient.declent_ru(GENITIVE)]!"),
		span_notice("[surgeon] превращает [patient.declent_ru(ACCUSATIVE)] в нечто новое."),
		span_notice("[surgeon] заканчивает операцию над [patient.declent_ru(INSTRUMENTAL)]."))
	display_pain(patient, "Боль отступает, и вы словно заново родились!")

/datum/surgery_operation/limb/sex_change/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(limb.owner)
	display_results(
		surgeon,
		patient,
		span_warning("Вы ошибаетесь и оставляете на теле [patient.declent_ru(GENITIVE)] ушибы!"),
		span_warning("[surgeon] ошибается и оставляет на теле [patient.declent_ru(GENITIVE)] ушибы!"),
		span_notice("[surgeon] заканчивает операцию над [patient.declent_ru(INSTRUMENTAL)]."),
	)
	display_pain(patient, "Грудь будто рвут на части!")
	limb.receive_damage(rand(4, 8), wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)
