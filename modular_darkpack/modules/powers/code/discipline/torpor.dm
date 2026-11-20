/datum/discipline/torpor
	name = "Торпор"
	desc = "Мы погружаемся в подобие смерти, чтобы сойти за мёртвых."
	icon_state = "quietus"
	power_type = /datum/discipline_power/torpor
	selectable = FALSE // so it doesn't show up in the admin UI as selectable

/datum/discipline_power/torpor
	name = "Торпор"
	desc = "Мы погружаемся в подобие смерти, чтобы сойти за мёртвых."
	vitae_cost = 1
	target_type = TARGET_SELF

	/// How long it takes for revival to ready upon entering torpor.
	/// The kindred can opt to stay in fakedeath for longer, though.
	var/fakedeath_duration = 5 MINUTES
	/// If TRUE, we're ready to revive and can click the button to heal.
	var/revive_ready = FALSE

/datum/discipline_power/torpor/activate(atom/target)
	..()
	if(revive_ready)
		INVOKE_ASYNC(src, PROC_REF(revive), owner)
		return TRUE

	if(!enable_fakedeath(owner))
		CRASH("Kindred revive failed to enter fakedeath when it should have been in a valid state to.")

	to_chat(owner, span_changeling("Мы погружаемся в торпор и копим силы, чтобы восстать вновь."))
	return TRUE

/// Used to enable fakedeath and register relevant signals / start timers
/datum/discipline_power/torpor/proc/enable_fakedeath(mob/living/kindred)
	if(revive_ready || HAS_TRAIT_FROM(kindred, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	kindred.fakedeath(CHANGELING_TRAIT)
	ADD_TRAIT(kindred, TRAIT_STASIS, CHANGELING_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(ready_to_regenerate), kindred), fakedeath_duration, TIMER_UNIQUE)
	// Basically, these let the ling exit torpor without giving away their ling-y-ness if revived through other means
	RegisterSignal(kindred, SIGNAL_REMOVETRAIT(TRAIT_DEATHCOMA), PROC_REF(fakedeath_reset))
	RegisterSignal(kindred, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	return TRUE

/// Removes the signals for fakedeath and listening for hapless doctors
/// healing a kindred who went into torpor after actually dying, and
/// also removes kindred torpor
/datum/discipline_power/torpor/proc/disable_torpor_and_fakedeath(mob/living/kindred)
	REMOVE_TRAIT(kindred, TRAIT_STASIS, CHANGELING_TRAIT)
	UnregisterSignal(kindred, SIGNAL_REMOVETRAIT(TRAIT_DEATHCOMA))
	UnregisterSignal(kindred, COMSIG_MOB_STATCHANGE)

/// Sets [revive_ready] to TRUE and updates the button icons.
/datum/discipline_power/torpor/proc/enable_revive(mob/living/kindred)
	if(revive_ready)
		return

	revive_ready = TRUE

/// Signal proc to stop the revival process if the kindred exits their torpor early.
/datum/discipline_power/torpor/proc/fakedeath_reset(mob/living/source)
	SIGNAL_HANDLER

	if(HAS_TRAIT_FROM(source, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	disable_torpor_and_fakedeath(source)

/// Signal proc to exit fakedeath early if we're revived from being previously dead
/datum/discipline_power/torpor/proc/on_stat_change(mob/living/source, new_stat, old_stat)
	SIGNAL_HANDLER

	if(old_stat != DEAD)
		return

	source.cure_fakedeath(CHANGELING_TRAIT)
	to_chat(source, span_changeling("Мы выходим из торпора раньше срока."))

/datum/discipline_power/torpor/proc/revive(mob/living/carbon/user)
	if(!istype(user))
		return
	if(!HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	user.cure_fakedeath(CHANGELING_TRAIT)
	// Heal all damage and some minor afflictions,
	var/flags_to_heal = (HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS)
	// but leave out limbs so we can do it specially
	user.revive(flags_to_heal & ~HEAL_LIMBS)
	to_chat(user, span_changeling("Мы вернули себя к жизни."))
	SEND_SIGNAL(user, COMSIG_MASQUERADE_VIOLATION, "возвращается к жизни") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(user, COMSIG_MASQUERADE_VIOLATION)

/datum/discipline_power/torpor/proc/ready_to_regenerate(mob/user)
	if(QDELETED(src) || QDELETED(user))
		return

	var/datum/antagonist/changeling/ling = IS_CHANGELING(user)
	if(QDELETED(ling) || !(src in (ling.innate_powers + ling.purchased_powers))) // checking both innate and purchased for full coverage
		return
	if(!HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	to_chat(user, span_changeling("Мы готовы восстать."))
	enable_revive(user)

/datum/discipline_power/torpor/can_activate(mob/living/user)
	if(revive_ready)
		return ..()

	if(!can_enter_torpor(user))
		return
	//Confirmation for living kindreds if they want to fake their death
	if(user.stat != DEAD)
		if(tgui_alert(user, "Мы точно хотим изобразить собственную смерть?", "Мнимая смерть", list("Да", "Нет")) != "Да")
			return
		if(QDELETED(user) || QDELETED(src) || !can_enter_torpor(user))
			return

	return ..()

/// We wait until after we actually deduct chemical cost (or don't deduct
/// if it's the 0 cost we get for revival) before we reset the chemical cost
/datum/discipline_power/torpor/can_activate(mob/living/user)
	. = ..()
	if (!. || !revive_ready)
		return

/datum/discipline_power/torpor/proc/can_enter_torpor(mob/living/user)
	if(HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		user.balloon_alert(user, "возрождение уже идёт!")
		return FALSE
	return TRUE
