#define HOURGLASS_SENSE_RANGE 50

// V20 Hourglass of the Mind: reflexive Perception + Awareness, normally difficulty 6.
// Server adaptation: 50 tiles on the same Z, no line-of-sight check, direction on success.
// Only successful activations emit a disturbance; movement and upkeep do not reroll it.
/datum/discipline_power/celerity/activate()
	. = ..()
	if(.)
		notify_time_sense()

/// Called by Celerity and higher Temporis powers after their base activation succeeds.
/datum/discipline_power/proc/notify_time_sense()
	var/turf/source_turf = get_turf(owner)
	if(!source_turf)
		return

	for(var/mob/living/observer in GLOB.player_list)
		if(QDELETED(observer) || observer == owner)
			continue
		if(IS_UNCONSCIOUS(observer))
			continue
		var/turf/observer_turf = get_turf(observer)
		if(!observer_turf || observer_turf.z != source_turf.z)
			continue
		if(get_dist(observer_turf, source_turf) > HOURGLASS_SENSE_RANGE)
			continue

		var/datum/discipline/temporis/observer_temporis = observer.get_discipline(/datum/discipline/temporis)
		var/datum/discipline_power/temporis/hourglass_of_the_mind/hourglass = observer_temporis?.get_power(/datum/discipline_power/temporis/hourglass_of_the_mind)
		if(QDELETED(hourglass))
			continue
		hourglass.sense_time_disturbance(observer_turf, source_turf)

/datum/storyteller_roll/hourglass_disturbance
	bumper_text = "ощущение временного искажения"
	applicable_stats = list(STAT_PERCEPTION, STAT_AWARENESS)
	difficulty = 6
	numerical = TRUE
	// Even a failed roll must not reveal that an unseen disturbance occurred.
	roll_output_type = NONE

/datum/discipline_power/temporis/hourglass_of_the_mind
	var/datum/storyteller_roll/hourglass_disturbance/disturbance_roll

/datum/discipline_power/temporis/hourglass_of_the_mind/Destroy(force)
	QDEL_NULL(disturbance_roll)
	return ..()

/datum/discipline_power/temporis/hourglass_of_the_mind/pre_activation_checks()
	if(!..())
		return FALSE
	to_chat(owner, span_notice("Точное время: <b>[server_timestamp("hh:mm:ss", ic_time = TRUE, twelve_hour_clock = owner.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))]</b>."))
	// Reading the clock is not a spell: skip activation, magic effects, sounds and timers.
	return FALSE

/datum/discipline_power/temporis/hourglass_of_the_mind/proc/sense_time_disturbance(turf/observer_turf, turf/source_turf)
	if(!disturbance_roll)
		disturbance_roll = new()
	if(disturbance_roll.st_roll(owner) <= 0)
		return

	var/direction_text = disturbance_direction_text(get_dir(observer_turf, source_turf))
	to_chat(owner, span_userdanger("<i>Вы ощущаете сверхъестественное нарушение течения времени [direction_text].</i>"))

/datum/discipline_power/temporis/hourglass_of_the_mind/proc/disturbance_direction_text(direction)
	switch(direction)
		if(NORTH)
			return "к северу от вас"
		if(SOUTH)
			return "к югу от вас"
		if(EAST)
			return "к востоку от вас"
		if(WEST)
			return "к западу от вас"
		if(NORTHEAST)
			return "к северо-востоку от вас"
		if(NORTHWEST)
			return "к северо-западу от вас"
		if(SOUTHEAST)
			return "к юго-востоку от вас"
		if(SOUTHWEST)
			return "к юго-западу от вас"
	return "прямо здесь"

#undef HOURGLASS_SENSE_RANGE
