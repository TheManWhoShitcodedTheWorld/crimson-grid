/obj/ritual_rune/thaumaturgy/blood_trap
	name = "ward"
	ru_name = "Охранный знак"
	desc = "Создаёт Кровавую ловушку, что оберегает тремера и его домен."
	icon_state = "rune2"
	word = "DUH'K-A'U"

/obj/ritual_rune/thaumaturgy/blood_trap/complete()
	. = ..()
	if(!activated)
		activated = TRUE
		alpha = 28
		if(last_activator && last_activator.faction)	// CORVAX EDIT ADD
			activator_bonus = last_activator.thaum_damage_plus
			faction = last_activator.faction.Copy()
			faction -= FACTION_NEUTRAL
		AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_ENTERED = PROC_REF(on_crossed)))

/obj/ritual_rune/thaumaturgy/blood_trap/proc/on_crossed(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(isliving(arrived) && activated)
		var/mob/living/L = arrived
		if(length(L.faction & faction))
			return
		L.adjust_fire_loss(50 + activator_bonus)
		log_combat(last_activator, arrived, "'s ward rune was triggered by")
		playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
		qdel(src)

/obj/ritual_rune/thaumaturgy/blood_trap/Destroy()
	if(loc)
		UnregisterSignal(loc, COMSIG_ATOM_ENTERED)
	return ..()
