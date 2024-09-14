/obj/item/quest_item
	name = "quest item"
	desc = "Generic quest pickupable"
	icon = 'icons/obj/items/questitems.dmi'
	icon_state = "paper"
	w_class = SIZE_TINY
	var/item_found = 0
	var/quest_item_number = 0

/obj/item/quest_item/attack_hand(mob/user)
	if(item_found == 0)
		GLOB.quest_items_found += 1
		message_admins(SPAN_LARGE("[user] has found quest item [name] in [get_area_name(src)]. Quest item number: [quest_item_number]."))
		message_admins(SPAN_LARGE("Quest items found: [GLOB.quest_items_found] out of [GLOB.quest_items_number]."))
		item_found = 1
	. = ..()

/obj/item/quest_item/Initialize(mapload, ...)
	quest_item_number = GLOB.quest_items_number
	GLOB.quest_items_number += 1
	. = ..()

/obj/item/quest_item/disk
	name = "Weyland-Yutani Data Access Disk"
	desc = "An oversized data disk that bears the Weyland-Yutani logo on its label. Seems important."
	icon_state = "disk"
