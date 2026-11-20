#define CHANGE_HAIR "Change Hair"
#define CHANGE_BEARD "Change Beard"
#define CHANGE_SEX  "Change Sex"
#define CHANGE_NAME "Change Name"
#define CHANGE_EYES "Change Eyes"
#define CHANGE_RACE "Change Race"
#define CHANGE_HEIGHT "Change Height"
#define CHOICE_OPTIONS list("Изменить причёску" = CHANGE_HAIR, "Изменить бороду и усы" = CHANGE_BEARD, "Изменить пол" = CHANGE_SEX, "Изменить глаза" = CHANGE_EYES, "Изменить имя" = CHANGE_NAME, "Изменить цвет кожи" = CHANGE_RACE, "Изменить рост" = CHANGE_HEIGHT)

/datum/action/cooldown/mob_cooldown/shapeshift
	owner_has_control = FALSE
	/// What choices we get to pick.
	var/list/choices = CHOICE_OPTIONS
	var/list/choice_icons
	/// The range of this action.
	var/range = 1

/datum/action/cooldown/mob_cooldown/shapeshift/New(Target, original)
	. = ..()
	update_choices()

/datum/action/cooldown/mob_cooldown/shapeshift/proc/update_choices()
	choice_icons = list()
	for(var/label in choices)
		choice_icons[label] = icon('modular_darkpack/modules/powers/icons/shapeshifting_radial.dmi', choices[label])

/datum/action/cooldown/mob_cooldown/shapeshift/Activate(atom/target)
	. = ..()
	display_radial_menu(target)
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/display_radial_menu(mob/target)
	var/chosen_label = show_radial_menu(owner, target, choice_icons, target, radius = 36, tooltips = TRUE)
	if(!chosen_label)
		return TRUE
	var/chosen_option = choices[chosen_label]

	if(((target.pulledby == owner) && (owner.grab_state >= GRAB_AGGRESSIVE)) || (target == owner))
		switch(chosen_option)
			if(CHANGE_HAIR)
				change_hair(target)
			if(CHANGE_BEARD)
				change_beard(target)
			if(CHANGE_SEX)
				change_sex(target)
			if(CHANGE_NAME)
				change_name(target)
			if(CHANGE_EYES)
				change_eyes(target)
			if(CHANGE_RACE)
				change_race(target)
			if(CHANGE_HEIGHT)
				change_height(target)
	else
		to_chat(owner, span_danger("Сначала нужно крепко схватить [target.declent_ru(ACCUSATIVE)]!"))
		return TRUE

	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	return display_radial_menu(target)

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_sex(mob/living/carbon/human/target)
	var/chosen_sex = tgui_input_list(owner, "Выберите пол.", "Смена пола", list("Мужской", "Женский", "Множественный", "Средний"))
	if(!chosen_sex)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	switch(chosen_sex)
		if("Мужской")
			target.gender = MALE
		if("Женский")
			target.gender = FEMALE
		if("Множественный")
			target.gender = PLURAL
		if("Средний")
			target.gender = NEUTER
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете пол [target.declent_ru(GENITIVE)]."))

	var/chosen_physique = tgui_input_list(owner, "Изменить заодно и телосложение?", "Смена пола", list("Мужское", "Женское"))
	if(!chosen_physique)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.physique = (chosen_physique == "Мужское") ? MALE : FEMALE
	target.dna.update_ui_block(/datum/dna_block/identity/gender)
	target.update_body(is_creating = TRUE) // or else physique won't change properly
	target.update_appearance(UPDATE_OVERLAYS) //(hulk male/female)
	target.update_clothing(ITEM_SLOT_ICLOTHING) // update gender shaped clothing
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете телосложение [target.declent_ru(GENITIVE)]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_eyes(mob/living/carbon/human/target)
	var/new_eye_color = input(owner, "Выберите цвет глаз", "Цвет глаз", target.eye_color_left) as color|null
	if(!new_eye_color)
		return TRUE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_eye_color(sanitize_hexcolor(new_eye_color))
	target.dna.update_ui_block(/datum/dna_block/identity/eye_colors)
	target.update_body()
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете цвет глаз [target.declent_ru(GENITIVE)]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_beard(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Выберите бороду и усы", "Борода и усы", SSaccessories.facial_hairstyles_list)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете бороду и усы [target.declent_ru(GENITIVE)]."))

	var/new_face_color = input(owner, "Выберите цвет бороды и усов", "Цвет волос", target.facial_hair_color) as color|null
	if(!new_face_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_facial_haircolor(sanitize_hexcolor(new_face_color))
	target.dna.update_ui_block(/datum/dna_block/identity/facial_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете цвет бороды и усов [target.declent_ru(GENITIVE)]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_hair(mob/living/carbon/human/target)
	var/new_style = tgui_input_list(owner, "Выберите причёску", "Причёска", SSaccessories.hairstyles_list)
	if(!new_style)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_hairstyle(new_style, update = TRUE)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете причёску [target.declent_ru(GENITIVE)]."))

	var/new_hair_color = input(owner, "Выберите цвет волос", "Цвет волос", target.hair_color) as color|null
	if(!new_hair_color)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_haircolor(sanitize_hexcolor(new_hair_color))
	target.dna.update_ui_block(/datum/dna_block/identity/hair_color)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете цвет волос [target.declent_ru(GENITIVE)]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_name(mob/living/carbon/human/target)
	var/newname = sanitize_name(tgui_input_text(owner, "Так кто же мы теперь?", "Смена имени", target.real_name, MAX_NAME_LEN))
	if(!newname || newname == target.real_name)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.real_name = newname
	if(target.dna)
		target.dna.real_name = newname
	if(target.mind)
		target.mind.name = newname
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы даёте [target.declent_ru(DATIVE)] новое имя."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_race(mob/living/carbon/human/target)
	var/list/skin_tones = list()
	for(var/skin_tone in GLOB.skin_tone_names)
		var/skin_tone_name = GLOB.skin_tone_names[skin_tone]
		skin_tones[skin_tone_name] = skin_tone

	var/new_s_tone = tgui_input_list(owner, "Выберите оттенок кожи", "Цвет кожи", skin_tones)
	new_s_tone = skin_tones[new_s_tone]
	if(!new_s_tone)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.skin_tone = new_s_tone
	target.dna.update_ui_block(/datum/dna_block/identity/skin_tone)
	target.update_body(is_creating = TRUE)
	target.update_appearance(UPDATE_OVERLAYS)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете оттенок кожи [target.declent_ru(GENITIVE)]."))
	return TRUE

/datum/action/cooldown/mob_cooldown/shapeshift/proc/change_height(mob/living/carbon/human/target)
	var/list/heights = list(
		"Очень высокий" = HUMAN_HEIGHT_TALLER,
		"Высокий" = HUMAN_HEIGHT_TALL,
		"Средний" = HUMAN_HEIGHT_MEDIUM,
		"Низкий" = HUMAN_HEIGHT_SHORT,
		"Очень низкий" = HUMAN_HEIGHT_SHORTEST,
		)

	var/new_height = tgui_input_list(owner, "Выберите рост", "Изменение роста", heights)
	new_height = heights[new_height]
	if(!new_height)
		return FALSE
	if(!IN_GIVEN_RANGE(owner, target, range))
		return FALSE
	if(!do_after(owner, delay = 1 TURNS, target = target))
		return FALSE
	target.set_mob_height(new_height)
	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "меняет чужое тело голыми руками") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	playsound(target, 'modular_darkpack/modules/powers/sounds/vicissitude.ogg', 50, TRUE)
	to_chat(owner, span_notice("Вы меняете рост [target.declent_ru(GENITIVE)]."))
	return TRUE

#undef CHANGE_HAIR
#undef CHANGE_BEARD
#undef CHANGE_SEX
#undef CHANGE_EYES
#undef CHANGE_NAME
#undef CHANGE_RACE
#undef CHANGE_HEIGHT
#undef CHOICE_OPTIONS
