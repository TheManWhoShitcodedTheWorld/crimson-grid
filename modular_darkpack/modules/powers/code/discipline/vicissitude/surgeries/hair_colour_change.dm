/datum/surgery_operation/limb/modify_hair
	name = "Изменение волос"
	desc = "Изменение причёски и цвета волос пациента."
	implements = list(
		TOOL_HEMOSTAT = 1.15,
		TOOL_SCREWDRIVER = 2.85,
		/obj/item/pen = 6.67,
	)
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_LOCKED | OPERATION_NOTABLE | OPERATION_MORBID
	time = 20 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/limb/modify_hair/get_default_radial_image()
	return image(/obj/item/scalpel)

/datum/surgery_operation/limb/modify_hair/state_check(obj/item/bodypart/chest/limb)
	return limb.body_zone == BODY_ZONE_HEAD

/datum/surgery_operation/limb/modify_hair/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/patient = get_patient(operating_on)
	display_results(
		surgeon,
		patient,
		span_notice("Вы начинаете изменять волосы [patient.declent_ru(GENITIVE)]..."),
		span_notice("[surgeon] начинает изменять волосы [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] начинает делать надрез на голове [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Голову пронзает режущая боль!")

/datum/surgery_operation/limb/modify_hair/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(operating_on)

	var/new_style = tgui_input_list(surgeon, "Выберите причёску", "Причёска", SSaccessories.hairstyles_list)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.set_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(surgeon, span_notice("Вы меняете причёску [patient.declent_ru(GENITIVE)]."))

	display_results(
		surgeon,
		patient,
		span_notice("Вы изменяете причёску [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] изменяет причёску [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] заканчивает операцию на волосах [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Боль отступает!")

	var/new_hair_color = tgui_color_picker(surgeon, "Выберите цвет волос", "Цвет волос", patient.hair_color)
	if(!new_hair_color)
		return FALSE
	if(!IN_GIVEN_RANGE(surgeon, patient, 1))
		return FALSE
	patient.set_haircolor(sanitize_hexcolor(new_hair_color))
	patient.dna.update_ui_block(/datum/dna_block/identity/hair_color)
	SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(surgeon, COMSIG_MASQUERADE_VIOLATION)
	playsound(patient, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)

	display_results(
		surgeon,
		patient,
		span_notice("Вы изменяете цвет волос [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] изменяет цвет волос [patient.declent_ru(GENITIVE)]."),
		span_notice("[surgeon] заканчивает операцию на волосах [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Боль снова отступает!")

/datum/surgery_operation/limb/modify_hair/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/human/patient = get_patient(limb.owner)
	display_results(
		surgeon,
		patient,
		span_warning("Вы ошибаетесь и оставляете на голове [patient.declent_ru(GENITIVE)] ушибы!"),
		span_warning("[surgeon] ошибается и оставляет на голове [patient.declent_ru(GENITIVE)] ушибы!"),
		span_notice("[surgeon] заканчивает операцию на голове [patient.declent_ru(GENITIVE)]."),
	)
	display_pain(patient, "Голову будто рвут на части!")
	limb.receive_damage(rand(4, 8), wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)
