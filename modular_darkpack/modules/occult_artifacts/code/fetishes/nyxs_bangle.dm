/* Nyx's Bangle */
/obj/item/occult_artifact/werewolf/nyxs_bangle
	name = "silver bracelet"
	desc = "Браслет-цепочка из серебра. Украшен изящными, но загадочными символами."
	true_name = "Nyx's Bangle"
	true_desc = "Серебряный браслет, покрытый множеством глифов."
	icon_state = "bangle"
	worn_icon_state = "bangle"
	slot_flags = ITEM_SLOT_GLOVES | ITEM_SLOT_ID

	subsystem_type = /datum/controller/subsystem/processing/fastprocess

	ungrant_sound = 'sound/effects/hallucinations/growl1.ogg'

/obj/item/occult_artifact/werewolf/nyxs_bangle/identify()
	. = ..()
	say("Я - [spirit_name]... Укройся же в тени.")

/obj/item/occult_artifact/werewolf/nyxs_bangle/ungrant_powers()
	. = ..()
	owner.alpha = 255

/obj/item/occult_artifact/werewolf/nyxs_bangle/process(seconds_per_tick)
	. = ..()

	var/mob/living/carbon/human/human_owner = astype(owner)
	if(identified && human_owner)
		var/turf/owner_turf = get_turf(owner)
		var/light_amount = owner_turf.get_lumcount()

		if(light_amount <= 0.2)
			if(src == human_owner.gloves || src == human_owner.get_active_held_item() || src == human_owner.get_inactive_held_item())
				human_owner.alpha = max(human_owner.alpha-12.75, 25.5)
			else
				human_owner.alpha = min (human_owner.alpha+25.5, 255)
		else
			human_owner.alpha = min (human_owner.alpha+25.5, 255)

/obj/item/occult_artifact/werewolf/nyxs_bangle/proc/get_held_mob()
	if(isnull(loc))
		return null
	if(isliving(loc))
		return loc
	var/nested_loc = loc.loc
	if (isliving(nested_loc))
		return nested_loc
	return null

/obj/item/occult_artifact/werewolf/nyxs_bangle/Initialize(mapload)
	. = ..()
	spirit_type = pick(SPIRIT_NIGHT, SPIRIT_DARKNESS)
	spirit_name = generate_spirit_name(spirit_type)


/obj/item/occult_artifact/werewolf/nyxs_bangle/examine(mob/user)
	. = ..()
	if(identified)
		. += span_nicegreen("Скрывает в тени всё, кроме ваших звериных глаз.")
		. += span_notice("<b>НАДЕНЬТЕ</b> браслет в слот <b>ID</b> или <b>ПЕРЧАТОК</b> либо <b>ДЕРЖИТЕ</b> его в руке, и тень почти полностью скроет вас.")
		. += span_purple("Внутри обитает [spirit_name].")
