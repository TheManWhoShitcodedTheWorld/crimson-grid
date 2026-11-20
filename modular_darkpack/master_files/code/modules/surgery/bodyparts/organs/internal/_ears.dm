/obj/item/organ/ears/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 10, "organ", TRUE, -1, 0)
