/datum/antagonist/sabbatist
	name = "Шабашит"
	roundend_category = "Шабашиты"
	antagpanel_category = "Шабаш"
	pref_flag = ROLE_SABBAT
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_name = "pack"
	ui_name = null
	hud_icon = 'modular_darkpack/modules/jobs/icons/sabbat.dmi'

/datum/antagonist/sabbatist/apply_innate_effects(mob/living/mob_override)
	. = ..()
	add_team_hud(owner.current, /datum/antagonist/sabbatist)

/datum/antagonist/sabbatist/on_removal()
	to_chat(owner.current, span_userdanger("Вы больше не часть Шабаша!"))
	return ..()

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, span_alertsyndie("Теперь вы часть Шабаша."))
	//owner.announce_objectives()
