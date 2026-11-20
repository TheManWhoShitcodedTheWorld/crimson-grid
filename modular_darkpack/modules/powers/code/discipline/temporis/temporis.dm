/datum/discipline/temporis
	name = "Темпорис"
	// CORVAX EDIT CHANGE - Temporis tooltip - ORIGINAL: all five power entries were labelled "пассивно".
	desc = {"Темпорис - Дисциплина, которой владеют лишь Истинные Бруха. Считается, что это отточенная до совершенства Стремительность: каинит обретает власть над самим течением времени.
● Песочные часы разума: Восприятие + Шестое чувство (пассивно)
●● Ретроспектива: без проверки
●●● Замедление времени: без проверки
●●●● Терпение Норн: без проверки
●●●●● Дар Клото: без проверки"}
	icon_state = "temporis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/temporis
	signature_clan = VAMPIRE_CLAN_TRUE_BRUJAH

/datum/discipline_power/temporis
	name = "Temporis power name"
	desc = "Temporis power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/temporis/temporis.ogg'

	magic_subtype = MAGIC_SUBTYPE_BLOOD_TIME

/datum/discipline_power/temporis/activate()
	. = ..()
	// CORVAX EDIT CHANGE START - Hourglass only perceives time; higher powers disturb it.
	// ORIGINAL: ADD_TRAIT(owner, TRAIT_TIMEWARPER, DISCIPLINE_TRAIT(type))
	if(. && level > 1)
		ADD_TRAIT(owner, TRAIT_TIMEWARPER, DISCIPLINE_TRAIT(type))
		notify_time_sense()
	// CORVAX EDIT CHANGE END

/datum/discipline_power/temporis/proc/celerity_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/celerity))
		return

	to_chat(owner, span_userdanger("Вы пытаетесь прибегнуть к Стремительности, но действующий Темпорис рвёт ваше тело на части!"))
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

//HOURGLASS OF THE MIND
/datum/discipline_power/temporis/hourglass_of_the_mind
	name = "Песочные часы разума"
	desc = "Вы безошибочно чувствуете ход времени и улавливаете отголоски чужого вмешательства в его течение." // CORVAX EDIT CHANGE - ORIGINAL: desc = "Безупречное чувство времени. Вы всегда точно знаете, который сейчас час."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

/datum/discipline_power/temporis/hourglass_of_the_mind/post_gain(post_gain_applied)
	ADD_TRAIT(owner, TRAIT_TIME_SENSE, DISCIPLINE_TRAIT(type))

/datum/discipline_power/temporis/hourglass_of_the_mind/post_loss()
	REMOVE_TRAIT(owner, TRAIT_TIME_SENSE, DISCIPLINE_TRAIT(type))
	return ..()

// CORVAX EDIT REMOVAL - The old active timewarper scan is replaced by passive sensing and a read-only clock in modular_corvax/modules/temporis/code/hourglass.dm.

//RECURRING CONTEMPLATION
/datum/discipline_power/temporis/recurring_contemplation
	name = "Ретроспектива"
	desc = "Заставьте жертву раз за разом повторять одни и те же действия."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 0 //You *can* spend a BP to boost this, but it'd extend time to hours or a day.

	hostile = TRUE
	frenzy_usable = FALSE

	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/recurring_contemplation/activate(mob/living/target)
	. = ..()
	target.AddComponent(/datum/component/dejavu, rewinds = 4, interval = 2 SECONDS)

//LEADEN MOMENT
/datum/discipline_power/temporis/leaden_moment
	name = "Замедление времени"
	desc = "Замедлите время вокруг противника - он едва сможет двигаться."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7

	hostile = TRUE

	multi_activate = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/leaden_moment/activate(mob/living/target)
	. = ..()
	to_chat(target, span_userdanger("<b>Медленнее.</b>"))
	target.add_movespeed_modifier(/datum/movespeed_modifier/temporis)

/datum/discipline_power/temporis/leaden_moment/deactivate(mob/living/target)
	. = ..()
	target.remove_movespeed_modifier(/datum/movespeed_modifier/temporis)

/datum/movespeed_modifier/temporis
	multiplicative_slowdown = 7.5

//PATIENCE OF THE NORNS
/datum/discipline_power/temporis/patience_of_the_norns
	name = "Терпение Норн"
	desc = "Будьте в нескольких местах сразу: вокруг возникают ваши ложные образы."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE
	frenzy_usable = FALSE

	cancelable = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/patience_of_the_norns/activate()
	. = ..()
	var/matrix/initial_matrix = matrix(owner.transform)
	var/matrix/secondary_matrix = matrix(owner.transform)
	var/matrix/tertiary_matrix = matrix(owner.transform)
	initial_matrix.Translate(1,0)
	secondary_matrix.Translate(0,1)
	tertiary_matrix.Translate(1)
	animate(owner, transform = initial_matrix, time = 1 SECONDS, loop = 0)
	animate(owner, transform = secondary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	animate(owner, transform = tertiary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/patience_of_the_norns/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/patience_of_the_norns/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	new /obj/effect/temporis/patience_of_the_norns(owner.loc, owner)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "двигается с нечеловеческой скоростью") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

//CLOTHOS GIFT
/datum/discipline_power/temporis/clothos_gift
	name = "Дар Клото"
	desc = "Ускорьте собственное время и станьте во много раз быстрее."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 3

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/clothos_gift/activate()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/temporis5)
	owner.next_move_modifier *= 0.25
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/clothos_gift/deactivate()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/temporis5)
	owner.next_move_modifier /= 0.25
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/clothos_gift/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	new /obj/effect/temporis/clothos_gift(owner.loc, owner)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION, "двигается с нечеловеческой скоростью") // CORVAX EDIT CHANGE - Player Masquerade Witness - Original: SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

/datum/movespeed_modifier/temporis5
	multiplicative_slowdown = -2.5
