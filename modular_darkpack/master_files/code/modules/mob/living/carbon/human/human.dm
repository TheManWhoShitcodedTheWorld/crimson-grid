/mob/living/carbon/human/Topic(href, href_list)
	// DARKPACK TODO - reimplement in a sane way.
	if(href_list["masquerade_violation"])
		/* CORVAX EDIT REMOVAL START - Player Masquerade Witness
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(IS_UNCONSCIOUS_OR_CRIT(reporter))
			return
		if(usr == src)
			return
		var/reason = tgui_input_text(reporter, "Опишите, что именно вы увидели", "Заметить нарушение Маскарада", null, MAX_MESSAGE_LEN)
		if(!reason)
			return
		reason = sanitize(reason)
		if(!SEND_SIGNAL(reporter, COMSIG_SEEN_MASQUERADE_VIOLATION, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		log_game("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		to_chat(src, span_danger("Вас уличили в нарушении Маскарада: [reason]"))
		CORVAX EDIT REMOVAL END - Player Masquerade Witness */
		// CORVAX EDIT ADD START - Player Masquerade Witness
		var/mob/living/carbon/human/reporter = usr
		if(!istype(reporter) || reporter == src)
			return
		var/report_block_reason = reporter.masquerade_report_blocker(src, check_sight = TRUE)
		if(report_block_reason)
			to_chat(reporter, span_warning(report_block_reason))
			return
		var/reason = tgui_input_text(reporter, "Опишите, что именно вы увидели", "Заметить нарушение Маскарада", null, MAX_MESSAGE_LEN)
		if(!reason)
			return
		reporter.report_masquerade_violation(src, sanitize(reason), check_sight = TRUE)
		// CORVAX EDIT ADD END - Player Masquerade Witness

	if(href_list["masquerade_reinforcement"])
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(IS_UNCONSCIOUS_OR_CRIT(reporter))
			return
		if(usr == src)
			return
		if(!SEND_SIGNAL(reporter, COMSIG_MASQUERADE_REINFORCE, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")
		log_game("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")


	. = ..()

