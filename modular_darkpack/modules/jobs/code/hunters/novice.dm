/datum/job/vampire/novice
	title = JOB_NOVICE
	description = "Вы послушник, проходящий новициат в Обществе святого Леопольда, детище Инквизиции, или терциарий, только что его окончивший. Кем бы вы ни были прежде, мирянином или воспитанником семинарии, теперь ваше главное дело в Обществе - учиться, вести разведку, записывать увиденное и постигать природу сверхъестественных тварей, что угрожают Царству Божию и его порядку. И быть наготове к тому часу, когда назовут ваше имя."
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7

	config_tag = "NOVICE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/novice

	display_order = JOB_DISPLAY_ORDER_NOVICE
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)

	tgui_icon = FA_ICON_CROSS

	known_contacts = list(
		JOB_ABBE,
		JOB_CONDOTTIERI,
		JOB_INQUISITOR,
		JOB_NOVICE
	)

	splat_slots = list(SPLAT_GHOUL = 1, SPLAT_KINFOLK = 1, SPLAT_NONE = 3)	// CORVAX EDIT
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINFOLK) // infiltrators and betrayal arcs	// CORVAX EDIT


/datum/outfit/job/vampire/novice
	name = JOB_NOVICE
	jobtype = /datum/job/vampire/novice

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/labcoat
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/novice
	backpack_contents = list(/obj/item/camera=1, /obj/item/vampirebook/bible=1, /obj/item/card/credit=1)


/datum/outfit/job/vampire/novice/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.set_holy_role(HOLY_ROLE_DEACON)

/datum/outfit/job/vampire/novice/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/latin, source = "job")
