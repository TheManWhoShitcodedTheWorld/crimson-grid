/* Diffrent misc types of sheets
 * Contains:
 * Iron
 * Plasteel
 * Wood
 * Cloth
 * Plastic
 * Cardboard
 * Paper Frames
 * Runed Metal (cult)
 * Bronze (bake brass)
 */

/*
 * Iron
 */
GLOBAL_LIST_INIT(metal_recipes, list ( \
	new/datum/stack_recipe("табурет", /obj/structure/chair/stool, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("барный табурет", /obj/structure/chair/stool/bar, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("кровать", /obj/structure/bed, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("двуспальная кровать", /obj/structure/bed/double, 4, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe_list("офисные кресла", list( \
		new/datum/stack_recipe("тёмное офисное кресло", /obj/structure/chair/office, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("светлое офисное кресло", /obj/structure/chair/office/light, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("кресла", list( \
		new/datum/stack_recipe("бежевое кресло", /obj/structure/chair/comfy/beige, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("чёрное кресло", /obj/structure/chair/comfy/black, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("коричневое кресло", /obj/structure/chair/comfy/brown, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("лаймовое кресло", /obj/structure/chair/comfy/lime, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("бирюзовое кресло", /obj/structure/chair/comfy/teal, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("диваны", list( \
		new /datum/stack_recipe("офисный диван (середина)", /obj/structure/chair/sofa/corp, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("офисный диван (левая часть)", /obj/structure/chair/sofa/corp/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("офисный диван (правая часть)", /obj/structure/chair/sofa/corp/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("офисный диван (угол)", /obj/structure/chair/sofa/corp/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (середина)", /obj/structure/chair/sofa/middle, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (левая часть)", /obj/structure/chair/sofa/left, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (правая часть)", /obj/structure/chair/sofa/right, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("диван (угол)", /obj/structure/chair/sofa/corner, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("ретро-диван (середина)", /obj/structure/chair/sofa/middle/brown, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("ретро-диван (левая часть)", /obj/structure/chair/sofa/left/brown, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("ретро-диван (правая часть)", /obj/structure/chair/sofa/right/brown, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("ретро-диван (угол)", /obj/structure/chair/sofa/corner/brown, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE) \
	)), \
	new /datum/stack_recipe_list("скамьи", list( \
		new /datum/stack_recipe("скамья (середина)", /obj/structure/chair/sofa/bench, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамья (левая часть)", /obj/structure/chair/sofa/bench/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамья (правая часть)", /obj/structure/chair/sofa/bench/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("скамья (угол)", /obj/structure/chair/sofa/bench/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("трамвайная скамья (одиночная)", /obj/structure/chair/sofa/bench/tram/solo, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("трамвайная скамья (середина)", /obj/structure/chair/sofa/bench/tram, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("трамвайная скамья (левая часть)", /obj/structure/chair/sofa/bench/tram/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("трамвайная скамья (правая часть)", /obj/structure/chair/sofa/bench/tram/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("трамвайная скамья (угол)", /obj/structure/chair/sofa/bench/tram/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new /datum/stack_recipe_list("шахматные фигуры", list( \
		new /datum/stack_recipe("белая пешка", /obj/structure/chess/whitepawn, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белая ладья", /obj/structure/chess/whiterook, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белый конь", /obj/structure/chess/whiteknight, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белый слон", /obj/structure/chess/whitebishop, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белый ферзь", /obj/structure/chess/whitequeen, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белый король", /obj/structure/chess/whiteking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрная пешка", /obj/structure/chess/blackpawn, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрная ладья", /obj/structure/chess/blackrook, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрный конь", /obj/structure/chess/blackknight, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрный слон", /obj/structure/chess/blackbishop, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрный ферзь", /obj/structure/chess/blackqueen, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрный король", /obj/structure/chess/blackking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	)),
	new /datum/stack_recipe_list("шашки", list( \
		new /datum/stack_recipe("белая шашка", /obj/structure/chess/checker/whiteman, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("белая дамка", /obj/structure/chess/checker/whiteking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрная шашка", /obj/structure/chess/checker/blackman, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("чёрная дамка", /obj/structure/chess/checker/blackking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	)),
	// DARKPACK EDIT CHANGE START
	null, \
	new/datum/stack_recipe("детали стеллажа", /obj/item/rack_parts, category = CAT_FURNITURE), \
	new/datum/stack_recipe("шкаф", /obj/structure/closet, 2, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe("напольная плитка", /obj/item/stack/tile/iron/base, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("железный прут", /obj/item/stack/rods, 1, 2, 60, category = CAT_MISC), \
	null, \
	new/datum/stack_recipe("стеновой каркас (закреплённый)", /obj/structure/girder, 2, time = 4 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, placement_checks = STACK_CHECK_TRAM_FORBIDDEN, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	new /datum/stack_recipe_list("помосты (закреплённые)", list( \
		new /datum/stack_recipe("скруглённый помост", /obj/structure/platform, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
		new /datum/stack_recipe("грубый помост", /obj/structure/platform/iron, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
		new /datum/stack_recipe("ступени помоста", /obj/structure/steps, 2, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	)),
	null, \
	new/datum/stack_recipe("каркас компьютера", /obj/structure/frame/computer, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("модульная консоль", /obj/machinery/modular_computer, 10, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас аппарата", /obj/structure/frame/machine, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("каркас противопожарной двери", /obj/structure/firelock_frame, 3, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	new/datum/stack_recipe("каркас направленной противопожарной двери", /obj/structure/firelock_frame/border_only, 2, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_DOORS), \
	new/datum/stack_recipe("каркас мясного крюка", /obj/structure/kitchenspike_frame, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("корпус гранаты", /obj/item/grenade/chem_grenade, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("каркас светильника", /obj/item/wallframe/light_fixture, 2, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас малого светильника", /obj/item/wallframe/light_fixture/small, 1, crafting_flags = NONE, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("каркас шкафчика для огнетушителя", /obj/item/wallframe/extinguisher_cabinet, 2, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас кнопки", /obj/item/wallframe/button, 1, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас выключателя", /obj/item/wallframe/light_switch, 1, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("корпус камеры", /obj/item/wallframe/camera, 1, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас интеркома", /obj/item/wallframe/intercom, 2, crafting_flags = NONE, category = CAT_STRUCTURE), \
	null, \
	new/datum/stack_recipe("картотечный шкаф", /obj/structure/filingcabinet, 2, time = 10 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("настольный звонок", /obj/structure/desk_bell, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("каркас прожектора", /obj/structure/floodlight_frame, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("урна для голосования", /obj/structure/votebox, 15, time = 5 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("пестик", /obj/item/pestle, 1, time = 5 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("каркас душа", /obj/structure/showerframe, 2, time = 2 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("писсуар", /obj/item/wallframe/urinal, 2, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE)
))
// DARKPACK EDIT CHANGE END
/obj/item/stack/sheet/iron
	name = "iron"
	desc = "Листы железа."
	singular_name = "iron sheet"
	icon_state = "sheet-metal"
	worn_icon_state = "sheet-metal"
	inhand_icon_state = "sheet-metal"
	mats_per_unit = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	throwforce = 10
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/iron
	gulag_value = 5
	table_type = /obj/structure/table
	material_type = /datum/material/iron
	matter_amount = 4
	cost = 1 // SHEET_MATERIAL_AMOUNT // CORVAX EDIT
	source = /datum/robot_energy_storage/material/iron
	stairs_type = /obj/structure/stairs
	sniffable = TRUE

/obj/item/stack/sheet/iron/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Craft iron rods",
			SCREENTIP_CONTEXT_RMB = "Craft floor tiles",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/stack/sheet/iron/examine(mob/user)
	. = ..()
	. += span_notice("ПКМ по полу, чтобы собрать:")
	. += span_notice("- незакреплённый стеновой каркас")
	. += span_notice("- каркас компьютера или аппарата (если в руке плата)")

/obj/item/stack/sheet/iron/fifty
	amount = 50

/obj/item/stack/sheet/iron/twenty
	amount = 20

/obj/item/stack/sheet/iron/ten
	amount = 10

/obj/item/stack/sheet/iron/five
	amount = 5

/obj/item/stack/sheet/iron/get_main_recipes()
	. = ..()
	. += GLOB.metal_recipes

/obj/item/stack/sheet/iron/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins whacking [user.p_them()]self over the head with \the [src]! Кажется, [user.ru_p_they()] пытается совершить самоубийство!"))
	return BRUTELOSS

/obj/item/stack/sheet/iron/welder_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/rods/two/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] переплавляет [declent_ru(ACCUSATIVE)] в прутья."),
			blind_message = span_hear("Вы слышите звуки сварки."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/sheet/iron/welder_act_secondary(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/tile/iron/four/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] переплавляет [declent_ru(ACCUSATIVE)] в напольную плитку."),
			blind_message = span_hear("Вы слышите звуки сварки."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/sheet/iron/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isopenturf(interacting_with))
		return NONE
	var/turf/open/build_on = interacting_with
	if(!user.Adjacent(build_on))
		return ITEM_INTERACT_BLOCKING
	if(isgroundlessturf(build_on))
		user.balloon_alert(user, "здесь не поставить!")
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "что-то мешает!")
		return ITEM_INTERACT_BLOCKING

	var/frame_path = null
	var/cost = 2 // Default girder cost
	var/time = 4 SECONDS //Default girder build time
	var/obj/item/circuitboard/held_board = locate() in user.held_items
	if(!isnull(held_board))
		if(istype(held_board, /obj/item/circuitboard/machine))
			frame_path = /obj/structure/frame/machine
		else
			frame_path = /obj/structure/frame/computer
		for(var/datum/stack_recipe/recipe in GLOB.metal_recipes)
			if(recipe.result_type == frame_path)
				time = recipe.time
				cost = recipe.req_amount
				break
	if(get_amount() < cost)
		user.balloon_alert(user, "нужно листов металла: [cost]!")
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, time, build_on))
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "что-то мешает!")
		return ITEM_INTERACT_BLOCKING
	if(!use(cost))
		user.balloon_alert(user, "не хватает материала!")
		return ITEM_INTERACT_BLOCKING
	if(frame_path)
		var/obj/structure/frame/constructed_frame = new frame_path(build_on)
		constructed_frame.setDir(REVERSE_DIR(user.dir)) //to align computer frame with player direction
		user.balloon_alert(user, "каркас собран")
	else
		new/obj/structure/girder/displaced(build_on)
		user.balloon_alert(user, "каркас стены собран")
	return ITEM_INTERACT_SUCCESS

/*
 * Plasteel
 */
// DARKPACK EDIT CHANGE START
GLOBAL_LIST_INIT(plasteel_recipes, list ( \
	new/datum/stack_recipe("каркас рольставней", /obj/machinery/door/poddoor/shutters/preopen/deconstructed, 5, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_DOORS),
	new/datum/stack_recipe("большой металлический ящик", /obj/structure/closet/cardboard/metal, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS),
	null,
	new /datum/stack_recipe_list("каркасы шлюзов", list( \
		new/datum/stack_recipe("каркас шлюза повышенной защиты", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS),
		new/datum/stack_recipe("каркас двери хранилища", /obj/structure/door_assembly/door_assembly_vault, 6, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS),
	)), \
	new /datum/stack_recipe("радарная вышка", /obj/machinery/power/weather_tower/constructed, 12, time = 10 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
))
// DARKPACK EDIT CHANGE END
/obj/item/stack/sheet/plasteel
	name = "plasteel"
	singular_name = "plasteel sheet"
	desc = "Лист сплава железа и плазмы."
	icon_state = "sheet-plasteel"
	worn_icon_state = "sheet-plasteel"
	inhand_icon_state = "sheet-plasteel"
	mats_per_unit = list(/datum/material/alloy/plasteel=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasteel
	throwforce = 10
	obj_flags = CONDUCTS_ELECTRICITY
	armor_type = /datum/armor/sheet_plasteel
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/plasteel
	gulag_value = 10
	table_type = /obj/structure/table/reinforced
	material_flags = NONE
	matter_amount = 12

/datum/armor/sheet_plasteel
	fire = 100
	acid = 80

/obj/item/stack/sheet/plasteel/get_main_recipes()
	. = ..()
	. += GLOB.plasteel_recipes

/obj/item/stack/sheet/plasteel/twenty
	amount = 20

/obj/item/stack/sheet/plasteel/fifty
	amount = 50

/*
 * Wood
 */
// DARKPACK EDIT CHANGE START
GLOBAL_LIST_INIT(wood_recipes, list ( \
	new/datum/stack_recipe("деревянные сандалии", /obj/item/clothing/shoes/sandal, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("деревянная плитка", /obj/item/stack/tile/wood, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	new/datum/stack_recipe("каркас деревянного стола", /obj/structure/table_frame/wood, 2, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new /datum/stack_recipe_list("помосты (закреплённые)", list( \
		new /datum/stack_recipe("деревянный помост", /obj/structure/platform/wood, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
		new /datum/stack_recipe("деревянная сцена", /obj/structure/platform/wood/stage, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	)),
	new/datum/stack_recipe("скалка", /obj/item/kitchen/rollingpin, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("деревянный стул", /obj/structure/chair/wood/, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянный стул с высокой спинкой", /obj/structure/chair/wood/wings, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянная баррикада", /obj/structure/barricade/wooden, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("каркас деревянной лестницы", /obj/structure/stairs_frame/wood, 10, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("деревянный забор", /obj/structure/railing/darkpack/wood, 2, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("кошачий домик", /obj/structure/cat_house, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("гроб", /obj/structure/closet/crate/coffin, 5, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("книжный шкаф", /obj/structure/bookcase, 4, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("сушилка", /obj/machinery/smartfridge/drying/rack, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), \
	new/datum/stack_recipe("деревянная бочка", /obj/structure/fermenting_barrel, 8, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("собачья лежанка", /obj/structure/bed/dogbed, 10, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("судейский молоток", /obj/item/gavelhammer, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("подставка для молотка", /obj/item/gavelblock, 1, time = 2 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("комод", /obj/structure/dresser, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("шкафчик", /obj/structure/closet/cabinet, 2, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("фоторамка", /obj/item/wallframe/picture, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("рама для картины", /obj/item/wallframe/painting, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("каркас витрины", /obj/structure/displaycase_chassis, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("деревянный баклер", /obj/item/shield/buckler, 20, time = 4 SECONDS, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("улей", /obj/structure/beebox, 40, time = 5 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("манекен", /obj/structure/mannequin/wood, 25, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("маска тики", /obj/item/clothing/mask/gas/tiki_mask, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("курительная трубка", /obj/item/cigarette/pipe, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("рамка для сот", /obj/item/honey_frame, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("деревянное ведро", /obj/item/reagent_containers/cup/bucket/wooden, 3, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CONTAINERS),\
	new/datum/stack_recipe("грабли", /obj/item/cultivator/rake, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("деревянный ящик", /obj/structure/closet/crate/wooden, 6, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),\
	new/datum/stack_recipe("бейсбольная бита", /obj/item/melee/baseball_bat, 5, time = 1.5 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE, removed_mats = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 1.5)),\
	new/datum/stack_recipe("деревянный костыль", /obj/item/cane/crutch/wood, 5, time = 1.5 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE),\
	new/datum/stack_recipe("ткацкий станок", /obj/structure/loom, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), \
	new/datum/stack_recipe("ступка", /obj/item/reagent_containers/cup/mortar, 3, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("головня", /obj/item/match/firebrand, 2, time = 10 SECONDS, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("костёр", /obj/structure/bonfire, 10, time = 6 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), \
	new/datum/stack_recipe("мольберт", /obj/structure/easel, 5, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("доска объявлений", /obj/item/wallframe/noticeboard, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("подставка для рыбы", /obj/item/wallframe/fish, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE),\
	new/datum/stack_recipe("штатив для пробирок", /obj/item/storage/test_tube_rack, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	null, \
	new/datum/stack_recipe_list("церковные скамьи", list(
		new /datum/stack_recipe("церковная скамья (середина)", /obj/structure/chair/pew, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("церковная скамья (левая часть)", /obj/structure/chair/pew/left, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("церковная скамья (правая часть)", /obj/structure/chair/pew/right, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE)
		)),
	new/datum/stack_recipe_list("деревянные протезы", list(
		new /datum/stack_recipe("деревянный протез руки (левый)", /obj/item/bodypart/arm/left/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("деревянный протез руки (правый)", /obj/item/bodypart/arm/right/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("деревянный протез ноги (левый)", /obj/item/bodypart/leg/left/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("деревянный протез ноги (правый)", /obj/item/bodypart/leg/right/ghetto, 2, crafting_flags = NONE, category = CAT_MISC)
	)),
	null, \
	))
// DARKPACK EDIT CHANGE END
/obj/item/stack/sheet/mineral/wood
	name = "wooden plank"
	desc = "Есть подозрение, что это доски."
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	worn_icon_state = "sheet-wood"
	inhand_icon_state = "sheet-wood"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/wood=SHEET_MATERIAL_AMOUNT)
	construction_path_type = "wood"
	armor_type = /datum/armor/mineral_wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/wood
	material_type = /datum/material/wood
	walltype = /turf/closed/wall/mineral/wood
	stairs_type = /obj/structure/stairs/wood
	pickup_sound = 'sound/items/handling/materials/wood_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/wood_drop.ogg'

/datum/armor/mineral_wood
	fire = 50

/obj/item/stack/sheet/mineral/wood/get_main_recipes()
	. = ..()
	. += GLOB.wood_recipes

/obj/item/stack/sheet/mineral/wood/fifty
	amount = 50

/obj/item/stack/sheet/mineral/wood/interact_with_atom(mob/living/carbon/human/target, mob/user)
	if(!istype(target))
		return NONE

	var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
	if(affecting && IS_PEG_LIMB(affecting))
		if(user == target)
			user.visible_message(span_notice("[capitalize(user.declent_ru(NOMINATIVE))] принимается чинить свой деревянный протез."), span_notice("Вы принимаетесь чинить свой деревянный протез."))
			if(!do_after(user, 5 SECONDS, target))
				return ITEM_INTERACT_FAILURE
		if(target.item_heal(user, brute_heal = 15, burn_heal = 15, heal_message_brute = "расколы", heal_message_burn = "обугление", required_bodytype = BODYTYPE_PEG))
			use(1)
		return ITEM_INTERACT_SUCCESS
	else
		return NONE

// CRIMSON EDIT ADD START - Sell Wood
/obj/item/stack/sheet/mineral/wood/Initialize(mapload, new_amount, merge = TRUE, list/mat_override = null, mat_amt = 1)
	. = ..()
	AddComponent(/datum/component/selling, 0, "wood", FALSE) // CORVAX EDIT
// CRIMSON EDIT ADD END - Sell Wood

/*
 * Bamboo
 */
GLOBAL_LIST_INIT(bamboo_recipes, list ( \
	new/datum/stack_recipe("ловушка с кольями", /obj/structure/punji_sticks, 5, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("бамбуковое копьё", /obj/item/spear/bamboospear, 25, time = 9 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE), \
	new/datum/stack_recipe("духовая трубка", /obj/item/gun/syringe/blowgun, 10, time = 7 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_RANGED), \
	new/datum/stack_recipe("самодельный шприц", /obj/item/reagent_containers/syringe/crude, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("соломенная шляпа", /obj/item/clothing/head/costume/rice_hat, 10, time = 7 SECONDS, crafting_flags = CRAFT_SKIP_MATERIALS_PARITY, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("бамбуковый табурет", /obj/structure/chair/stool/bamboo, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("бамбуковая циновка", /obj/item/stack/tile/bamboo, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	null, \
	new /datum/stack_recipe("бамбуковый помост", /obj/structure/platform/bamboo, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	new/datum/stack_recipe_list("бамбуковые скамьи", list(
		new /datum/stack_recipe("бамбуковая скамья (середина)", /obj/structure/chair/sofa/bamboo, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("бамбуковая скамья (левая часть)", /obj/structure/chair/sofa/bamboo/left, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("бамбуковая скамья (правая часть)", /obj/structure/chair/sofa/bamboo/right, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE)
		)),	\
	))

/obj/item/stack/sheet/mineral/bamboo
	name = "bamboo cuttings"
	desc = "Аккуратно нарезанные стебли бамбука."
	singular_name = "cut bamboo stick"
	icon_state = "sheet-bamboo"
	inhand_icon_state = "sheet-bamboo"
	icon = 'icons/obj/stack_objects.dmi'
	construction_path_type = "bamboo"
	mats_per_unit = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT)
	throwforce = 15
	armor_type = /datum/armor/mineral_bamboo
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/bamboo
	material_type = /datum/material/bamboo
	walltype = /turf/closed/wall/mineral/bamboo
	drop_sound = null
	pickup_sound = null

/datum/armor/mineral_bamboo
	fire = 50

/obj/item/stack/sheet/mineral/bamboo/get_main_recipes()
	. = ..()
	. += GLOB.bamboo_recipes

/obj/item/stack/sheet/mineral/bamboo/fifty
	amount = 50

/*
 * Cloth
 */
GLOBAL_LIST_INIT(cloth_recipes, list ( \
	new/datum/stack_recipe("белый комбинезон с юбкой", /obj/item/clothing/under/color/jumpskirt/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), /*Ladies first*/ \
	new/datum/stack_recipe("белый комбинезон", /obj/item/clothing/under/color/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белые туфли", /obj/item/clothing/shoes/sneakers/white, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белый шарф", /obj/item/clothing/neck/scarf, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая бандана", /obj/item/clothing/mask/bandana/white, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("рюкзак", /obj/item/storage/backpack, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка", /obj/item/storage/backpack/satchel, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка через плечо", /obj/item/storage/backpack/messenger, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("спортивная сумка", /obj/item/storage/backpack/duffelbag, 6, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("сумка для растений", /obj/item/storage/bag/plants, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для книг", /obj/item/storage/bag/books, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для руды", /obj/item/storage/bag/ore, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для химикатов", /obj/item/storage/bag/chemistry, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для биоматериала", /obj/item/storage/bag/bio, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для образцов", /obj/item/storage/bag/xeno, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("сумка для стройматериалов", /obj/item/storage/bag/construction, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("самодельный бинт", /obj/item/stack/medical/wrap/gauze/improvised, 1, 2, 6, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("тряпка", /obj/item/rag, 1, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("простыня", /obj/item/bedsheet, 3, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("двуспальная простыня", /obj/item/bedsheet/double, 6, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("пустой мешок для песка", /obj/item/emptysandbag, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("перчатки без пальцев", /obj/item/clothing/gloves/fingerless, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белые перчатки", /obj/item/clothing/gloves/color/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая кепка", /obj/item/clothing/head/soft/mime, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("белая шапка-бини", /obj/item/clothing/head/beanie, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("повязка на глаза", /obj/item/clothing/glasses/blindfold, 2, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	null, \
	new/datum/stack_recipe("холст 19x19", /obj/item/canvas/nineteen_nineteen, 3, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("холст 23x19", /obj/item/canvas/twentythree_nineteen, 4, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("холст 23x23", /obj/item/canvas/twentythree_twentythree, 5, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("подушка", /obj/item/pillow, 3, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "Хлопок? Лён? Джинса? Мешковина? Брезент? Так сразу и не скажешь."
	singular_name = "cloth roll"
	icon_state = "sheet-cloth"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cloth
	drop_sound = 'sound/items/handling/cloth/cloth_drop1.ogg'
	pickup_sound = 'sound/items/handling/cloth/cloth_pickup1.ogg'
	pickup_sound = SFX_CLOTH_PICKUP
	drop_sound = SFX_CLOTH_DROP

/obj/item/stack/sheet/cloth/grind_results()
	return list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += GLOB.cloth_recipes

/obj/item/stack/sheet/cloth/ten
	amount = 10

/obj/item/stack/sheet/cloth/five
	amount = 5
// DARKPACK EDIT REMOVAL
/obj/item/stack/sheet/durathread
	name = "durathread"
	desc = "Ткань из невероятно прочных нитей. Ценится теми, кто шьёт защитную одежду."
	singular_name = "durathread roll"
	icon_state = "sheet-durathread"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/durathread
	drop_sound = 'sound/items/handling/cloth/cloth_drop1.ogg'
	pickup_sound = 'sound/items/handling/cloth/cloth_pickup1.ogg'
/* // DARKPACK EDIT REMOVAL
/obj/item/stack/sheet/durathread/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/durathread_helmet, /datum/crafting_recipe/durathread_vest)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/durathread/get_main_recipes()
	. = ..()
	. += GLOB.durathread_recipes
*/
/obj/item/stack/sheet/durathread/used_in_craft(atom/created, datum/crafting_recipe/recipe)
	. = ..()
	created.set_armor_rating(CONSUME, max(50, created.get_armor_rating(CONSUME)))

/obj/item/stack/sheet/cotton
	name = "raw cotton bundle"
	desc = "Охапка хлопка-сырца. Можно отправлять на ткацкий станок."
	singular_name = "raw cotton ball"
	icon_state = "sheet-cotton"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cotton
	drop_sound = 'sound/items/handling/cloth/cloth_drop1.ogg'
	pickup_sound = 'sound/items/handling/cloth/cloth_pickup1.ogg'

	var/loom_result = /obj/item/stack/sheet/cloth
	var/loom_time = 1 SECONDS

/obj/item/stack/sheet/cotton/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/loomable, resulting_atom = loom_result, loom_time = loom_time)

/obj/item/stack/sheet/cotton/grind_results()
	return list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cotton/durathread
	name = "raw durathread bundle"
	desc = "A bundle of raw durathread ready to be spun on the loom."
	singular_name = "raw durathread ball"
	icon_state = "sheet-durathreadraw"
	merge_type = /obj/item/stack/sheet/cotton/durathread
	loom_result = /obj/item/stack/sheet/durathread

/obj/item/stack/sheet/cotton/wool
	name = "raw wool bundle"
	desc = "A bundle of raw wool ready to be spun on the loom."
	singular_name = "raw wool ball"
	icon_state = "sheet-wool"
	merge_type = /obj/item/stack/sheet/cotton/wool
	loom_result = /obj/item/stack/sheet/cloth

/*
 * Cardboard
 */
// DARKPACK EDIT CHANGE START
GLOBAL_LIST_INIT(cardboard_recipes, list ( \
	new/datum/stack_recipe("коробка", /obj/item/storage/box, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("большая коробка", /obj/structure/closet/cardboard, 4, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("средняя коробка", /obj/structure/closet/crate/cardboard, 4, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("картонная фигура", /obj/item/cardboard_cutout, 5, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	null, \

	new/datum/stack_recipe("коробка для пиццы", /obj/item/pizzabox, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("папка", /obj/item/folder, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	//TO-DO: Find a proper way to just change the illustration on the box. Code isn't the issue, input is.
	new/datum/stack_recipe_list("фирменные коробки", list(
		new /datum/stack_recipe("коробка для пончиков", /obj/item/storage/fancy/donut_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("упаковка для яиц", /obj/item/storage/fancy/egg_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка донк-покетов", /obj/item/storage/box/donkpockets, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка острых донк-покетов", /obj/item/storage/box/donkpockets/donkpocketspicy, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка донк-покетов терияки", /obj/item/storage/box/donkpockets/donkpocketteriyaki, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка донк-покетов с пиццей", /obj/item/storage/box/donkpockets/donkpocketpizza, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка ягодных донк-покетов", /obj/item/storage/box/donkpockets/donkpocketberry, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка хонк-покетов", /obj/item/storage/box/donkpockets/donkpockethonk, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка для наггетсов", /obj/item/storage/fancy/nugget_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("красная коробка для наггетсов", /obj/item/storage/fancy/nugget_box/red, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("красная коробка для крылышек", /obj/item/storage/fancy/wing_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("красная коробка для картошки фри", /obj/item/storage/fancy/fry_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка стаканов", /obj/item/storage/box/drinkingglasses, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка бумажных стаканчиков", /obj/item/storage/box/cups, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("портсигар", /obj/item/storage/fancy/cigarettes/cigars, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("коробка боевых патронов", /obj/item/storage/box/lethalshot, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка резиновых патронов", /obj/item/storage/box/rubbershot, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка травматических патронов", /obj/item/storage/box/beanbag, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка светошумовых гранат", /obj/item/storage/box/flashbangs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка вспышек", /obj/item/storage/box/flashes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка наручников", /obj/item/storage/box/handcuffs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка ID-карт", /obj/item/storage/box/ids, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка КПК", /obj/item/storage/box/pdas, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \
		new /datum/stack_recipe("коробка баночек для таблеток", /obj/item/storage/box/pillbottles, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка медицинских гелей", /obj/item/storage/box/medigels, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка мензурок", /obj/item/storage/box/beakers, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка шприцев", /obj/item/storage/box/syringes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка латексных перчаток", /obj/item/storage/box/gloves, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка стерильных масок", /obj/item/storage/box/masks, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка мешков для трупов", /obj/item/storage/box/bodybags, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка очков с диоптриями", /obj/item/storage/box/rxglasses, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка медипенов", /obj/item/storage/box/medipens, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка ДНК-инъекторов", /obj/item/storage/box/injectors, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка кислородных баллонов", /obj/item/storage/box/emergencytank, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка увеличенных кислородных баллонов", /obj/item/storage/box/engitank, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \
		new /datum/stack_recipe("коробка дискет", /obj/item/storage/box/disks, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка ламп дневного света", /obj/item/storage/box/lights/tubes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка лампочек", /obj/item/storage/box/lights/bulbs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка ламп (ассорти)", /obj/item/storage/box/lights/mixed, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка мышеловок", /obj/item/storage/box/mousetraps, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка свечей", /obj/item/storage/fancy/candle_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("коробка бинтов", /obj/item/storage/box/bandages, crafting_flags = NONE, category = CAT_CONTAINERS)
		)),

	null, \
))
// DARKPACK EDIT CHANGE END

/obj/item/stack/sheet/cardboard
	name = "cardboard"
	desc = "Большие листы картона, вроде разложенных коробок."
	singular_name = "cardboard sheet"
	icon_state = "sheet-card"
	worn_icon_state = "sheet-card"
	inhand_icon_state = "sheet-card"
	mats_per_unit = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cardboard
	material_type = /datum/material/cardboard
	pickup_sound = 'sound/items/handling/materials/cardboard_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/cardboard_drop.ogg'
/* // DARKPACK EDIT REMOVAL
/obj/item/stack/sheet/cardboard/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/cardboard_id)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)
 */

/obj/item/stack/sheet/cardboard/get_main_recipes()
	. = ..()
	. += GLOB.cardboard_recipes

/obj/item/stack/sheet/cardboard/fifty
	amount = 50

/obj/item/stack/sheet/cardboard/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stamp/clown) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(!use(1))
			return ITEM_INTERACT_BLOCKING
		playsound(tool, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
		to_chat(user, span_notice("You stamp the cardboard! It's a clown box! Honk!"))
		new /obj/item/storage/box/clown(droploc) //bugfix
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stamp/chameleon) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(!use(1))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("You stamp the cardboard in a sinister way."))
		new /obj/item/storage/box/syndie_kit(droploc)
		return ITEM_INTERACT_SUCCESS

	return ..()

/*
 * Bronze
 */
// DARKPACK EDIT CHANGE START
GLOBAL_LIST_INIT(bronze_recipes, list ( \
	new /datum/stack_recipe("заводной помост", /obj/structure/platform/bronze, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	null,
	new/datum/stack_recipe("бронзовая плитка", /obj/item/stack/tile/bronze, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	new/datum/stack_recipe("бронзовая шляпа", /obj/item/clothing/head/costume/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("бронзовый костюм", /obj/item/clothing/suit/costume/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("бронзовые сапоги", /obj/item/clothing/shoes/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	null,
	new/datum/stack_recipe("бронзовый стул", /obj/structure/chair/bronze, 1, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
))
// DARKPACK EDIT CHANGE END
/obj/item/stack/sheet/bronze
	name = "bronze"
	desc = "On closer inspection, what appears to be wholly-unsuitable-for-building brass is actually more structurally stable bronze."
	singular_name = "bronze sheet"
	icon_state = "sheet-brass"
	worn_icon_state = "sheet-brass"
	inhand_icon_state = "sheet-brass"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	construction_path_type = "bronze"
	force = 5
	throwforce = 10
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/bronze
	table_type = /obj/structure/table/bronze
	material_type = /datum/material/bronze
	walltype = /turf/closed/wall/mineral/bronze
	has_unique_girder = TRUE

/obj/item/stack/sheet/bronze/get_main_recipes()
	. = ..()
	. += GLOB.bronze_recipes

/obj/item/stack/sheet/bronze/thirty
	amount = 30

/*
 * Lesser and Greater gems - unused
 */
/obj/item/stack/sheet/lessergem
	name = "lesser gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "lesser gem"
	icon_state = "sheet-lessergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/lessergem

/obj/item/stack/sheet/greatergem
	name = "greater gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "greater gem"
	icon_state = "sheet-greatergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/greatergem

/*
 * Bones
 */
/obj/item/stack/sheet/bone
	name = "bones"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "bone"
	inhand_icon_state = null
	mats_per_unit = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
	singular_name = "bone"
	desc = "Кто-то в детстве пил много молока."
	force = 7
	throwforce = 5
	max_amount = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	merge_type = /obj/item/stack/sheet/bone
	material_type = /datum/material/bone
	drop_sound = null
	pickup_sound = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/item/stack/sheet/bone/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	// As bone and sinew have just a little too many recipes for this, we'll just split them up.
	// Sinew slapcrafting will mostly-sinew recipes, and bones will have mostly-bones recipes.
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/bonearmor,
		/datum/crafting_recipe/boneaxe,
		/datum/crafting_recipe/bonedagger,
		/datum/crafting_recipe/bonespear,
		/datum/crafting_recipe/bracers,
		/datum/crafting_recipe/skullhelm,
	)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/*
 * Plastic
 */
GLOBAL_LIST_INIT(plastic_recipes, list(
	new /datum/stack_recipe("пластиковая плитка", /obj/item/stack/tile/plastic, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
	new /datum/stack_recipe("складной пластиковый стул", /obj/structure/chair/plastic, 2, crafting_flags = NONE, category = CAT_FURNITURE), \
	new /datum/stack_recipe("пластиковая завеса", /obj/structure/plasticflaps, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, time = 4 SECONDS, category = CAT_FURNITURE), \
	new /datum/stack_recipe("бутылка воды", /obj/item/reagent_containers/cup/glass/waterbottle/empty, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("большая бутылка воды", /obj/item/reagent_containers/cup/glass/waterbottle/large/empty, 3, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("пластиковые стаканчики", /obj/item/reagent_containers/cup/glass/colocup, 1, crafting_flags = NONE, category = CAT_CONTAINERS, removed_mats = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)), \
	new /datum/stack_recipe("манекен", /obj/structure/mannequin/plastic, 25, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_ENTERTAINMENT), \
	new /datum/stack_recipe("табличка \"Мокрый пол\"", /obj/item/clothing/suit/caution, 2, crafting_flags = CRAFT_SKIP_MATERIALS_PARITY, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("дорожный конус", /obj/item/clothing/head/cone, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("пустая настенная вывеска", /obj/item/sign, 1, crafting_flags = NONE, category = CAT_FURNITURE), \
	new /datum/stack_recipe("бутыль для кулера", /obj/item/reagent_containers/cooler_jug, 4, time = 5 SECONDS, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("кулер", /obj/structure/reagent_dispensers/water_cooler/jugless, 25, time = 10 SECONDS, crafting_flags = NONE, category = CAT_STRUCTURE), \
	new /datum/stack_recipe("маска бунтаря", /obj/item/clothing/mask/rebellion, 1, crafting_flags = NONE, category = CAT_CLOTHING)))
// DARKPACK EDIT CHANGE END
/obj/item/stack/sheet/plastic
	name = "plastic"
	desc = "Спрессуйте динозавра, подождите пару миллионов лет, очистите, разделите на фракции, отлейте в форму, и вуаля! У вас пластик."
	singular_name = "plastic sheet"
	icon_state = "sheet-plastic"
	worn_icon_state = "sheet-plastic"
	inhand_icon_state = "sheet-plastic"
	mats_per_unit = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)
	throwforce = 7
	material_type = /datum/material/plastic
	merge_type = /obj/item/stack/sheet/plastic
	pickup_sound = 'sound/items/handling/materials/plastic_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/plastic_drop.ogg'

/obj/item/stack/sheet/plastic/fifty
	amount = 50

/obj/item/stack/sheet/plastic/five
	amount = 5

/obj/item/stack/sheet/plastic/get_main_recipes()
	. = ..()
	. += GLOB.plastic_recipes

/*
 * Paper Frames
 */
GLOBAL_LIST_INIT(paperframe_recipes, list(
	new /datum/stack_recipe("бумажная перегородка", /obj/structure/window/paperframe, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, time = 1 SECONDS), \
	new /datum/stack_recipe("бумажная раздвижная дверь", /obj/structure/mineral_door/paperframe, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, time = 1 SECONDS ), \
	new /datum/stack_recipe("бумажный помост", /obj/structure/platform/paper, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
))

/obj/item/stack/sheet/paperframes
	name = "paper frames"
	desc = "Тонкая деревянная рамка, обтянутая бумагой."
	singular_name = "paper frame"
	icon_state = "sheet-paper"
	worn_icon_state = "sheet-paper"
	inhand_icon_state = "sheet-paper"
	mats_per_unit = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/paperframes
	resistance_flags = FLAMMABLE
	material_type = /datum/material/paper
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/paperframes/get_main_recipes()
	. = ..()
	. += GLOB.paperframe_recipes
/obj/item/stack/sheet/paperframes/five
	amount = 5
/obj/item/stack/sheet/paperframes/twenty
	amount = 20
/obj/item/stack/sheet/paperframes/fifty
	amount = 50

/*
 * Meat
 */
/obj/item/stack/sheet/meat
	name = "meat sheets"
	desc = "Чьё-то кровавое мясо, спрессованное в аккуратный плотный пласт."
	singular_name = "meat sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_NO_DESCRIPTORS
	mats_per_unit = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/meat
	material_type = /datum/material/meat
	material_modifier = 1 //None of that wussy stuff
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/meat/fifty
	amount = 50
/obj/item/stack/sheet/meat/twenty
	amount = 20
/obj/item/stack/sheet/meat/five
	amount = 5

GLOBAL_LIST_INIT(pizza_sheet_recipes, list(
	new/datum/stack_recipe("огромная пицца", /obj/structure/platform/pizza, 2, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
))

/*
 * Pizza
 */
/obj/item/stack/sheet/pizza
	name = "sheet pizza"
	desc = "It's a deliciously rectangular sheet of pizza!"
	singular_name = "sheet pizza"
	icon_state = "sheet-pizza"
	mats_per_unit = list(/datum/material/pizza = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/pizza
	material_type = /datum/material/pizza
	material_modifier = 1
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/pizza/get_main_recipes()
	. = ..()
	. += GLOB.pizza_sheet_recipes

/obj/item/stack/sheet/pizza/fifty
	amount = 50
/obj/item/stack/sheet/pizza/twenty
	amount = 20
/obj/item/stack/sheet/pizza/five
	amount = 5

/*
 * Hauntium
 */
GLOBAL_LIST_INIT(hauntium_recipes, list(
	new /datum/stack_recipe("hauntium tile", /obj/item/stack/tile/hauntium, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
))

/obj/item/stack/sheet/hauntium/get_main_recipes()
	. = ..()
	. += GLOB.hauntium_recipes

/obj/item/stack/sheet/hauntium
	name = "haunted sheets"
	desc = "These sheets seem cursed."
	singular_name = "haunted sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_NO_DESCRIPTORS
	mats_per_unit = list(/datum/material/hauntium = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/hauntium
	material_type = /datum/material/hauntium
	material_modifier = 1 //None of that wussy stuff

/obj/item/stack/sheet/hauntium/fifty
	amount = 50
/obj/item/stack/sheet/hauntium/twenty
	amount = 20
/obj/item/stack/sheet/hauntium/five
	amount = 5
