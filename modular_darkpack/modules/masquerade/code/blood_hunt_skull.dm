/obj/item/blood_hunt
	name = "ominous skull"
	desc = "Стилизованный череп из мрамора."
	icon = 'modular_darkpack/modules/masquerade/icons/blood_hunt_skull.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/masquerade/icons/onfloor.dmi')
	icon_state = "skull"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/blood_hunt_skull
	resistance_flags = FIRE_PROOF | ACID_PROOF

/datum/armor/blood_hunt_skull
	fire = 100
	acid = 100

/obj/item/blood_hunt/Initialize(mapload)
	. = ..()
	REGISTER_REQUIRED_MAP_ITEM(1, 1)
	GLOB.blood_hunt_announcers += src

/obj/item/blood_hunt/Destroy(force)
	GLOB.blood_hunt_announcers -= src
	return ..()

/obj/item/blood_hunt/examine(mob/user)
	. = ..()
	if(get_kindred_splat(user))
		. += span_notice("Этот артефакт, созданный Тауматургией, позволяет объявить в городе Кровавую Охоту.")
		. += span_notice("С его помощью можно и простить Сородичу нарушение Маскарада: <b>коснитесь</b> его, держа череп в руке.")

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = tgui_input_text(user, "Впишите имя того, на кого объявляется Охота или кому даруется прощение:", "Кровавая Охота", encode = FALSE)
	if(!chosen_name)
		return
	chosen_name = trim(chosen_name)

	var/reason = tgui_input_text(user, "Укажите причину Кровавой Охоты:", "Причина Кровавой Охоты")
	if(!reason)
		return
	reason = sanitize(reason)

	var/mob/target = find_kindred_by_name(chosen_name)
	if(!target)
		to_chat(user, span_danger("В городе нет Сородича с таким именем!"))
		return

	if(HAS_TRAIT(target, TRAIT_HUNTED))
		end_hunt(user, target)
	else
		start_hunt(user, target, reason)

/obj/item/blood_hunt/proc/find_kindred_by_name(name)
	var/wanted = normalize_hunt_name(name)
	for(var/mob/player_mob in GLOB.kindred_list)
		if(normalize_hunt_name(player_mob.real_name) == wanted || normalize_hunt_name(player_mob.name) == wanted)
			return player_mob
	return null

/proc/normalize_hunt_name(text)
	var/static/regex/space_regex = regex(@"\s+", "g")
	text = trim(text)
	text = replacetext(text, "’", "'")
	text = replacetext(text, "‘", "'")
	text = replacetext(text, "`", "'")
	text = space_regex.Replace(text, " ")
	return lowertext(text)

/obj/item/blood_hunt/proc/start_hunt(mob/user, mob/target, reason)
	to_chat(user, span_warning("Вы вносите имя \"[target.real_name]\" в список Кровавой Охоты."))
	RegisterSignals(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED), PROC_REF(complete_hunt))
	log_game("[user.real_name] started a bloodhunt on [target.real_name] for: [reason]")
	message_admins("[ADMIN_LOOKUPFLW(user)]] started a bloodhunt on [target.real_name] for: [reason]")
	target.start_blood_hunt(reason)

/obj/item/blood_hunt/proc/end_hunt(mob/user, mob/target)
	to_chat(user, span_warning("Вы вычёркиваете имя \"[target.real_name]\" из списка Кровавой Охоты."))
	UnregisterSignal(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED))
	log_game("[user.real_name] ended a bloodhunt on [target.real_name].")
	message_admins("[ADMIN_LOOKUPFLW(user)]] ended a bloodhunt on [target.real_name].")
	target.clear_blood_hunt()

/obj/item/blood_hunt/proc/complete_hunt(mob/target)
	SIGNAL_HANDLER

	UnregisterSignal(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED))
	target.clear_blood_hunt()

// This code is for reinforcing a player's masquerade.
/obj/item/blood_hunt/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE
	if(!get_kindred_splat(interacting_with))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("Вы подносите [declent_ru(ACCUSATIVE)] к [interacting_with.declent_ru(DATIVE)]..."))
	if(!do_after(user, 10 SECONDS, interacting_with))
		return ITEM_INTERACT_BLOCKING
	if(SSmasquerade.masquerade_reinforce(src, interacting_with, MASQUERADE_REASON_PREFERENCES))
		to_chat(user, span_notice("Вы прощаете [interacting_with.declent_ru(DATIVE)] нарушение Маскарада!"))
		return ITEM_INTERACT_SUCCESS
	to_chat(user, span_notice("За [interacting_with.declent_ru(INSTRUMENTAL)] нет нарушений Маскарада, которые можно простить!"))
	return ITEM_INTERACT_BLOCKING
