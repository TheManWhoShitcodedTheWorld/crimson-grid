/datum/job/vampire/doctor
	title = JOB_DOCTOR
	faction = FACTION_CITY
	total_positions = 8 // CRIMSON EDIT CHANGE - Original: total_positions = 4
	spawn_positions = 8 // CRIMSON EDIT CHANGE - Original: spawn_positions = 4
	supervisors = "директором клиники"
	config_tag = "DOCTOR"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/clinic_doctor
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_DOCTOR
	departments_list = list(
		/datum/job_department/clinic,
	)

	tgui_icon = FA_ICON_STAFF_SNAKE

	known_contacts = list(
		JOB_CLINIC_DIRECTOR,
		JOB_DOCTOR,
		JOB_PRIMOGEN_MALKAVIAN
	)

	description = "Помогайте Сородичам во всём, что касается медицины. Продавайте кровь. Следите, чтобы коллеги-люди ни о чём не догадывались."
	maximal_generation = 9
	maximum_immortal_age = 200
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	allowed_clans = list(VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_CAITIFF)
	known_contacts = list("Clinic Director")

	alt_titles = list(
		"Doctor",
		"Medical Student",
		"Intern",
		"Nurse",
		"Resident",
		"General Practitioner",
		"Surgeon",
		"Physician",
		"Paramedic",
		"EMT",
	)


/datum/outfit/job/vampire/clinic_doctor
	name = JOB_DOCTOR
	jobtype = /datum/job/vampire/doctor

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clinic
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone/doctor
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/storage/medkit/darkpack/doctor=1)

	skillchips = list(/obj/item/skillchip/entrails_reader)
