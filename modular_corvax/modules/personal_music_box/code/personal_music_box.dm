#define PERSONAL_MUSIC_BOX_UPLOAD_DIR "data/personal_music_box/"
#define PERSONAL_MUSIC_BOX_MAX_FILE_SIZE (12 * 1024 * 1024)
#define PERSONAL_MUSIC_BOX_MAX_UPLOADS_PER_ROUND 10
#define PERSONAL_MUSIC_BOX_PLAYER_UPLOAD_COOLDOWN (1 MINUTES)
#define PERSONAL_MUSIC_BOX_UPLOAD_COOLDOWN (30 SECONDS)
#define PERSONAL_MUSIC_BOX_PLAY_COOLDOWN (10 SECONDS)
#define PERSONAL_MUSIC_BOX_MAX_TRACK_LENGTH (20 MINUTES)
#define PERSONAL_MUSIC_BOX_MAX_TRACK_NAME_LEN 64
#define PERSONAL_MUSIC_BOX_MAX_VOLUME 100
#define PERSONAL_MUSIC_BOX_MIN_SPEAKER_RANGE 2
#define PERSONAL_MUSIC_BOX_MAX_SPEAKER_RANGE 15
#define PERSONAL_MUSIC_BOX_DEFAULT_VOLUME 50
#define PERSONAL_MUSIC_BOX_UPLOAD_LOCK_TIMEOUT (5 MINUTES)

GLOBAL_VAR_INIT(personal_music_boxes_last_upload, 0)
GLOBAL_VAR_INIT(personal_music_boxes_dir_ready, FALSE)
GLOBAL_LIST_EMPTY(personal_music_boxes_last_player_upload)
GLOBAL_LIST_EMPTY(personal_music_boxes_library)
GLOBAL_LIST_EMPTY(personal_music_boxes_uploading)

/datum/modpack/personal_music_box
	name = "Айпод"
	desc = "Портативный плеер: свои треки (.ogg и .mp3) в наушниках или через динамик. Доступен в лоадауте."
	author = "BlueMoon-Labs"

/client
	var/music_box_upload_size_limit = 0

/datum/sound_token/proc/set_sound_range(new_range)
	if(range == new_range)
		return
	for(var/datum/spatial_grid_cell/cell as anything in cell_tracker.member_cells)
		UnregisterSignal(cell, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))
	range = new_range
	cell_tracker = new /datum/cell_tracker(range, range)
	update_tracked_cells()
	update_all_listeners()

/obj/item/clothing/ears/personal_music_box_headphones
	name = "наушники"
	desc = "Наушники, подключённые к айподу."
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "headphones"
	inhand_icon_state = "headphones"
	worn_icon = 'icons/mob/clothing/ears.dmi'
	gender = PLURAL
	var/music_active = FALSE

/obj/item/clothing/ears/personal_music_box_headphones/proc/set_playing(new_state)
	if(music_active == new_state)
		return
	music_active = new_state
	icon_state = music_active ? "headphones_on" : "headphones"
	update_slot_icon()

/obj/item/personal_music_box
	name = "айпод"
	desc = "Портативный плеер с наушниками и режимом динамика. Загрузите с компьютера свои треки в формате .ogg или .mp3."
	icon = 'modular_corvax/modules/personal_music_box/icons/ipod.dmi'
	icon_state = "ipod"
	inhand_icon_state = "ipod"
	lefthand_file = 'modular_corvax/modules/personal_music_box/icons/ipod_lefthand.dmi'
	righthand_file = 'modular_corvax/modules/personal_music_box/icons/ipod_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	verb_say = "states"
	COOLDOWN_DECLARE(play_cooldown)
	var/datum/track/custom_track
	var/curfile_path
	var/song_name
	var/song_timerid
	var/music_volume = PERSONAL_MUSIC_BOX_DEFAULT_VOLUME
	var/music_loops = TRUE
	var/playback_channel
	var/datum/weakref/listener_ref
	var/speaker_mode = FALSE
	var/datum/sound_token/speaker_token
	var/obj/item/clothing/ears/personal_music_box_headphones/headphones
	var/last_position

/obj/item/personal_music_box/Initialize(mapload)
	. = ..()
	ru_names_rename(ru_names_list(name, "айпод", "айпода", "айподу", "айпод", "айподом", "айподе", MALE))
	headphones = new(src)
	RegisterSignal(headphones, COMSIG_ITEM_DROPPED, PROC_REF(on_headphones_dropped))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	update_appearance()

/obj/item/personal_music_box/Destroy()
	stop_music()
	QDEL_NULL(headphones)
	QDEL_NULL(custom_track)
	return ..()

/obj/item/personal_music_box/examine(mob/user)
	. = ..()
	. += span_notice("Активируйте айпод в руке, чтобы открыть меню. В наушниках музыку слышит только владелец, в режиме динамика — все рядом.")
	if(curfile_path)
		. += span_notice("Загружен трек: [song_name].")

/obj/item/personal_music_box/update_icon_state()
	icon_state = is_playing() ? "ipod_on" : "ipod"
	inhand_icon_state = icon_state
	return ..()

/obj/item/personal_music_box/proc/refresh_icons()
	headphones?.set_playing(is_playing() && !speaker_mode)
	update_appearance()
	update_slot_icon()

/obj/item/personal_music_box/proc/is_playing()
	return !isnull(playback_channel) || !isnull(speaker_token)

/obj/item/personal_music_box/proc/get_speaker_range()
	return PERSONAL_MUSIC_BOX_MIN_SPEAKER_RANGE + round(music_volume * (PERSONAL_MUSIC_BOX_MAX_SPEAKER_RANGE - PERSONAL_MUSIC_BOX_MIN_SPEAKER_RANGE) / PERSONAL_MUSIC_BOX_MAX_VOLUME)

/obj/item/personal_music_box/proc/get_holder()
	var/atom/current = loc
	while(current && !isturf(current))
		if(ismob(current))
			return current
		current = current.loc
	return null

/obj/item/personal_music_box/process(seconds_per_tick)
	if(!is_playing())
		return PROCESS_KILL
	if(speaker_token)
		var/turf/current_turf = get_turf(src)
		var/current_position = current_turf ? "[current_turf.x]_[current_turf.y]_[current_turf.z]" : null
		if(current_position && current_position != last_position)
			last_position = current_position
			speaker_token.source_moved()
		return
	var/mob/listener = listener_ref?.resolve()
	if(!listener?.client || get_holder() != listener)
		stop_music()

/obj/item/personal_music_box/proc/on_moved(datum/source, atom/old_loc)
	SIGNAL_HANDLER
	if(is_playing() && !speaker_token && get_holder() != listener_ref?.resolve())
		stop_music()

/obj/item/personal_music_box/proc/on_headphones_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing() && !speaker_token)
		stop_music()

/obj/item/personal_music_box/proc/on_listener_deaf(mob/source)
	SIGNAL_HANDLER
	if(is_playing())
		send_sound(source, SOUND_UPDATE)

/obj/item/personal_music_box/proc/send_sound(mob/listener, status = NONE)
	var/sound/music = sound(custom_track.song_path, music_loops, FALSE, playback_channel, music_volume)
	music.priority = 255
	music.environment = SOUND_ENVIRONMENT_NONE
	music.status = status | (HAS_TRAIT(listener, TRAIT_DEAF) ? SOUND_MUTE : NONE)
	SEND_SOUND(listener, music)

/obj/item/personal_music_box/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/personal_music_box/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PersonalMusicBox", name)
		ui.open()

/obj/item/personal_music_box/ui_data(mob/user)
	var/upload_block_reason = get_upload_block_reason(user)
	var/play_block_reason = get_play_block_reason()
	var/list/data = list()
	data["playing"] = is_playing()
	data["repeat"] = !!music_loops
	data["has_track"] = !!curfile_path
	data["track_name"] = song_name
	data["track_duration"] = custom_track ? DisplayTimeText(custom_track.song_length) : null
	data["volume"] = music_volume
	data["speaker_mode"] = speaker_mode
	data["speaker_range"] = get_speaker_range()
	data["in_hand"] = loc == user
	data["upload_ready"] = isnull(upload_block_reason)
	data["upload_block_reason"] = upload_block_reason
	data["play_ready"] = isnull(play_block_reason)
	data["play_block_reason"] = play_block_reason
	var/list/library = user?.ckey ? GLOB.personal_music_boxes_library[user.ckey] : null
	var/list/library_data = list()
	for(var/index in 1 to length(library))
		var/list/entry = library[index]
		UNTYPED_LIST_ADD(library_data, list("index" = index, "name" = entry["name"], "duration" = entry["duration"], "current" = entry["path"] == curfile_path))
	data["library"] = library_data
	data["uploads_max"] = PERSONAL_MUSIC_BOX_MAX_UPLOADS_PER_ROUND
	data["max_file_size_mb"] = PERSONAL_MUSIC_BOX_MAX_FILE_SIZE / (1024 * 1024)
	return data

/obj/item/personal_music_box/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	switch(action)
		if("toggle")
			toggle_playback(living_user)
			return TRUE
		if("repeat")
			return toggle_repeat()
		if("select_track")
			return select_library_track(living_user, text2num(params["index"]))
		if("upload")
			var/block_reason = get_upload_block_reason(living_user)
			if(block_reason)
				to_chat(living_user, span_warning(block_reason))
				return TRUE
			playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
			INVOKE_ASYNC(src, PROC_REF(upload_file), living_user)
			return TRUE
		if("set_speaker")
			set_speaker_mode(text2num(params["speaker"]), living_user)
			return TRUE
		if("set_volume")
			return set_volume(text2num(params["volume"]))

/obj/item/personal_music_box/proc/set_volume(new_volume)
	if(!isnum(new_volume))
		return FALSE
	music_volume = clamp(round(new_volume), 0, PERSONAL_MUSIC_BOX_MAX_VOLUME)
	if(speaker_token)
		speaker_token.set_sound_range(get_speaker_range())
		speaker_token.set_volume(music_volume)
		return TRUE
	var/mob/listener = listener_ref?.resolve()
	if(is_playing() && listener)
		send_sound(listener, SOUND_UPDATE)
	return TRUE

/obj/item/personal_music_box/proc/toggle_repeat()
	if(is_playing())
		return FALSE
	music_loops = !music_loops
	return TRUE

/obj/item/personal_music_box/proc/get_upload_block_reason(mob/user, ignore_own_lock = FALSE)
	if(is_playing())
		return "Сначала выключите айпод."
	if(!user || loc != user)
		return "Айпод должен быть у вас в руках."
	if(!user.ckey)
		return "Некому загружать трек."
	if(!ignore_own_lock && GLOB.personal_music_boxes_uploading[user.ckey])
		return "У вас уже открыт диалог выбора файла."
	if(length(GLOB.personal_music_boxes_library[user.ckey]) >= PERSONAL_MUSIC_BOX_MAX_UPLOADS_PER_ROUND)
		return "Вы исчерпали лимит загрузок на раунд (максимум [PERSONAL_MUSIC_BOX_MAX_UPLOADS_PER_ROUND]). Загруженные треки можно выбрать в библиотеке."
	var/last_player_upload = GLOB.personal_music_boxes_last_player_upload[user.ckey]
	var/player_remaining = last_player_upload ? last_player_upload + PERSONAL_MUSIC_BOX_PLAYER_UPLOAD_COOLDOWN - world.time : 0
	if(player_remaining > 0)
		return "Новый трек можно загрузить через [DisplayTimeText(player_remaining)]."
	var/global_remaining = GLOB.personal_music_boxes_last_upload ? GLOB.personal_music_boxes_last_upload + PERSONAL_MUSIC_BOX_UPLOAD_COOLDOWN - world.time : 0
	if(global_remaining > 0)
		return "Кто-то недавно загружал трек. Подождите [DisplayTimeText(global_remaining)]."
	return null

/obj/item/personal_music_box/proc/get_play_block_reason()
	if(!curfile_path || !custom_track)
		return "Сначала загрузите трек."
	if(is_playing())
		return "Айпод уже играет."
	if(!speaker_mode)
		var/headphones_reason = get_headphones_block_reason()
		if(headphones_reason)
			return headphones_reason
	if(!fexists(curfile_path))
		return "Файл трека больше не найден на сервере."
	if(!COOLDOWN_FINISHED(src, play_cooldown))
		return "Включить можно через [DisplayTimeText(COOLDOWN_TIMELEFT(src, play_cooldown))]."
	return null

/obj/item/personal_music_box/proc/get_audio_track_length(file_path)
	var/reported_length = rustg_sound_length(file_path)
	if(!isnum(reported_length) || reported_length <= 0)
		return 0
	return min(reported_length, PERSONAL_MUSIC_BOX_MAX_TRACK_LENGTH)

/obj/item/personal_music_box/proc/upload_file(mob/living/user)
	var/user_ckey = user.ckey
	if(!user_ckey || GLOB.personal_music_boxes_uploading[user_ckey])
		return
	GLOB.personal_music_boxes_uploading[user_ckey] = TRUE
	var/lock_timer = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_personal_music_box_upload_lock), user_ckey), PERSONAL_MUSIC_BOX_UPLOAD_LOCK_TIMEOUT, TIMER_STOPPABLE)
	do_upload_file(user)
	deltimer(lock_timer)
	clear_personal_music_box_upload_lock(user_ckey)

/proc/clear_personal_music_box_upload_lock(user_ckey)
	if(!user_ckey)
		return
	GLOB.personal_music_boxes_uploading -= user_ckey
	var/client/uploader = GLOB.directory[user_ckey]
	if(uploader)
		uploader.music_box_upload_size_limit = 0

/proc/prepare_personal_music_box_upload_dir()
	if(GLOB.personal_music_boxes_dir_ready)
		return
	GLOB.personal_music_boxes_dir_ready = TRUE
	fdel(PERSONAL_MUSIC_BOX_UPLOAD_DIR)

/obj/item/personal_music_box/proc/do_upload_file(mob/living/user)
	var/client/uploader = user.client
	if(!uploader)
		return
	uploader.music_box_upload_size_limit = PERSONAL_MUSIC_BOX_MAX_FILE_SIZE
	var/infile = input(user, "Выберите файл .ogg или .mp3 (до [PERSONAL_MUSIC_BOX_MAX_FILE_SIZE / (1024 * 1024)] МБ):", name) as sound|null
	uploader.music_box_upload_size_limit = 0
	if(!infile || QDELETED(src) || QDELETED(user))
		return
	store_upload(user, infile, "[infile]")

/obj/item/personal_music_box/proc/store_upload(mob/living/user, infile, filename)
	var/block_reason = get_upload_block_reason(user, TRUE)
	if(block_reason)
		to_chat(user, span_warning(block_reason))
		return FALSE
	var/lower_filename = lowertext(filename)
	if(!IS_SOUND_FILE_SAFE(lower_filename))
		to_chat(user, span_warning("Поддерживаются только файлы .ogg и .mp3."))
		return FALSE
	var/file_size = length(infile)
	if(file_size > PERSONAL_MUSIC_BOX_MAX_FILE_SIZE)
		to_chat(user, span_warning("Файл слишком большой. Максимум [PERSONAL_MUSIC_BOX_MAX_FILE_SIZE / (1024 * 1024)] МБ."))
		return FALSE

	prepare_personal_music_box_upload_dir()
	var/extension = copytext(lower_filename, findlasttext(lower_filename, "."))
	var/stored_path = "[PERSONAL_MUSIC_BOX_UPLOAD_DIR][user.ckey]_[num2text(world.realtime, 12)][extension]"
	fdel(stored_path)
	if(!fcopy(infile, stored_path) || length(file(stored_path)) != file_size)
		fdel(stored_path)
		to_chat(user, span_warning("Не удалось загрузить трек."))
		return FALSE
	var/track_length = get_audio_track_length(stored_path)
	if(!track_length)
		fdel(stored_path)
		to_chat(user, span_warning("Файл не распознан как аудио."))
		return FALSE

	GLOB.personal_music_boxes_last_player_upload[user.ckey] = world.time
	GLOB.personal_music_boxes_last_upload = world.time
	var/track_name = get_personal_music_box_track_name(filename)
	user.log_message("uploaded personal music box track \"[track_name]\" ([file_size] bytes): [stored_path]", LOG_GAME)

	var/list/entry = list(
		"path" = stored_path,
		"name" = track_name,
		"length" = track_length,
		"duration" = DisplayTimeText(track_length),
	)
	var/list/library = GLOB.personal_music_boxes_library[user.ckey]
	if(!library)
		library = list()
		GLOB.personal_music_boxes_library[user.ckey] = library
	UNTYPED_LIST_ADD(library, entry)
	load_track(entry)
	to_chat(user, span_notice("Трек «[song_name]» загружен."))
	return TRUE

/obj/item/personal_music_box/proc/load_track(list/entry)
	var/datum/track/new_track = new()
	new_track.song_name = entry["name"]
	new_track.song_path = file(entry["path"])
	new_track.song_length = entry["length"]
	QDEL_NULL(custom_track)
	custom_track = new_track
	curfile_path = entry["path"]
	song_name = entry["name"]
	refresh_icons()

/obj/item/personal_music_box/proc/select_library_track(mob/living/user, index)
	if(!user?.ckey || is_playing() || loc != user)
		return FALSE
	var/list/library = GLOB.personal_music_boxes_library[user.ckey]
	if(!isnum(index) || index != round(index) || index < 1 || index > length(library))
		return FALSE
	var/list/entry = library[index]
	if(entry["path"] == curfile_path)
		return FALSE
	if(!fexists(entry["path"]))
		to_chat(user, span_warning("Файл трека больше не найден на сервере."))
		return FALSE
	load_track(entry)
	user.log_message("selected personal music box track: [curfile_path]", LOG_GAME)
	return TRUE

/obj/item/personal_music_box/proc/toggle_playback(mob/living/user)
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	if(is_playing())
		stop_music(user)
		return
	var/block_reason = get_play_block_reason()
	if(block_reason)
		to_chat(user, span_warning(block_reason))
		return
	start_music(user)

/obj/item/personal_music_box/proc/get_headphones_block_reason()
	var/mob/holder = get_holder()
	if(!holder?.client)
		return "Айпод должен быть у вас при себе."
	if(!ishuman(holder))
		return "Наушники подходят только людям. Включите режим динамика."
	var/mob/living/carbon/human/human_holder = holder
	var/obj/item/worn_item = human_holder.get_item_by_slot(ITEM_SLOT_EARS)
	if(worn_item && worn_item != headphones)
		return "Слот для наушников занят. Освободите его или включите режим динамика."
	return null

/obj/item/personal_music_box/proc/deploy_headphones(mob/living/carbon/human/listener)
	if(listener.get_item_by_slot(ITEM_SLOT_EARS) == headphones)
		return TRUE
	retract_headphones()
	return listener.equip_to_slot_if_possible(headphones, ITEM_SLOT_EARS, qdel_on_fail = FALSE, disable_warning = TRUE)

/obj/item/personal_music_box/proc/retract_headphones()
	if(!headphones || headphones.loc == src)
		return
	if(ismob(headphones.loc))
		var/mob/wearer = headphones.loc
		wearer.transferItemToLoc(headphones, src, TRUE)
		return
	headphones.forceMove(src)

/obj/item/personal_music_box/proc/set_speaker_mode(new_mode, mob/living/user)
	new_mode = !!new_mode
	if(speaker_mode == new_mode)
		return
	var/was_playing = is_playing()
	if(was_playing)
		stop_music()
	speaker_mode = new_mode
	if(was_playing)
		start_music(user)
	else
		refresh_icons()

/obj/item/personal_music_box/proc/start_private(mob/listener)
	playback_channel = SSsounds.reserve_sound_channel_for_datum(src)
	listener_ref = WEAKREF(listener)
	RegisterSignals(listener, list(SIGNAL_ADDTRAIT(TRAIT_DEAF), SIGNAL_REMOVETRAIT(TRAIT_DEAF)), PROC_REF(on_listener_deaf))
	send_sound(listener)

/obj/item/personal_music_box/proc/start_speaker()
	speaker_token = new /datum/sound_token(src, custom_track.song_path, get_speaker_range(), music_volume, _sound_duration_override = custom_track.song_length, _repeating = music_loops)

/obj/item/personal_music_box/proc/start_music(mob/living/user)
	if(!custom_track || is_playing())
		to_chat(user, span_warning("Не удалось начать воспроизведение."))
		return
	var/mob/listener = get_holder()
	if(!speaker_mode)
		var/block_reason = get_headphones_block_reason()
		if(block_reason || !deploy_headphones(listener))
			to_chat(user, span_warning(block_reason || "Не удалось надеть наушники."))
			return
	COOLDOWN_START(src, play_cooldown, PERSONAL_MUSIC_BOX_PLAY_COOLDOWN)
	if(speaker_mode)
		start_speaker()
	else
		start_private(listener)
	if(!music_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), custom_track.song_length, TIMER_STOPPABLE|TIMER_DELETE_ME)
	last_position = null
	START_PROCESSING(SSprocessing, src)
	refresh_icons()
	visible_message(span_notice("[user] включает [declent_ru(ACCUSATIVE)]."), span_notice("Вы включаете [declent_ru(ACCUSATIVE)]."), vision_distance = COMBAT_MESSAGE_RANGE)
	user.log_message("played personal music box track: [curfile_path]", LOG_GAME)

/obj/item/personal_music_box/proc/stop_music(mob/living/user)
	if(song_timerid)
		deltimer(song_timerid)
		song_timerid = null
	STOP_PROCESSING(SSprocessing, src)
	last_position = null
	QDEL_NULL(speaker_token)
	var/mob/listener = listener_ref?.resolve()
	listener_ref = null
	if(listener)
		UnregisterSignal(listener, list(SIGNAL_ADDTRAIT(TRAIT_DEAF), SIGNAL_REMOVETRAIT(TRAIT_DEAF)))
	if(playback_channel)
		listener?.stop_sound_channel(playback_channel)
		SSsounds.free_sound_channel(playback_channel)
		playback_channel = null
	retract_headphones()
	if(QDELING(src))
		return
	refresh_icons()
	if(user)
		user.log_message("stopped personal music box track: [curfile_path]", LOG_GAME)

/proc/get_personal_music_box_track_name(filename)
	var/track_label = filename
	var/path_separator = max(findlasttext(track_label, "/"), findlasttext(track_label, "\\"))
	if(path_separator)
		track_label = copytext(track_label, path_separator + 1)
	var/dot_position = findlasttext(track_label, ".")
	if(dot_position)
		track_label = copytext(track_label, 1, dot_position)
	track_label = trim(GLOB.angular_brackets.Replace(copytext_char(track_label, 1, PERSONAL_MUSIC_BOX_MAX_TRACK_NAME_LEN + 1), ""))
	return length(track_label) ? track_label : "Свой трек"

#undef PERSONAL_MUSIC_BOX_MAX_UPLOADS_PER_ROUND
#undef PERSONAL_MUSIC_BOX_PLAYER_UPLOAD_COOLDOWN
#undef PERSONAL_MUSIC_BOX_UPLOAD_COOLDOWN
#undef PERSONAL_MUSIC_BOX_PLAY_COOLDOWN
#undef PERSONAL_MUSIC_BOX_MAX_TRACK_LENGTH
#undef PERSONAL_MUSIC_BOX_MAX_TRACK_NAME_LEN
#undef PERSONAL_MUSIC_BOX_MAX_VOLUME
#undef PERSONAL_MUSIC_BOX_MIN_SPEAKER_RANGE
#undef PERSONAL_MUSIC_BOX_MAX_SPEAKER_RANGE
#undef PERSONAL_MUSIC_BOX_DEFAULT_VOLUME
#undef PERSONAL_MUSIC_BOX_UPLOAD_LOCK_TIMEOUT
#undef PERSONAL_MUSIC_BOX_UPLOAD_DIR
#undef PERSONAL_MUSIC_BOX_MAX_FILE_SIZE
