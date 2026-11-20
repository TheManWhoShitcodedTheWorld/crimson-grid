ADMIN_VERB_ONLY_CONTEXT_MENU(roll_storyteller_dice, R_FUN, "Roll storyteller dice", /mob/living)
	VERB_ARG_TYPED(roller, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)

	roller.roll_dice_custom()

	BLACKBOX_LOG_ADMIN_VERB("Storyteller dice")

GAME_VERB(/mob/living, do_roll_dice_custom, "Roll custom dice", null)
	roll_dice_custom()

/mob/living/proc/roll_dice_custom(atom/movable/roll_target)
	var/list/allowed_stats = list()
	var/list/stat_labels = list()
	for(var/stat_path, dots_in in storyteller_stats)
		var/datum/st_stat/stat = stat_path
		if(!ispath(stat))
			continue
		if(stat == stat::abstract_type)
			continue
		allowed_stats += stat
		stat_labels += "[stat::name] ([st_get_stat(stat)])" // CORVAX EDIT CHANGE - ORIGINAL: stat_labels += stat::name
		//allowed_stats[stat] = "[stat::name]: [dots_in]"
	var/list/stats_to_use = tgui_input_checkboxes(usr, "Выберите параметры для проверки.", "Параметры", stat_labels, min_checked = 0, max_checked = 5)
	// CORVAX EDIT ADD START - closing the window cancels the roll instead of rolling with no stats
	if(isnull(stats_to_use))
		return
	// CORVAX EDIT ADD END
	var/list/output_stats = list()
	if(length(stats_to_use))
		for(var/list/stat as anything in stats_to_use)
			output_stats += allowed_stats[stat[2]]

	// CORVAX EDIT ADD START - optional description shown in the roll title
	var/roll_description = tgui_input_text(usr, "Что вы пытаетесь сделать? Можно оставить пустым.", "Подпись проверки", "", max_length = 60)
	if(isnull(roll_description))
		return
	roll_description = trim(roll_description)
	// CORVAX EDIT ADD END

	// CORVAX EDIT CHANGE START - block moved here from after "successes_needed": two checkbox windows in a row
	// reuse the same tgui window with the same size, and the client leaves the second one ("Цели") hidden
	var/static/list/roll_choices = list(
		"Всем вокруг" = ROLL_FLAG_NEARBY,
		"Только мне" = ROLL_FLAG_ROLLER,
		"Цели" = ROLL_FLAG_TARGET, // CORVAX EDIT CHANGE - ORIGINAL: "Мне и цели" = ROLL_FLAG_TARGET,
		"Администрации" = ROLL_FLAG_ADMIN,
	)
	var/list/roll_type_choice = tgui_input_checkboxes(usr, "Кому показать результат проверки?", "Тип проверки", assoc_to_keys(roll_choices)) // CORVAX EDIT CHANGE - ORIGINAL: var/list/roll_type_choice = tgui_input_checkboxes(usr, "Кому показать результат проверки?", "Тип проверки", roll_choices)
	if(!roll_type_choice)
		return
	var/roll_type = NONE
	for(var/list/entry in roll_type_choice)
		roll_type |= roll_choices[entry[1]] // CORVAX EDIT CHANGE - ORIGINAL: roll_type |= roll_choices.Find(entry[1]) + 1
	// CORVAX EDIT CHANGE END

	var/bonus_dice = tgui_input_number(usr, "Сколько дополнительных кубиков добавить?", "Кубики", 0, 20, -20)
	if(isnull(bonus_dice))
		return

	var/difficulty = tgui_input_number(usr, "Укажите сложность проверки.", "Сложность", 6, ROLL_DIFFICULTY_MAX, ROLL_DIFFICULTY_MIN)
	if(isnull(difficulty))
		return

	var/successes_needed = tgui_input_number(usr, "Сколько успехов нужно для прохождения?", "Нужно успехов", 1, 5, 1)
	if(isnull(successes_needed))
		return

	// CORVAX EDIT REMOVAL - the "Кому показать" block (roll_choices / roll_type) used to be here, see the CORVAX EDIT CHANGE above

	// CORVAX EDIT ADD START - "Цели" asks which visible people see the roll, several can be picked
	var/list/roll_targets = list()
	if(roll_target)
		roll_targets += roll_target
	if((roll_type & ROLL_FLAG_TARGET) && !length(roll_targets))
		roll_targets = pick_custom_roll_targets()
		if(!length(roll_targets))
			return
	// CORVAX EDIT ADD END

	var/datum/storyteller_roll/custom_roll/custom_roll = new()
	custom_roll.applicable_stats = output_stats
	custom_roll.difficulty = difficulty
	custom_roll.successes_needed = successes_needed
	custom_roll.roll_output_type = roll_type
	// CORVAX EDIT CHANGE START - ORIGINAL: return custom_roll.st_roll(src, roll_target, bonus_dice)
	if(roll_description)
		custom_roll.bumper_text = roll_description
	custom_roll.roll_targets = roll_targets
	. = custom_roll.st_roll(src, null, bonus_dice)
	var/list/target_keys = list()
	for(var/mob/living/target as anything in roll_targets)
		target_keys += key_name(target)
	log_game("[key_name(usr)] made a custom roll for [key_name(src)]: \"[roll_description || custom_roll.bumper_text]\", targets [length(target_keys) ? english_list(target_keys) : "none"], result [.]")
	// CORVAX EDIT CHANGE END

// CORVAX EDIT ADD START
/// Asks the roller which visible people should see the roll. Returns an empty list if there is no one or the choice was cancelled.
/mob/living/proc/pick_custom_roll_targets()
	. = list()
	var/list/candidates = list()
	var/list/used_names = list()
	for(var/mob/living/candidate in oviewers(DEFAULT_SIGHT_DISTANCE, src))
		candidates[avoid_assoc_duplicate_keys(GET_GUESTBOOK_NAME(usr, candidate), used_names)] = candidate
	if(!length(candidates))
		to_chat(usr, span_warning("Рядом нет никого, кому можно показать проверку."))
		return
	var/list/labels = sort_list(assoc_to_keys(candidates))
	var/list/picked = tgui_input_checkboxes(usr, "Кому показать проверку?", "Цели проверки", labels)
	// Each entry is list(label, index in labels). Names of unknown people start with a "\proper" macro that json_encode drops,
	// so the label sent back never matches the key; the index does.
	for(var/list/entry in picked)
		var/index = entry[2]
		var/mob/living/target = (isnum(index) && index >= 1 && index <= length(labels)) ? candidates[labels[index]] : null
		if(QDELETED(target) || !(target in oviewers(DEFAULT_SIGHT_DISTANCE, src)))
			continue
		. += target
// CORVAX EDIT ADD END


/datum/storyteller_roll/custom_roll
	bumper_text = "произвольная проверка"
	/// CORVAX EDIT ADD - everyone picked under "Цели"
	var/list/roll_targets

// CORVAX EDIT ADD START - show the roll to every picked target instead of a single one
/datum/storyteller_roll/custom_roll/get_mobs_to_show(mob/living/roller, atom/target, using_output_type)
	. = ..()
	if(using_output_type & ROLL_FLAG_TARGET)
		for(var/mob/living/picked_target as anything in roll_targets)
			if(!QDELETED(picked_target))
				. |= picked_target
// CORVAX EDIT ADD END

#define UI_MOB_DICE_ROLL "EAST-4:22,SOUTH+1:24"

/atom/movable/screen/dice_roll
	name = "Произвольная проверка"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "dice"
	screen_loc = UI_MOB_DICE_ROLL
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/dice_roll/Click()
	. = ..()

	var/mob/living/roller = astype(usr)
	roller?.roll_dice_custom()

#undef UI_MOB_DICE_ROLL
