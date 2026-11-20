/obj/item/organ/heart/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 20, "organ", TRUE, -1, 0)
