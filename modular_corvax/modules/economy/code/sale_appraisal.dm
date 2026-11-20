/datum/component/selling/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine_sale_value))

/datum/component/selling/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	return ..()

/datum/component/selling/proc/examine_sale_value(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!isliving(user))
		return
	var/mob/living/examiner = user
	if(examiner.st_get_stat(STAT_FINANCE) < 3 || !can_sell())
		return
	var/base_price = cost
	if(istype(parent, /obj/item/stack))
		var/obj/item/stack/stack = parent
		base_price *= stack.amount
	if(illegal)
		examine_list += span_notice("Предметом интересовались на чёрном рынке. Базовая стоимость - [base_price]$")
	else
		examine_list += span_notice("Предмет можно сдать в ломбард. Базовая стоимость - [base_price]$")
