/datum/surgery_operation/limb/height_change
	name = "Изменение роста"
	desc = "Изменение роста пациента."
	implements = list(
		TOOL_HEMOSTAT = 1.15,
		TOOL_SCREWDRIVER = 2.85,
		/obj/item/pen = 6.67,
	)
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_MORBID
	time = 20 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED|SURGERY_BONE_SAWED

/datum/surgery_operation/limb/height_change/get_default_radial_image()
	return image(/obj/item/scalpel)

/datum/surgery_operation/limb/height_change/state_check(obj/item/bodypart/chest/limb)
	return limb.body_zone == BODY_ZONE_CHEST

/datum/surgery_operation/limb/height_change/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/patient = get_patient(operating_on)
	display_results(
		surgeon,
		patient,
		span_notice("Вы начинаете изменять рост [patient.declent_ru(GENITIVE)]..."),
		span_notice("[surgeon] начинает изменять рост [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] начинает делать надрез на спине [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Спину пронзает режущая боль!")

/datum/surgery_operation/limb/height_change/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(operating_on)

	var/list/heights = list(
		"Очень высокий" = HUMAN_HEIGHT_TALLER,
		"Высокий" = HUMAN_HEIGHT_TALL,
		"Средний" = HUMAN_HEIGHT_MEDIUM,
		"Низкий" = HUMAN_HEIGHT_SHORT,
		"Очень низкий" = HUMAN_HEIGHT_SHORTEST,
		)

	var/new_height = tgui_input_list(surgeon, "Выберите рост", "Изменение роста", heights)
	new_height = heights[new_height]
	if(!new_height)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.set_mob_height(new_height)
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)

	display_results(
		surgeon,
		patient,
		span_notice("Вы полностью перестраиваете позвоночник [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] полностью перестраивает позвоночник [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] заканчивает операцию на позвоночнике [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Боль отступает, и мир кажется другим!")

/datum/surgery_operation/limb/height_change/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(limb.owner)
	display_results(
		surgeon,
		patient,
		span_warning("Вы ошибаетесь и повреждаете позвоночник [patient.declent_ru(GENITIVE)]!"),
		span_warning("[surgeon] ошибается и повреждает позвоночник [patient.declent_ru(GENITIVE)]!"),
		span_notice("[surgeon] заканчивает операцию на позвоночнике [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Спину будто рвут на части!")
	limb.receive_damage(rand(4, 8), wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)
