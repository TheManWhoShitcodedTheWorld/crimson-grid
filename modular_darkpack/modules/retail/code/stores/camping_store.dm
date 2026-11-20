/obj/structure/retail/camping
	desc = "Всё для похода. Зефир для костра ищите в другом месте."
	products_list = list(
		new /datum/data/vending_product("Фотоплёнка", /obj/item/camera_film),
		new /datum/data/vending_product("Охотничий нож", /obj/item/knife/vamp),
		new /datum/data/vending_product("Колышек для палатки", /obj/item/vampire_stake),
		new /datum/data/vending_product("Лопата", /obj/item/shovel/vamp),
		new /datum/data/vending_product("Магазин для охотничьей винтовки, 7.62x51",/obj/item/ammo_box/magazine/darkpack556/hunt), // Crimson Grid Edit - Magazine was originally 5.56
		new /datum/data/vending_product("Фонарик", /obj/item/flashlight), // CRIMSON EDIT ADD - Shop Inventories Additions
		new /datum/data/vending_product("Уголь", /obj/item/stack/sheet/mineral/coal, 10), // CRIMSON EDIT ADD - Shop Inventories Additions
		new /datum/data/vending_product("Перцовый баллончик", /obj/item/reagent_containers/spray/pepper),
		new /datum/data/vending_product("Ручной электрошокер SNEKTEK", /obj/item/melee/baton/security/handtaser),
		new /datum/data/vending_product("Магазин для Beretta", /obj/item/ammo_box/magazine/semi9mm),
		new /datum/data/vending_product("Бинокль", /obj/item/binoculars),
		new /datum/data/vending_product("Фотоаппарат", /obj/item/camera),
		new /datum/data/vending_product("Коробка патронов 9 мм", /obj/item/ammo_box/darkpack/c9mm),
		new /datum/data/vending_product("Патроны 12-го калибра, картечь",/obj/item/ammo_box/darkpack/c12g/buck),
		new /datum/data/vending_product("Мачете", /obj/item/claymore/machete),
		new /datum/data/vending_product("Охотничье ружьё", /obj/item/gun/ballistic/shotgun/vampire),
		new	/datum/data/vending_product("Elite 92G", /obj/item/gun/ballistic/automatic/pistol/darkpack/beretta),
		new /datum/data/vending_product("Пожарный топор", /obj/item/fireaxe/vamp),
		new /datum/data/vending_product("Бензопила", /obj/item/chainsaw/vamp),
		new /datum/data/vending_product("Охотничья винтовка", /obj/item/gun/ballistic/automatic/darkpack/huntrifle),
		new /datum/data/vending_product("Патроны 7.62x51", /obj/item/ammo_box/darkpack/c762x51mm, 1000), // Crimson Grid Replacement - Was 5.56 Ammo Box
		new /datum/data/vending_product("Армейская парка", /obj/item/clothing/suit/vampire/coat/milparka,	90),
		// CRIMSON GRID ADDITION BEGIN - Armory Ammunition Additions
		new /datum/data/vending_product("Арбалет", /obj/item/gun/ballistic/shotgun/toy/crossbow/vampire, 1000),
		new /datum/data/vending_product("Болты с бодкин-наконечником", /obj/item/ammo_box/darkpack/arrows/bodkin, 800),
		new /datum/data/vending_product("Болты с широким наконечником", /obj/item/ammo_box/darkpack/arrows/broadhead, 800),
		// CRIMSON GRID ADDITION END - Armory Ammunition Additions
		new /datum/data/vending_product("ice hiking boots", /obj/item/clothing/shoes/winterboots/ice_boots, 100),
	)
	product_types = list(
		/obj/item/fishing_rod,
		/obj/item/fishing_rod/telescopic,
		/obj/item/bait_can/worm,
		/obj/item/bait_can/super_baits,
		/obj/item/storage/toolbox/fishing,
		/obj/item/storage/box/fishing_lures,
		/obj/item/storage/box/fishing_hooks,
		/obj/item/storage/box/fishing_lines,
		/obj/item/storage/bag/fishing,
		/obj/item/fishing_line/auto_reel
	)
