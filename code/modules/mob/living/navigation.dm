#define MAX_NAVIGATE_RANGE 255 // CORVAX EDIT CHANGE - ORIGINAL: #define MAX_NAVIGATE_RANGE 125
// CORVAX EDIT ADD START
/// How close the route gets to a destination behind a locked door
#define NAVIGATE_ENTRANCE_DISTANCE 3
/// How many stairs or ladders are tried before giving up on changing levels
#define NAVIGATE_MAX_ZCHANGE_TARGETS 4
// CORVAX EDIT ADD END

/mob/living
	/// Are we currently pathfinding for the navigate verb?
	var/navigating = FALSE
	/// Cooldown of the navigate() verb.
	COOLDOWN_DECLARE(navigate_cooldown)

/client
	/// Images of the path created by navigate().
	var/list/navigation_images = list()

GAME_VERB(/mob/living, navigate, "Navigate", "IC") // CRIMSON EDIT CHANGE ORIGINAL: GAME_VERB_HIDDEN(/mob/living, navigate, "Navigate")

	if(incapacitated)
		return
	if(length(client.navigation_images))
		addtimer(CALLBACK(src, PROC_REF(cut_navigation)), world.tick_lag)
		balloon_alert(src, "навигация убрана")
		return
	if(navigating)
		balloon_alert(src, "маршрут уже строится!")
		return
	if(!COOLDOWN_FINISHED(src, navigate_cooldown))
		balloon_alert(src, "навигация на задержке!")
		return
	addtimer(CALLBACK(src, PROC_REF(create_navigation)), world.tick_lag)

/mob/living/proc/create_navigation()
	var/list/destination_list = list()
	var/turf/our_turf = get_turf(src) // CRIMSON EDIT ADD - inside a vehicle our own z is 0
	if(!our_turf) // CRIMSON EDIT ADD
		return // CRIMSON EDIT ADD
	var/list/connected_levels = SSmapping.get_connected_levels(our_turf) // CORVAX EDIT ADD // CRIMSON EDIT CHANGE ORIGINAL: var/list/connected_levels = SSmapping.get_connected_levels(z)
	for(var/atom/destination as anything in GLOB.navigate_destinations)
		if(!(destination.z in connected_levels)) // CORVAX EDIT CHANGE - ORIGINAL: if(get_dist(destination, src) > MAX_NAVIGATE_RANGE)
			continue
		var/destination_name = GLOB.navigate_destinations[destination]
		if(destination.z != our_turf.z && is_multi_z_level(our_turf.z)) // up or down is just a good indicator "we're on the station", we don't need to check specifics // CRIMSON EDIT CHANGE ORIGINAL: if(destination.z != z && is_multi_z_level(z))
			destination_name += ((get_dir_multiz(src, destination) & UP) ? " (выше)" : " (ниже)")

		destination_list[destination_name] = destination

	var/can_go_down = SSmapping.level_trait(our_turf.z, ZTRAIT_DOWN) // CRIMSON EDIT CHANGE ORIGINAL: var/can_go_down = SSmapping.level_trait(z, ZTRAIT_DOWN)
	var/can_go_up = SSmapping.level_trait(our_turf.z, ZTRAIT_UP) // CRIMSON EDIT CHANGE ORIGINAL: var/can_go_up = SSmapping.level_trait(z, ZTRAIT_UP)
	if(can_go_down)
		destination_list["Близлежащий путь вниз"] = DOWN
	if(can_go_up)
		destination_list["Близлежащий путь вверх"] = UP

	if(!length(destination_list))
		balloon_alert(src, "нет сигнала для навигации!")
		return

	var/platform_code = tgui_input_list(src, "Выберите локацию", "Навигация", sort_list(destination_list))
	var/atom/navigate_target = destination_list[platform_code]
	create_navigation_line(navigate_target)

/mob/living/proc/create_navigation_line(atom/navigate_target)
	if(isnull(navigate_target) || incapacitated)
		return

	cut_navigation()

	var/list/zchange_fallbacks // CORVAX EDIT ADD
	var/finding_zchange = FALSE
	COOLDOWN_START(src, navigate_cooldown, 15 SECONDS)
	var/turf/our_turf = get_turf(src) // CRIMSON EDIT ADD - inside a vehicle our own z is 0
	if(navigate_target == UP || navigate_target == DOWN || (isatom(navigate_target) && our_turf && navigate_target.z != our_turf.z)) // CRIMSON EDIT CHANGE ORIGINAL: if(navigate_target == UP || navigate_target == DOWN || (isatom(navigate_target) && navigate_target.z != z))
		// lowering the cooldown to 5 seconds if we're navigating to a ladder or staircase instead of a proper destination
		// (so we can decide to move to another destination right off the bat, rather than needing to wait)
		COOLDOWN_START(src, navigate_cooldown, 5 SECONDS)
		var/direction_name = isatom(navigate_target) ? "туда" : (navigate_target == UP ? "вверх" : "вниз")
		var/nav_dir = isatom(navigate_target) ? (get_dir_multiz(src, navigate_target) & (UP|DOWN)) : navigate_target
		// CORVAX EDIT CHANGE START - ORIGINAL: var/atom/new_target = find_nearest_stair_or_ladder(nav_dir)
		var/list/zchange_targets = find_stairs_or_ladders(nav_dir)

		if(!length(zchange_targets))
			balloon_alert(src, "не удалось найти ступеньки или лестницу ведущую [direction_name]!")
			return

		navigate_target = zchange_targets[1]
		zchange_fallbacks = zchange_targets.Copy(2, min(length(zchange_targets), NAVIGATE_MAX_ZCHANGE_TARGETS) + 1)
		// CORVAX EDIT CHANGE END
		finding_zchange = TRUE

	if(!isatom(navigate_target))
		CRASH("Navigate target ([navigate_target]) is not an atom, somehow.")

	start_navigation_pathfind(navigate_target, finding_zchange, zchange_fallbacks, 1) // CORVAX EDIT CHANGE

// CORVAX EDIT ADD START
/mob/living/proc/start_navigation_pathfind(atom/navigate_target, finding_zchange, list/zchange_fallbacks, mintargetdist)
	navigating = TRUE
	var/datum/callback/await = list(CALLBACK(src, PROC_REF(finish_navigation), navigate_target, finding_zchange, zchange_fallbacks, mintargetdist))
	if(!SSpathfinder.pathfind(src, navigate_target, MAX_NAVIGATE_RANGE, mintargetdist = mintargetdist, access = get_access(), skip_first = FALSE, on_finish = await))
		navigating = FALSE
		balloon_alert(src, "не удалось проложить маршрут!")
// CORVAX EDIT ADD END

/mob/living/proc/finish_navigation(turf/navigate_target, finding_zchange, list/zchange_fallbacks, mintargetdist, list/path) // CORVAX EDIT CHANGE - ORIGINAL: /mob/living/proc/finish_navigation(turf/navigate_target, finding_zchange, list/path)
	navigating = FALSE
	if(!client)
		return
	if(!length(path))
		// CORVAX EDIT ADD START - stairs behind a locked door are skipped, a locked destination is reached at its entrance
		if(length(zchange_fallbacks))
			start_navigation_pathfind(zchange_fallbacks[1], finding_zchange, zchange_fallbacks.Copy(2), mintargetdist)
			return
		if(!finding_zchange && mintargetdist < NAVIGATE_ENTRANCE_DISTANCE)
			start_navigation_pathfind(navigate_target, finding_zchange, null, NAVIGATE_ENTRANCE_DISTANCE)
			return
		// CORVAX EDIT ADD END
		balloon_alert(src, "нет доступного пути с текущим доступом!")
		return
	if(mintargetdist <= 1) // CORVAX EDIT ADD
		path |= get_turf(navigate_target)
	for(var/i in 1 to length(path))
		var/turf/current_turf = path[i]
		var/image/path_image = image(icon = 'icons/effects/navigation.dmi', layer = HIGH_PIPE_LAYER, loc = current_turf)
		SET_PLANE(path_image, GAME_PLANE, current_turf)
		path_image.color = COLOR_CYAN
		path_image.alpha = 0
		var/dir_1 = 0
		var/dir_2 = 0
		if(i == 1)
			dir_2 = REVERSE_DIR(angle2dir(get_angle(path[i+1], current_turf)))
		else if(i == length(path))
			dir_2 = REVERSE_DIR(angle2dir(get_angle(path[i-1], current_turf)))
		else
			dir_1 = REVERSE_DIR(angle2dir(get_angle(path[i+1], current_turf)))
			dir_2 = REVERSE_DIR(angle2dir(get_angle(path[i-1], current_turf)))
			if(dir_1 > dir_2)
				dir_1 = dir_2
				dir_2 = REVERSE_DIR(angle2dir(get_angle(path[i+1], current_turf)))
		path_image.icon_state = "[dir_1]-[dir_2]"
		client.images += path_image
		client.navigation_images += path_image
		animate(path_image, 0.5 SECONDS, alpha = 150)
	addtimer(CALLBACK(src, PROC_REF(shine_navigation)), 0.5 SECONDS)
	RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(cut_navigation))
	if(finding_zchange)
		RegisterSignal(src, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(cut_navigation))
	balloon_alert(src, "путь к месту назначания построен")

/mob/living/proc/shine_navigation()
	for(var/i in 1 to length(client.navigation_images))
		if(!length(client.navigation_images))
			return
		animate(client.navigation_images[i], time = 1 SECONDS, loop = -1, alpha = 200, color = "#bbffff", easing = BACK_EASING | EASE_OUT)
		animate(time = 2 SECONDS, loop = -1, alpha = 150, color = "#00ffff", easing = CUBIC_EASING | EASE_OUT)
		stoplag(0.1 SECONDS)

/mob/living/proc/cut_navigation()
	SIGNAL_HANDLER
	if(!length(client.navigation_images))
		return

	for(var/image/navigation_path in client.navigation_images)
		client.images -= navigation_path
	client.navigation_images.Cut()
	UnregisterSignal(src, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_Z_CHANGED))

// CORVAX EDIT CHANGE START - ORIGINAL: /mob/living/proc/find_nearest_stair_or_ladder(direction) returned only the nearest one
/**
 * Finds ladders and staircases leading either up or down, nearest first.
 *
 * Arguments:
 * * direction - UP or DOWN.
 */
/mob/living/proc/find_stairs_or_ladders(direction)
	. = list()
	if(direction != UP && direction != DOWN)
		return
	var/turf/our_turf = get_turf(src) // CRIMSON EDIT ADD - inside a vehicle our own z is 0
	if(!our_turf) // CRIMSON EDIT ADD
		return // CRIMSON EDIT ADD

	var/list/distances = list()
	for(var/obj/structure/ladder/lad in GLOB.ladders)
		if(lad.z != our_turf.z) // CRIMSON EDIT CHANGE ORIGINAL: if(lad.z != z)
			continue
		if(direction == UP && !lad.up)
			continue
		if(direction == DOWN && !lad.down)
			continue
		distances[lad] = get_dist_euclidean(lad, our_turf) // CRIMSON EDIT CHANGE ORIGINAL: distances[lad] = get_dist_euclidean(lad, src)

	for(var/obj/structure/stairs/stairs_bro in GLOB.stairs)
		if(direction == UP && stairs_bro.z != our_turf.z) //if we're going up, we need to find stairs on our z level // CRIMSON EDIT CHANGE ORIGINAL: if(direction == UP && stairs_bro.z != z)
			continue
		if(direction == DOWN && stairs_bro.z != our_turf.z - 1) //if we're going down, we need to find stairs on the z level beneath us // CRIMSON EDIT CHANGE ORIGINAL: if(direction == DOWN && stairs_bro.z != z - 1)
			continue
		var/atom/stairs_target = stairs_bro.z == our_turf.z ? stairs_bro : get_step_multiz(stairs_bro, UP) //if the stairs aren't on our z level, get the turf above them (on our zlevel) to path to instead // CRIMSON EDIT CHANGE ORIGINAL: var/atom/stairs_target = stairs_bro.z == z ? stairs_bro : get_step_multiz(stairs_bro, UP)
		if(stairs_target)
			distances[stairs_target] = get_dist_euclidean(stairs_target, our_turf) // CRIMSON EDIT CHANGE ORIGINAL: distances[stairs_target] = get_dist_euclidean(stairs_target, src)

	sortTim(distances, GLOBAL_PROC_REF(cmp_numeric_asc), associative = TRUE)
	for(var/atom/target as anything in distances)
		. += target
// CORVAX EDIT CHANGE END

#undef NAVIGATE_ENTRANCE_DISTANCE
#undef NAVIGATE_MAX_ZCHANGE_TARGETS
#undef MAX_NAVIGATE_RANGE
