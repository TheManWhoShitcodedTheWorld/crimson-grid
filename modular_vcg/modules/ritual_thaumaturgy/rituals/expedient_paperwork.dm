/obj/ritual_rune/thaumaturgy/expedient_paperwork
	name = "expedient paperwork"
	ru_name = "Ускоренное делопроизводство"
	desc = "Создаёт пакет документов, которые выглядят настолько официальными и безупречными, насколько это вообще возможно."
	icon_state = "rune5"
	word = ""
	level = 1
	sacrifices = list(/obj/item/paper, /obj/item/clothing/watch) // we don't have dog hair
	var/paperwork_name
	var/paperwork_icon
	var/static/list/paperwork_icons = list("docs_generic", "docs_part", "docs_verified", "docs_red", "docs_blue")

/obj/ritual_rune/thaumaturgy/expedient_paperwork/attack_hand(mob/living/user)
	if(activated)
		return

	var/chosen_name = tgui_input_text(user, "Название документа?", "Ускоренное делопроизводство", max_length = MAX_NAME_LEN)
	if(!chosen_name)
		to_chat(user, span_warning("Вы решаете обойтись без бумаг."))
		return FALSE

	var/list/icon_choices = list()
	for(var/state in paperwork_icons)
		icon_choices[state] = image(icon = 'icons/obj/service/bureaucracy.dmi', icon_state = state)

	var/chosen_icon = show_radial_menu(user, src, icon_choices, require_near = TRUE, tooltips = TRUE)
	if(!chosen_icon)
		to_chat(user, span_warning("Вы решаете обойтись без бумаг."))
		return FALSE

	paperwork_name = chosen_name
	paperwork_icon = chosen_icon
	. = ..()

/obj/ritual_rune/thaumaturgy/expedient_paperwork/complete()
	. = ..()

	var/obj/item/paperwork/documents = new(loc)
	documents.ru_names_rename(null)
	documents.name = paperwork_name
	documents.icon_state = paperwork_icon
	documents.desc = "Пакет бумаг и документов, заполненных с величайшим тщанием: похоже, не упущена ни одна мелочь."
	qdel(src)
