/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 5, "organ", TRUE, -1, 0)
