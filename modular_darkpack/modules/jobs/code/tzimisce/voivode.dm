/datum/job/vampire/voivode
	title = JOB_VOIVODE
	faction = FACTION_OLD_TZIMISCE // CORVAX EDIT : FACTION_SABBAT>FACTION_OLD_TZIMISCE
	total_positions = 1
	spawn_positions = 1
	supervisors = "законами гостеприимства"
	config_tag = "VOIVODE"
	outfit = /datum/outfit/job/vampire/voivode
	job_flags = CITY_JOB_FLAGS
	departments_list = list(
		/datum/job_department/manor,
	)
	display_order = JOB_DISPLAY_ORDER_VOIVODE

	exp_required_type_department = EXP_TYPE_MANOR
	exp_requirements = EXP_REQ_HEAD

	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TZIMISCE)

	description = "Вы дитя Воеводы-в-Ожидании, древнего старейшины Цимисхов, что покоится в земле дольше, чем стоит город, выросший на его костях. Чтите его каждым своим поступком и помните: вы ходите под его покровительством."
	minimum_masquerade = 2

	known_contacts = list(
		JOB_PRINCE,
		JOB_BARON,
		JOB_SHERIFF,
		JOB_BOGATYR,
		JOB_ZADRUGA
	)

/datum/outfit/job/vampire/voivode
	name = JOB_VOIVODE
	jobtype = /datum/job/vampire/voivode
	id = /obj/item/card/voivode
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/voivode
	suit = /obj/item/clothing/suit/vampire/trench/voivode
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	belt = /obj/item/storage/belt/sheath/vamp/sword
	l_pocket = /obj/item/smartphone/voivode
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/instrument/eguitar/vamp=1, /obj/item/card/credit/elder=1)
