/obj/structure/retail/gun_store
	desc = "Бах! Ба-бах!! БА-БА-БАХ!!!!"
	products_list = list(
		new /datum/data/vending_product("Револьвер \"Магнум\"", /obj/item/gun/ballistic/revolver/darkpack/magnum, 200),
		new /datum/data/vending_product("Colt M1911", /obj/item/gun/ballistic/automatic/pistol/darkpack/m1911, 250),
		new /datum/data/vending_product("Elite 92G", /obj/item/gun/ballistic/automatic/pistol/darkpack/beretta, 500),
		new /datum/data/vending_product("Desert Eagle", /obj/item/gun/ballistic/automatic/pistol/darkpack/deagle, 600),
		new /datum/data/vending_product("Винтовка рычажного действия", /obj/item/gun/ballistic/rifle/darkpack/lever, 1600),
		new /datum/data/vending_product("Охотничья винтовка", /obj/item/gun/ballistic/automatic/darkpack/huntrifle, 2000),
		new	/datum/data/vending_product("Патроны 5.45", /obj/item/ammo_box/darkpack/c545, 1000),
		new	/datum/data/vending_product("Патроны .45", /obj/item/ammo_box/darkpack/c45acp, 700),
		new /datum/data/vending_product("Патроны 9 мм", /obj/item/ammo_box/darkpack/c9mm, 600),
		new /datum/data/vending_product("Патроны .44", /obj/item/ammo_box/darkpack/c44, 800),
		new /datum/data/vending_product("Патроны 5.56", /obj/item/ammo_box/darkpack/c556, 2000),
		new /datum/data/vending_product("Патроны 7.62x51", /obj/item/ammo_box/darkpack/c762x51mm, 1500), // Crimson Grid Additon
		new /datum/data/vending_product("Дробовик", /obj/item/gun/ballistic/shotgun/vampire, 900),
		new /datum/data/vending_product("Двустволка", /obj/item/gun/ballistic/shotgun/vampire/doublebarrel, 1100),
		new /datum/data/vending_product("Патроны 12-го калибра, картечь", /obj/item/ammo_box/darkpack/c12g/buck, 400),
		new /datum/data/vending_product("Магазин для Desert Eagle", /obj/item/ammo_box/magazine/m44, 100),
		new /datum/data/vending_product("Магазин для охотничьей винтовки, 7.62x51", /obj/item/ammo_box/magazine/darkpack556/hunt, 200), // Crimson Grid Edit - Was 5.56
		new /datum/data/vending_product("Пистолетный магазин 9 мм, 18 патронов", /obj/item/ammo_box/magazine/semi9mm, 100),
		new /datum/data/vending_product("Магазин для Colt M1911", /obj/item/ammo_box/magazine/darkpack45acp, 50),
		new /datum/data/vending_product("Нож", /obj/item/knife/vamp, 100),
		new /datum/data/vending_product("Бейсбольная бита", /obj/item/melee/baseball_bat/vamp, 200),
		new /datum/data/vending_product("Настоящая катана", /obj/item/katana/vamp, 1500),
		new /datum/data/vending_product("Мачете", /obj/item/claymore/machete, 500),
		new /datum/data/vending_product("Электрошокер", /obj/item/melee/baton/security/handtaser, 250),
		new /datum/data/vending_product("Перцовый баллончик", /obj/item/reagent_containers/spray/pepper, 200),
		new /datum/data/vending_product("Кобура", /obj/item/storage/belt/holster/detective/darkpack, 100), // CRIMSON EDIT ADD - Shop Inventories Additions
		new /datum/data/vending_product("Кобура для пистолета", /obj/item/storage/belt/holster, 100),
		new /datum/data/vending_product("Разгрузочный пояс охраны", /obj/item/storage/belt/security/webbing, 100),
		// CRIMSON GRID ADDITION BEGIN - Armory Ammunition Additions
		new /datum/data/vending_product("Патроны 9 мм +P", /obj/item/ammo_box/darkpack/c9mm/plus, 800),
		new /datum/data/vending_product("Патроны 9 мм бронебойные", /obj/item/ammo_box/darkpack/c9mm/ap, 1000),
		new /datum/data/vending_product("Патроны 9 мм экспансивные", /obj/item/ammo_box/darkpack/c9mm/hp, 800),
		new /datum/data/vending_product("Патроны .45 ACP +P", /obj/item/ammo_box/darkpack/c45acp/plus, 900),
		new /datum/data/vending_product("Патроны .45 ACP бронебойные", /obj/item/ammo_box/darkpack/c45acp/ap, 1000),
		new /datum/data/vending_product("Патроны .45 ACP экспансивные", /obj/item/ammo_box/darkpack/c45acp/hp, 900),
		new /datum/data/vending_product("Патроны 5.56 экспансивные", /obj/item/ammo_box/darkpack/c556/hp, 2000),
		new /datum/data/vending_product("Патроны 5.56 бронебойные", /obj/item/ammo_box/darkpack/c556/ap, 2500),
		new /datum/data/vending_product("Патроны 5.45 экспансивные", /obj/item/ammo_box/darkpack/c545/hp, 2000),
		new /datum/data/vending_product("Патроны 5.45 бронебойные", /obj/item/ammo_box/darkpack/c545/ap, 2500),
		new /datum/data/vending_product("Патроны .44 Magnum экспансивные", /obj/item/ammo_box/darkpack/c44/hp, 1000),
		new /datum/data/vending_product("Патроны 7.62x51 экспансивные", /obj/item/ammo_box/darkpack/c762x51mm/hp, 2000),
		new /datum/data/vending_product("Патроны 7.62x51 бронебойные", /obj/item/ammo_box/darkpack/c762x51mm/ap, 2500),
		new /datum/data/vending_product("Пули 12-го калибра экспансивные", /obj/item/ammo_box/darkpack/c12g/hp, 800),
		new /datum/data/vending_product("Пули 12-го калибра бронебойные", /obj/item/ammo_box/darkpack/c12g/ap, 800),
		new /datum/data/vending_product("Пули 12-го калибра", /obj/item/ammo_box/darkpack/c12g, 400)
		// CRIMSON GRID ADDITION END - Armory Ammunition Additions
	)
