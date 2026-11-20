// Lets mundane players act as Masquerade witnesses, the same way NPCs do.
// A violation in sight throws a clickable alert; the examine link reports directly.
// Countdown processing changes only maptext; the base alert still updates the breacher's appearance.

#define MASQUERADE_WITNESS_ALERT(breacher) "masquerade_witness_[REF(breacher)]"
/// Shown when a violation is sent without a reason.
#define MASQUERADE_DEFAULT_VIOLATION_REASON "делает что-то сверхъестественное"

/// Returns TRUE if `witness` currently holds a breach against `breacher`, or against anyone when `breacher` is null.
/proc/masquerade_breach_exists(atom/witness, mob/living/breacher)
	for(var/list/breach_record as anything in SSmasquerade.masquerade_breachers)
		var/recorded_witnesses = breach_record[MASQUERADE_BREACH_WITNESSES]
		// Player reports require this exact witness, not membership in a skull list.
		if(recorded_witnesses != witness)
			continue

		// An omitted breacher asks whether this witness holds any active breach.
		if(isnull(breacher))
			return TRUE

		var/mob/living/recorded_breacher = breach_record[MASQUERADE_BREACH_BREACHER]
		if(recorded_breacher == breacher)
			return TRUE
	return FALSE

/atom/movable/screen/alert/masquerade_witness
	name = "Нарушение Маскарада"
	timeout = 10 SECONDS
	clickable_glow = TRUE
	click_master = FALSE
	maptext_x = 4
	maptext_y = 19
	var/datum/weakref/breacher_ref
	/// What the witness saw the breacher do, in the order it was first seen.
	var/list/violation_reasons = list()
	/// Set while the confirmation prompt is open, so repeated clicks don't stack prompts.
	var/confirming = FALSE

/atom/movable/screen/alert/masquerade_witness/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/masquerade_witness/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/masquerade_witness/process(seconds_per_tick)
	var/time_left = timeout - world.time
	if(time_left <= 0)
		maptext = ""
		return PROCESS_KILL
	// Only the countdown changes here; the parent's appearance signal updates the portrait.
	maptext = MAPTEXT("<span style='color: [(time_left <= 3 SECONDS) ? "red" : "white"]'><b>[ceil(time_left / (1 SECONDS))]</b></span>")

/atom/movable/screen/alert/masquerade_witness/proc/add_violation_reason(reason)
	violation_reasons |= reason
	desc = "Вы видели, как этот человек [jointext(violation_reasons, ", ")]. Нажмите, чтобы сообщить о нарушении Маскарада."

/atom/movable/screen/alert/masquerade_witness/Click(location, control, params)
	. = ..()
	if(!. || confirming)
		return
	var/mob/living/carbon/human/witness = owner
	var/mob/living/breacher = breacher_ref?.resolve()
	if(!istype(witness) || !breacher)
		return
	var/reason = jointext(violation_reasons, ", ")
	confirming = TRUE
	// The prompt closes by itself when the alert would expire.
	var/choice = tgui_alert(witness, "Вы видели, как [breacher.declent_ru(NOMINATIVE)] [reason].\nСообщить о нарушении Маскарада?", "Нарушение Маскарада", list("Сообщить", "Отмена"), timeout = max(timeout - world.time, 1))
	if(QDELETED(src) || witness.alerts[MASQUERADE_WITNESS_ALERT(breacher)] != src)
		if(choice == "Сообщить")
			to_chat(witness, span_warning("Слишком поздно: вы уже не уверены в том, что видели."))
		return
	confirming = FALSE
	if(choice != "Сообщить")
		return
	witness.report_masquerade_violation(breacher, reason, check_sight = FALSE)
	witness.clear_alert(MASQUERADE_WITNESS_ALERT(breacher))

/// Called for every human that sees `breacher` violate the Masquerade. Throws or refreshes the report alert for player witnesses.
/mob/living/carbon/human/proc/notice_masquerade_violation(mob/living/breacher, reason)
	if(breacher == src || !client || isnpc(src) || violation_observer || !ismundane(src))
		return
	if(IS_UNCONSCIOUS_OR_CRIT(src) || is_blind())
		return
	if(masquerade_breach_exists(src, breacher))
		return
	var/atom/movable/screen/alert/masquerade_witness/alert = throw_alert(MASQUERADE_WITNESS_ALERT(breacher), /atom/movable/screen/alert/masquerade_witness, new_master = breacher)
	if(!alert)
		return
	alert.breacher_ref = WEAKREF(breacher)
	alert.add_violation_reason(reason || MASQUERADE_DEFAULT_VIOLATION_REASON)

/mob/living/carbon/human
	/// Weakrefs to people src reported without that creating a breach (mundane targets, breachers at 0 Masquerade).
	/// Treated like real breaches when blocking repeat reports, so repeat reports can't tell the two apart.
	var/list/masquerade_reports_without_breach

/// Returns TRUE if src already holds a report against `breacher`, real or not.
/mob/living/carbon/human/proc/has_reported_masquerade_violation(mob/living/breacher)
	if(masquerade_breach_exists(src, breacher))
		return TRUE
	var/datum/weakref/breacher_ref = WEAKREF(breacher)
	if(!(breacher_ref in masquerade_reports_without_breach))
		return FALSE
	// Real breaches are cleared when the breacher dies, so fake ones are too.
	if(breacher.stat == DEAD)
		LAZYREMOVE(masquerade_reports_without_breach, breacher_ref)
		return FALSE
	return TRUE

/// Returns a report-blocking message, or null when reporting is allowed. Mundane targets are not rejected here.
/mob/living/carbon/human/proc/masquerade_report_blocker(mob/living/breacher, check_sight)
	if(!ismundane(src) || isnpc(src))
		return "Вы не можете сообщить о нарушении Маскарада."
	if(IS_UNCONSCIOUS_OR_CRIT(src))
		return "Вы не в том состоянии."
	if(QDELETED(breacher) || breacher == src)
		return "Не о ком сообщать."
	if(check_sight)
		if(!(src in viewers(7, breacher)))
			return "Вы не видите [breacher.declent_ru(ACCUSATIVE)]."
		if(!check_zone_masquerade(breacher))
			return "Здесь Маскарад не действует."
	if(has_reported_masquerade_violation(breacher))
		return "Вы уже сообщили о нарушении [breacher.declent_ru(GENITIVE)]."
	return null

/**
 * Reports `breacher` for a Masquerade violation witnessed by src.
 *
 * * reason - What the witness saw. Shown to the witness, the breacher and admins.
 * * check_sight - Require the breacher to be in view inside a Masquerade zone. Off for witness alerts, which were already checked when thrown.
 */
/mob/living/carbon/human/proc/report_masquerade_violation(mob/living/breacher, reason, check_sight = TRUE)
	var/report_source = check_sight ? "examine link" : "witness alert"
	var/report_block_reason = masquerade_report_blocker(breacher, check_sight)
	if(report_block_reason)
		to_chat(src, span_warning(report_block_reason))
		log_game("[key_name(src)] failed to report [key_name(breacher)]'s Masquerade violation via [report_source]: [report_block_reason]")
		return FALSE

	to_chat(src, span_notice("Вы сообщаете о нарушении Маскарада[reason ? ". Причина: [reason]" : ""]."))
	// Mirror the witness animation for mundane targets without creating a breach.
	if(ismundane(breacher))
		play_masquerade_witness_reaction(breacher)
		log_game("[key_name(src)] reported mundane [key_name(breacher)] for a Masquerade violation via [report_source]. Description: [reason || "none"]")
	else if(on_observed_violation(src, breacher))
		message_admins("[ADMIN_LOOKUPFLW(src)] spotted [ADMIN_LOOKUPFLW(breacher)]'s Masquerade violation via [report_source]. Description: [reason || "none"]")
		log_game("[key_name(src)] spotted [key_name(breacher)]'s Masquerade violation via [report_source]. Description: [reason || "none"]")
		to_chat(breacher, span_danger("Вас уличили в нарушении Маскарада[reason ? ". Причина: [reason]" : ""]!"))
	// Remember reports that created no breach, so a repeat report is blocked exactly like a real one.
	if(!masquerade_breach_exists(src, breacher))
		LAZYOR(masquerade_reports_without_breach, WEAKREF(breacher))
	SSmasquerade.track_player_witness(src)
	return TRUE

/// Mirrors the visuals of /atom/movable/proc/on_observed_violation without breaching anything.
/mob/living/carbon/human/proc/play_masquerade_witness_reaction(atom/movable/target)
	if(!INCAPACITATED_IGNORING(src, INCAPABLE_RESTRAINTS))
		face_atom(target)
	do_alert_animation()
	var/mutable_appearance/alert = mutable_appearance('icons/obj/storage/closet.dmi', "cardboard_special")
	SET_PLANE_EXPLICIT(alert, ABOVE_LIGHTING_PLANE, src)
	var/atom/movable/flick_visual/exclamation = flick_overlay_view(alert, 1 SECONDS)
	exclamation.alpha = 0
	exclamation.pixel_x = -pixel_x
	animate(exclamation, pixel_z = 32, alpha = 255, time = 0.5 SECONDS, easing = ELASTIC_EASING)

// Player witnesses aren't violation observers (that would auto-breach everything they see), so their breach cleanup is tracked here.
// Registered from the subsystem so it never collides with the witness's own observer signals (bodycams).
/datum/controller/subsystem/masquerade/proc/track_player_witness(mob/living/witness)
	RegisterSignal(witness, COMSIG_MASQUERADE_REINFORCE, PROC_REF(on_player_witness_reinforce), override = TRUE)
	RegisterSignals(witness, list(COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE, COMSIG_QDELETING), PROC_REF(on_player_witness_gone), override = TRUE)

/datum/controller/subsystem/masquerade/proc/untrack_player_witness(mob/living/witness)
	UnregisterSignal(witness, list(COMSIG_MASQUERADE_REINFORCE, COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE, COMSIG_QDELETING))

/datum/controller/subsystem/masquerade/proc/on_player_witness_reinforce(mob/living/carbon/human/witness, mob/living/player_breacher)
	SIGNAL_HANDLER

	. = witness.on_masquerade_violation_reinforced(witness, player_breacher)
	LAZYREMOVE(witness.masquerade_reports_without_breach, WEAKREF(player_breacher))
	if(!masquerade_breach_exists(witness) && !LAZYLEN(witness.masquerade_reports_without_breach))
		untrack_player_witness(witness)

/datum/controller/subsystem/masquerade/proc/on_player_witness_gone(mob/living/carbon/human/witness)
	SIGNAL_HANDLER

	witness.on_masquerade_witness_death()
	witness.masquerade_reports_without_breach = null
	untrack_player_witness(witness)

#undef MASQUERADE_WITNESS_ALERT
#undef MASQUERADE_DEFAULT_VIOLATION_REASON
