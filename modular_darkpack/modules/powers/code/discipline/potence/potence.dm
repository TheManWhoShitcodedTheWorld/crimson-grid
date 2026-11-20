/datum/discipline/potence
	name = "Мощь"
	desc = {"Усиливает удары - и голыми руками, и оружием ближнего боя.
● Мощь 1: пассивно
●● Мощь 2: пассивно
●●● Мощь 3: пассивно
●●●● Мощь 4: пассивно
●●●●● Мощь 5: пассивно"}
	icon_state = "potence"
	power_type = /datum/discipline_power/potence

/datum/discipline_power/potence
	name = "Potence power name"
	desc = "Potence power description"
	abstract_type = /datum/discipline_power/potence

	activate_sound = 'modular_darkpack/modules/powers/sounds/potence_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/potence_deactivate.ogg'

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 1 TURNS

/datum/discipline_power/potence/post_gain(post_gain_applied)
	if(!post_gain_applied)
		owner.st_add_stat_mod(STAT_STRENGTH, level, "Potence")

/datum/discipline_power/potence/post_loss()
	owner.st_remove_stat_mod(STAT_STRENGTH, "Potence")

/datum/discipline_power/potence/activate()
	. = ..()

	if(level <= 5)
		var/max_level = min(discipline.level, 5)
		owner.apply_status_effect(/datum/status_effect/potence, max_level)

/datum/discipline_power/potence/deactivate()
	. = ..()
	if(level <= 5)
		owner.remove_status_effect(/datum/status_effect/potence)


//POTENCE 1
/datum/discipline_power/potence/one
	name = "Мощь 1"
	desc = "Мышцы наливаются силой. Бить вполсилы вы больше не умеете."

	level = 1

	grouped_powers = list(
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)


//POTENCE 2
/datum/discipline_power/potence/two
	name = "Мощь 2"
	desc = "Такую силу одними мышцами уже не объяснить. Крушите людей и вещи."

	level = 2

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)


//POTENCE 3
/datum/discipline_power/potence/three
	name = "Мощь 3"
	desc = "Вы - воплощённое разрушение. Поднимайте неподъёмное, ломайте несокрушимое."

	level = 3

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)


//POTENCE 4
/datum/discipline_power/potence/four
	name = "Мощь 4"
	desc = "Вы - неумолимая машина, пока хватает витэ."

	level = 4

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/five
	)


//POTENCE 5
/datum/discipline_power/potence/five
	name = "Мощь 5"
	desc = "Покажи вы такое людям - вам стали бы поклоняться как божеству."

	level = 5

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four
	)
