/obj/item/ritual_tome/dark
	name = "dark tome"
	desc = "Тайны Инфернала..."
	icon_state = "dark"
	icon = 'modular_vcg/modules/ritual_dark_thaumaturgy/icons/dark_tome.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/ritual_dark_thaumaturgy/icons/dark_tome_onfloor.dmi')
	rune_type = /obj/ritual_rune/dark
	discipline_type = /datum/discipline/daimonion
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT, /datum/material/paper = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/ritual_tome/dark/attack_self(mob/user)
	var/mob/living/living_user = astype(user)
	if(!living_user || !living_user.get_discipline(/datum/discipline/daimonion))
		to_chat(user, span_cult("Книга, чьё заглавие начертано на латыни и покрыто различными сигилами и фигурами. Без наставника в ней не разобраться. К тому же она почему-то не открывается."))
		return
	. = ..()

/datum/crafting_recipe/darktome
	name = "Dark Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/reagent_containers/blood = 2)
	result = /obj/item/ritual_tome/dark
	category = CAT_MISC
	skill_required_for_use = STAT_OCCULT
	skill_dots_minimum = 1

/datum/crafting_recipe/darktome/is_recipe_available(mob/user)
	. = ..()
	var/mob/living/living_user = astype(user)
	if(!living_user?.get_discipline(/datum/discipline/daimonion))
		return FALSE
