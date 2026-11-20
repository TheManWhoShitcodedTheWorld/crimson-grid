/datum/discipline/celerity
	name = "Стремительность"
	desc = {"Делает вас быстрее. Нарушает Маскарад.
● Стремительность 1: пассивно
●● Стремительность 2: пассивно
●●● Стремительность 3: пассивно
●●●● Стремительность 4: пассивно
●●●●● Стремительность 5: пассивно"}
	icon_state = "celerity"
	power_type = /datum/discipline_power/celerity

/datum/discipline_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/celerity_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/celerity_deactivate.ogg'

/datum/discipline_power/celerity/proc/temporis_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/temporis/patience_of_the_norns) && !istype(power, /datum/discipline_power/temporis/clothos_gift))
		return

	to_chat(owner, span_userdanger("Вы пытаетесь применить Темпорис, но действующая Стремительность разгоняет ваше временное поле, и оно выходит из-под контроля!"))
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

//CELERITY 1
/datum/discipline_power/celerity/one
	name = "Стремительность 1"
	desc = "Вы становитесь быстрее, и всё даётся чуть легче."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/one/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/one)

/datum/discipline_power/celerity/one/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/one)

/datum/discipline_power/celerity/one/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_DEXTERITY, 1, "Celerity")

//CELERITY 2
/datum/discipline_power/celerity/two
	name = "Стремительность 2"
	desc = "Заметно прибавляет вам скорости и ускоряет реакцию."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/two/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/two)

/datum/discipline_power/celerity/two/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/two)

/datum/discipline_power/celerity/two/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_DEXTERITY, 2, "Celerity")

//CELERITY 3
/datum/discipline_power/celerity/three
	name = "Стремительность 3"
	desc = "Двигайтесь быстрее. Реагируйте мгновенно. Тело слушается вас безупречно."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/three/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/three)

/datum/discipline_power/celerity/three/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/three)

/datum/discipline_power/celerity/three/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_DEXTERITY, 3, "Celerity")

//CELERITY 4
/datum/discipline_power/celerity/four
	name = "Стремительность 4"
	desc = "Перешагните предел человеческих возможностей. Двигайтесь как молния."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/four/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/four)

/datum/discipline_power/celerity/four/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/four)

/datum/discipline_power/celerity/four/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_DEXTERITY, 4, "Celerity")

//CELERITY 5
/datum/discipline_power/celerity/five
	name = "Стремительность 5"
	desc = "Вы подобны свету. Проноситесь сквозь мир ослепительной вспышкой."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four
	)

/datum/discipline_power/celerity/five/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/five)

/datum/discipline_power/celerity/five/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/five)

/datum/discipline_power/celerity/five/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_DEXTERITY, 5, "Celerity")
