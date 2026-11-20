// V20 p.298 + W20 p.261

// Fleeing is used for either fox frenzies, or rotschreck
/mob/living/proc/enter_frenzy_mode(atom/target, fleeing = FALSE, source = "Unknown cause")
	if(HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	if(IS_UNCONSCIOUS(src))
		return

	set_jitter_if_lower(1 SCENES)

	message_admins("[ADMIN_LOOKUPFLW(src)] has entered frenzy[target ? " targeting [ADMIN_LOOKUPFLW(target)]": ""]. ([source])")
	log_combat(src, (src || target), "has frenzied on because of \"[source]\" on")

	if(fleeing)
		to_chat(src, span_danger("БЕГИ."))
		src.balloon_alert(src, "беги!")
		apply_status_effect(/datum/status_effect/frenzy/flee, target)
	else
		to_chat(src, span_bolddanger(get_kindred_splat(src) ? "БЕЗУМИЕ." : "БЕШЕНСТВО."))
		src.balloon_alert(src, get_kindred_splat(src) ? "безумие!" : "бешенство!")
		if(get_kindred_splat(src))
			apply_status_effect(/datum/status_effect/frenzy/vampire_hunger, target)
		else
			apply_status_effect(/datum/status_effect/frenzy, target)

	SEND_SOUND(src, sound('modular_darkpack/modules/frenzy/sounds/frenzy.ogg', volume = 50))

	// This is assuming no other interaction happens to remove it before this.
	addtimer(CALLBACK(src, PROC_REF(exit_frenzy_mode)), 1 SCENES)

/mob/living/proc/exit_frenzy_mode()
	if(!HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	log_message("exited frenzy.", LOG_ATTACK, color="red")

	remove_status_effect(/datum/status_effect/frenzy/vampire_hunger)
	remove_status_effect(/datum/status_effect/frenzy/flee)
	remove_status_effect(/datum/status_effect/frenzy)

/datum/storyteller_roll/frenzy
	abstract_type = /datum/storyteller_roll/frenzy
	bumper_text = "безумие"
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET
	numerical = TRUE

/datum/storyteller_roll/frenzy/rotschreck
	bumper_text = "Ротшрек"
	applicable_stats = list(STAT_COURAGE)

// CRIMSON EDIT ADD START - Calm Heart Rotschreck
/datum/storyteller_roll/frenzy/rotschreck/using_bonus(mob/living/roller, atom/target, bonus_added)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_CALM_HEART))
		. += 2
// CRIMSON EDIT ADD END - Calm Heart Rotschreck

/datum/storyteller_roll/frenzy/kindred

// Specificly kindred as I dont really think brujah are meant to rotschreck easier.
/datum/storyteller_roll/frenzy/kindred/using_difficulty(mob/living/roller, atom/target)
	. = ..()
	// V20 p.51
	if(HAS_TRAIT(roller, TRAIT_DIFFICULT_FRENZY))
		. += 2
	if(HAS_TRAIT(roller, TRAIT_UNCONTROLLABLE))
		. = 10

/datum/storyteller_roll/frenzy/kindred/using_bonus(mob/living/roller, atom/target, bonus_added)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_CALM_HEART))
		. += 2

/datum/storyteller_roll/frenzy/rage
	bumper_text = "бешенство"

/datum/storyteller_roll/frenzy/rage/using_difficulty(mob/living/roller, atom/target)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_DIFFICULT_RAGE))
		. += 1


/mob/living/proc/trigger_rotschreck(atom/fire, difficulty = 6, successes = 0)
	if(IS_UNCONSCIOUS(src))
		return
	if(!get_kindred_splat(src))
		return
	// CRIMSON GRID ADD: DARK THAUMATURGY 2
	if(HAS_TRAIT(src, ROTSCHRECK_IMMUNITY))
		return
	// CRIMSON GRID ADD END: DARK THAUMATURGY 2

	var/datum/storyteller_roll/frenzy/rotschreck/frenzy_roll = new()
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, fire)
	if(frenzy_result <= 0)
		if(!fire)
			fire = src
		enter_frenzy_mode(fire, TRUE, "Rotshreck")
		return
	successes += frenzy_result
	if(successes >= 5)
		return

	addtimer(CALLBACK(src, PROC_REF(trigger_rotschreck), fire, difficulty, successes), 1 TURNS)


/mob/living/proc/trigger_kindred_frenzy(atom/target, difficulty = 6, successes = 0, flavor_text = "Внезапный порыв")
	if(IS_UNCONSCIOUS(src))
		return
	if(!get_kindred_splat(src))
		return

	var/stat_to_roll = is_enlightenment() ? STAT_INSTINCT : STAT_SELF_CONTROL
	var/datum/storyteller_roll/frenzy/kindred/frenzy_roll = new()
	frenzy_roll.applicable_stats = list(stat_to_roll)
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, target)
	if(frenzy_result <= 0)
		to_chat(src, span_userdanger("[flavor_text] - и вас захлёстывает Безумие!"))
		var/victim = get_closest_atom(/atom, get_frenzy_victims(), src)
		if(!victim)
			victim = src
		enter_frenzy_mode(victim, source = "Kindred")
		return

	successes += frenzy_result
	if(successes >= 5)
		to_chat(src, span_green("[flavor_text] - Безумие уже подступает, но вы берёте себя в руки, и оно отступает!"))
		return

	addtimer(CALLBACK(src, PROC_REF(trigger_kindred_frenzy), target, difficulty, successes, flavor_text), 1 TURNS)


/mob/living/proc/trigger_rage_frenzy(atom/target, difficulty = 6, successes = 0)
	if(IS_UNCONSCIOUS(src))
		return
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(src)
	if(!shifter_splat)
		return

	var/datum/storyteller_roll/frenzy/rage/frenzy_roll = new()
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, target, shifter_splat.rage)
	if(frenzy_result >= 5)
		enter_frenzy_mode(target, TRUE, "Rage")
	return frenzy_result


GAME_VERB_PROC_DESC(/mob/living/carbon/human, manual_frenzy_roll, "Manual Frenzy Roll", "Сделать проверку на Безумие", null)
	VERB_ARG_TYPED(AM, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living)

	if(!istype(AM))
		return
	if(!issupernatural(src))
		return

	if(get_shifter_splat(src))
		trigger_rage_frenzy(AM)
	else if(get_vampire_splat(src))
		trigger_kindred_frenzy(AM)

// Used by the berserker merit. or possibly even for that one vampire thing of riding the frenzy in future?
GAME_VERB_PROC_DESC(/mob/living/carbon/human, manual_frenzy, "Manual Frenzy", "Впасть в Безумие по собственной воле", null)
	VERB_ARG_TYPED(AM, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living)

	if(!istype(AM))
		return
	if(!issupernatural(src))
		return

	enter_frenzy_mode(AM, source = "Manual")
