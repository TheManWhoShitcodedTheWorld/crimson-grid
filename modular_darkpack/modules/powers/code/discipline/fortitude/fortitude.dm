/datum/discipline/fortitude
	name = "Стойкость"
	desc = {"Делает ваше тело прочнее.
● Стойкость 1: пассивно
●● Стойкость 2: пассивно
●●● Стойкость 3: пассивно
●●●● Стойкость 4: пассивно
●●●●● Стойкость 5: пассивно"}
	icon_state = "fortitude"
	power_type = /datum/discipline_power/fortitude

/datum/discipline_power/fortitude
	name = "Fortitude power name"
	desc = "Fortitude power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/fortitude_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/fortitude_deactivate.ogg'

//FORTITUDE 1
/datum/discipline_power/fortitude/one
	name = "Стойкость 1"
	desc = "Мышцы каменеют. Вы крепче любого культуриста."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/one/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/one)

/datum/discipline_power/fortitude/one/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/one)

/datum/discipline_power/fortitude/one/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STAMINA, 1, "Fortitude")

//FORTITUDE 2
/datum/discipline_power/fortitude/two
	name = "Стойкость 2"
	desc = "Станьте подобны камню. Ничто не пробьёт вашу защиту."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/two/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/two)

/datum/discipline_power/fortitude/two/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/two)

/datum/discipline_power/fortitude/two/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STAMINA, 2, "Fortitude")

//FORTITUDE 3
/datum/discipline_power/fortitude/three
	name = "Стойкость 3"
	desc = "Смотрите свысока на тех, кто пытается вас убить. Тяжёлые удары вам нипочём."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/three/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/three)

/datum/discipline_power/fortitude/three/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/three)

/datum/discipline_power/fortitude/three/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STAMINA, 3, "Fortitude")

//FORTITUDE 4
/datum/discipline_power/fortitude/four
	name = "Стойкость 4"
	desc = "Станьте подобны стали. Войдите в огонь и выйдите лишь слегка опалённым."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/four/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/four)

/datum/discipline_power/fortitude/four/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/four)

/datum/discipline_power/fortitude/four/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STAMINA, 4, "Fortitude")

//FORTITUDE 5
/datum/discipline_power/fortitude/five
	name = "Стойкость 5"
	desc = "Достигните вершины несокрушимости. Вам больше нечего бояться."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four
	)

/datum/discipline_power/fortitude/five/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/five)

/datum/discipline_power/fortitude/five/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/five)

/datum/discipline_power/fortitude/five/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STAMINA, 5, "Fortitude")
