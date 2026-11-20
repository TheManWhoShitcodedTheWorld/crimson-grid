/obj/item/organ/vocal_cords/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 15, "organ", TRUE, -1, 0)
