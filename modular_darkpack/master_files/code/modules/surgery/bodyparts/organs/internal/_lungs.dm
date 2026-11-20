/obj/item/organ/lungs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 10, "organ", TRUE, -1, 0)
