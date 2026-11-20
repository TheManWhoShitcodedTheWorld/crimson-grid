/obj/structure/retail/occult
	icon_state = "menu"
	owner_needed = FALSE
	desc = "Плоды ваших оккультных изысканий открывают доступ к бережно хранимым знаниям и артефактам."

	products_list = list(
	// SPELLBOOKS
	new /datum/data/vending_product("Гримуар Игры с Огнём (уровень I)",	/obj/item/path_spellbook/lure_of_flames/level1,	130),
	new /datum/data/vending_product("Гримуар Игры с Огнём (уровень II)",	/obj/item/path_spellbook/lure_of_flames/level2,	180),
	new /datum/data/vending_product("Гримуар Игры с Огнём (уровень III)",	/obj/item/path_spellbook/lure_of_flames/level3,	210),
	new /datum/data/vending_product("Гримуар Игры с Огнём (уровень IV)",	/obj/item/path_spellbook/lure_of_flames/level4,	240),
	new /datum/data/vending_product("Гримуар Игры с Огнём (уровень V)",	/obj/item/path_spellbook/lure_of_flames/level5,	270),

	new /datum/data/vending_product("Гримуар Пути Громовержца (уровень I)",	/obj/item/path_spellbook/levinbolt/level1,	130),
	new /datum/data/vending_product("Гримуар Пути Громовержца (уровень II)",	/obj/item/path_spellbook/levinbolt/level2,	180),
	new /datum/data/vending_product("Гримуар Пути Громовержца (уровень III)",	/obj/item/path_spellbook/levinbolt/level3,	210),
	new /datum/data/vending_product("Гримуар Пути Громовержца (уровень IV)",	/obj/item/path_spellbook/levinbolt/level4,	240),
	new /datum/data/vending_product("Гримуар Пути Громовержца (уровень V)",	/obj/item/path_spellbook/levinbolt/level5, 270),

	// CRIMSON GRID EDIT START - Movement of the Mind
	new /datum/data/vending_product("Movement of the Mind Spellbook (Level I)",	/obj/item/path_spellbook/movement_of_mind/level1,	130),
	new /datum/data/vending_product("Movement of the Mind Spellbook (Level II)",	/obj/item/path_spellbook/movement_of_mind/level2,	180),
	new /datum/data/vending_product("Movement of the Mind Spellbook (Level III)",	/obj/item/path_spellbook/movement_of_mind/level3,	210),
	new /datum/data/vending_product("Movement of the Mind Spellbook (Level IV)",	/obj/item/path_spellbook/movement_of_mind/level4,	240),
	new /datum/data/vending_product("Movement of the Mind Spellbook (Level V)",	/obj/item/path_spellbook/movement_of_mind/level5, 270),
	// CRIMSON GRID EDIT END
	// ARTIFACTS
	// Lower tier artifacts
	new /datum/data/vending_product("Викапогский чертополох", /obj/item/occult_artifact/vampire/weekapaug_thistle, 75),
	new /datum/data/vending_product("Безделушка из бинтов мумии", /obj/item/occult_artifact/vampire/mummywrap_fetish, 70),
	new /datum/data/vending_product("Галдьюм", /obj/item/occult_artifact/vampire/galdjum, 70),
	new /datum/data/vending_product("Кровавая звезда", /obj/item/occult_artifact/vampire/bloodstar, 70),

	// Mid tier artifacts
	new /datum/data/vending_product("Амулет фей", /obj/item/occult_artifact/vampire/fae_charm, 120),
	new /datum/data/vending_product("Даймонори", /obj/item/occult_artifact/vampire/daimonori, 120),
	new /datum/data/vending_product("Ключ Аламута", /obj/item/occult_artifact/vampire/key_of_alamut, 130),
	new /datum/data/vending_product("Сердце Элизы", /obj/item/occult_artifact/vampire/heart_of_eliza, 140),
	new /datum/data/vending_product("Кровавый камень", /obj/item/occult_artifact/vampire/bloodstone, 140),

	// High tier artifacts
	new /datum/data/vending_product("Гнусная чаша", /obj/item/occult_artifact/vampire/odious_chalice, 180),

)

/obj/structure/retail/occult/New()
	. = ..()
	//each item starts with 2 in stock
	for(var/datum/data/vending_product/prize in products_list)
		prize.amount = 2
		prize.max_amount = 10

// are they antitribu?
/obj/structure/retail/occult/proc/has_purchase_privileges(datum/job/job)
	return is_type_in_list(job, list(
		/datum/job/vampire/regent,
		/datum/job/vampire/archivist,
		/datum/job/vampire/hound,
		/datum/job/vampire/sheriff,
		/datum/job/vampire/clerk,
		/datum/job/vampire/prince)
	)

// find the regent
/obj/structure/retail/occult/proc/find_regent()
	for(var/mob/living/carbon/human/human_user in GLOB.human_list)
		if(istype(human_user.mind?.assigned_role, /datum/job/vampire/regent))
			return human_user
	return null

// find all archivists
/obj/structure/retail/occult/proc/find_archivists()
	var/list/archivists = list()
	for(var/mob/living/carbon/human/human_user in GLOB.human_list)
		if(istype(human_user.mind?.assigned_role, /datum/job/vampire/archivist))
			archivists += human_user
	return archivists

// Non-Chantry non-Camarilla Tremeres, when spending their research points, give 30% of their purchase to the Regent, or distributed among all archivists
/obj/structure/retail/occult/proc/distribute_research_points(amount, purchaser_name, item_name)
	var/tribute_amount = round(amount * 0.3)
	var/mob/living/carbon/human/regent = find_regent()

	if(regent)
		regent.research_points += tribute_amount
		to_chat(regent, span_notice("Архивы направляют вам долю очков исследований: [tribute_amount]. Покупатель: [purchaser_name], покупка: [item_name]."))
		return

	var/list/archivists = find_archivists()
	if(archivists.len > 0)
		var/points_per_archivist = round(tribute_amount / archivists.len)
		var/remaining_points = tribute_amount - (points_per_archivist * archivists.len)

		for(var/mob/living/carbon/human/archivist in archivists)
			var/points_to_give = points_per_archivist
			if(remaining_points > 0)
				points_to_give++
				remaining_points--
			archivist.research_points += points_to_give
			to_chat(archivist, span_notice("Архивы выделяют вам долю очков исследований: [points_to_give]. Покупатель: [purchaser_name], покупка: [item_name]."))

/obj/structure/retail/occult/proc/increment_stock(item_path)
	for(var/datum/data/vending_product/prize in products_list)
		if(prize.product_path == item_path)
			prize.amount = min(prize.amount + 1, prize.max_amount)
			return

// SpellbookVendor.jsx in tgui/interfaces
/obj/structure/retail/occult/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpellbookVendor", name)
		ui.open()

/obj/structure/retail/occult/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		.["user"]["points"] = human_user.research_points
		.["user"]["name"] = "[human_user.real_name]"
		.["user"]["job"] = "[human_user.mind?.assigned_role.title]"
		.["user"]["has_thaumaturgy"] = !!human_user.get_discipline(/datum/discipline/thaumaturgy)
		.["user"]["has_necromancy"] = !!human_user.get_discipline(/datum/discipline/necromancy)
		.["user"]["is_regent"] = istype(human_user.mind?.assigned_role, /datum/job/vampire/regent)
		.["user"]["has_privileges"] = has_purchase_privileges(human_user.mind?.assigned_role)
	else
		.["user"]["points"] = 0
		.["user"]["name"] = "Неизвестный"
		.["user"]["job"] = "Неизвестно"
		.["user"]["has_thaumaturgy"] = FALSE
		.["user"]["has_necromancy"] = FALSE
		.["user"]["is_regent"] = FALSE
		.["user"]["has_privileges"] = FALSE

	.["tremere_members"] = list()
	for(var/mob/living/carbon/human/tremere_member in GLOB.human_list)
		if(!tremere_member.mind)
			continue
		var/datum/job/role = tremere_member.mind.assigned_role
		if(is_type_in_list(role, list(/datum/job/vampire/archivist, /datum/job/vampire/gargoyle, /datum/job/vampire/regent)))
			.["tremere_members"] += list(list(
				"name" = tremere_member.real_name,
				"role" = job_title_ru(role.title), // CORVAX EDIT CHANGE - ORIGINAL: "role" = role.title,
				"points" = tremere_member.research_points,
				"ref" = "\ref[tremere_member]"
			))


	.["product_records"] = list()
	for(var/datum/data/vending_product/prize in products_list)
		var/stock_count = prize.amount
		var/obj/item/product_item = prize.product_path
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.product_path]", "/obj/item/", ""), "/", "-"),
			name = prize.name,
			price = prize.price,
			ref = REF(prize),
			stock = stock_count,
			available = (stock_count > 0),
			icon = initial(product_item.icon),
			icon_state = initial(product_item.icon_state)
		)
		.["product_records"] += list(product_data)

/obj/structure/retail/occult/ui_act(action, params)
	if(action == "transfer_points")
		return handle_point_transfer(action, params)
	if(action == "seize_points")
		return handle_point_seizure(action, params)
	if(action != "purchase")
		return ..()

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/human_user = usr

	if(!get_kindred_splat(usr))
		return

	var/datum/data/vending_product/prize = locate(params["ref"]) in products_list
	var/current_stock = prize.amount
	if(current_stock <= 0)
		to_chat(usr, span_alert("Нет в наличии: [prize.name]!"))
		return

	if(prize.price > human_user.research_points)
		to_chat(usr, span_alert("Не хватает очков исследований! Нужно: [prize.price]."))
		return

	human_user.research_points -= prize.price

	// Check if user is loyal to the chantry/camarilla - if not, award 30% tribute to leadership
	var/datum/job/user_role = human_user.mind?.assigned_role
	var/has_privileges = has_purchase_privileges(user_role)

	if(!has_privileges)
		distribute_research_points(prize.price, human_user.real_name, prize.name)
		to_chat(usr, span_notice("Часть ваших очков исследований уходит через Архивы главам капеллы в качестве дани."))

	prize.amount -= 1

	to_chat(usr, span_notice("Архивы источают тёмную энергию и выдают вам: [prize.name]!"))
	new prize.product_path(loc)
	return TRUE

//transfer research points
/obj/structure/retail/occult/proc/handle_point_transfer(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/sender = usr
	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(sender, span_alert("Ошибка: неверные параметры перевода!"))
		return FALSE

	if(amount > sender.research_points)
		to_chat(sender, span_alert("У вас недостаточно очков исследований!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)

	sender.research_points -= amount
	target.research_points += amount

	to_chat(sender, span_notice("По тёмным каналам Архивов вы передаёте очки исследований: [amount]. Получатель: [target.real_name]."))
	to_chat(target, span_notice("Архивы шепчут вам... [sender.real_name] передаёт вам очки исследований: [amount]."))

	return TRUE

//research point seizure
/obj/structure/retail/occult/proc/handle_point_seizure(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/regent = usr

	if(!istype(regent.mind?.assigned_role, /datum/job/vampire/regent))
		to_chat(regent, span_alert("Такой властью наделён только Регент!"))
		return FALSE

	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(regent, span_alert("Ошибка: неверные параметры изъятия!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)

	var/actual_amount = min(amount, target.research_points)

	if(actual_amount <= 0)
		to_chat(regent, span_alert("У цели нет очков исследований, изымать нечего!"))
		return FALSE

	target.research_points -= actual_amount
	regent.research_points += actual_amount

	to_chat(regent, span_notice("Властью Регента вы изымаете через Архивы очки исследований: [actual_amount]. Их прежний владелец: [target.real_name]."))
	to_chat(target, span_warning("От Архивов веет холодом... Регент [regent.real_name] по праву власти изымает у вас очки исследований: [actual_amount]."))

	return TRUE

//offer artifacts to the shop for research points AND increment stock
/obj/structure/retail/occult/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/occult_artifact))
		var/obj/item/occult_artifact/artifact = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		if(artifact.research_value <= 0)
			to_chat(user, span_warning("Архивы не видят в этом артефакте никакой ценности."))
			return ITEM_INTERACT_BLOCKING

		human_user.research_points += artifact.research_value

		increment_stock(artifact.type)

		//when donating an artifact, increase stock of a random spellbook
		increment_stock(pick(
			/obj/item/path_spellbook/lure_of_flames/level1,
			/obj/item/path_spellbook/lure_of_flames/level2,
			/obj/item/path_spellbook/lure_of_flames/level3,
			/obj/item/path_spellbook/lure_of_flames/level4,
			/obj/item/path_spellbook/lure_of_flames/level5,
			/obj/item/path_spellbook/levinbolt/level1,
			/obj/item/path_spellbook/levinbolt/level2,
			/obj/item/path_spellbook/levinbolt/level3,
			/obj/item/path_spellbook/levinbolt/level4,
			/obj/item/path_spellbook/levinbolt/level5))

		if(artifact.research_value >= 20)
			to_chat(user, span_nicegreen("Архивы жадно поглощают могущественный артефакт и пополняют им своё собрание. Вы получаете очки исследований: [artifact.research_value]!"))
		else if(artifact.research_value >= 10)
			to_chat(user, span_notice("Архивы вбирают сущность артефакта и вносят его знания в каталог. Вы получаете очки исследований: [artifact.research_value]."))
		else
			to_chat(user, span_notice("Архивы нехотя принимают малозначительный артефакт и убирают его в хранилище. Вы получаете очки исследований: [artifact.research_value]."))

		qdel(artifact)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/path_spellbook))
		var/obj/item/path_spellbook/spellbook = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		var/research_reward = 5 // base reward modified by spellbook
		human_user.research_points += research_reward

		increment_stock(spellbook.type)

		to_chat(user, span_notice("Архивы принимают ваш гримуар и пополняют его знаниями своё собрание. Вы получаете очки исследований: [research_reward]."))

		qdel(spellbook)
		return ITEM_INTERACT_SUCCESS

