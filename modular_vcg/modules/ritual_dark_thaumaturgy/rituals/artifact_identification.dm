/obj/ritual_rune/dark/identification
	name = "occult items identification"
	ru_name = "Опознание оккультных предметов"
	desc = "Раскрывает природу одного оккультного предмета."
	icon_state = "rune4"
	word = "COGN'ITIO"
	cost = 1

/obj/ritual_rune/dark/identification/complete()
	. = ..()
	for(var/obj/item/occult_artifact/artifact in loc)
		var/mob/living/carbon/human/identifier = usr
		if(artifact.identified)
			to_chat(identifier, span_warning("Этот артефакт уже опознан."))
			return
		artifact.identify()
		qdel(src)
