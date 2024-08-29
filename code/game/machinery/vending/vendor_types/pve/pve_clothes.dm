/obj/structure/machinery/cm_vending/clothing/pve/standard
	name = "\improper UAR Personal Uniform Rack"
	desc = "A secure personal uniform storage sollution, much like the bigger dispensers, but linked to a smaller, local storage"
	req_access = list()
	vendor_role = list()
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_UNIFORM_AUTOEQUIP

/obj/structure/machinery/cm_vending/pve/standard/get_listed_products(mob/user)
	return list(
	list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
	list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
	list("Headset", 0, /obj/item/device/radio/headset/almayer/mmpo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
	list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
	list("UNIFORM (CHOOSE 1)", 0, null, null, null),
	list("Standard", 0, /obj/item/clothing/under/marine/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Medic", 0, /obj/item/clothing/under/marine/medic/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Engineer", 0, /obj/item/clothing/under/marine/engineer/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Engineer - alternative", 0, /obj/item/clothing/under/marine/engineer/darker, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Radio Officer", 0, /obj/item/clothing/under/marine/rto/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Sniper", 0, /obj/item/clothing/under/marine/sniper/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Vehicle Operator", 0, /obj/item/clothing/under/marine/tanker/standard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	)

/obj/structure/machinery/cm_vending/sorted/pve/uniform
	name = "\improper UAR Armor Vendor"
	desc = "An automated supply rack hooked up to a big storage of standard marine uniforms. Can be accessed by the Requisitions Officer and Cargo Techs."
	icon_state = "clothing"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_UNIFORM_AUTOEQUIP
	vendor_theme = VENDOR_THEME_USCM

	listed_products = list(

		list("STANDARD HELMETS", -1, null, null),
		list("M10 Pattern Marine Helmet - No camo", 20, /obj/item/clothing/head/helmet/marine/grey, VENDOR_ITEM_RECOMMENDED),
		list("M10 Pattern Marine Helmet - Jungle camo", 20, /obj/item/clothing/head/helmet/marine/jungle, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet - Snow camo", 20, /obj/item/clothing/head/helmet/marine/snow, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet - Desert camo", 20, /obj/item/clothing/head/helmet/marine/desert, VENDOR_ITEM_REGULAR),
		list("SPECIALIZED HELMETS", -1, null, null),
		list("M10 Pattern Technician Helmet", 20, /obj/item/clothing/head/helmet/marine/tech, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Corspman Helmet", 20, /obj/item/clothing/head/helmet/marine/medic, VENDOR_ITEM_REGULAR),
		list("STANDARD ARMOR", -1, null, null),
		list("M3 Pattern Carrier Marine Armor", 20, /obj/item/clothing/suit/storage/marine/carrier, VENDOR_ITEM_RECOMMENDED),
		list("M3 Pattern Padded Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padded, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padless Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Ridged Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless_lines, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Skull Marine Armor", 20, /obj/item/clothing/suit/storage/marine/skull, VENDOR_ITEM_REGULAR),
		list("SPECIALIZED ARMOR", -1, null, null),
		list("M3-EOD Pattern Heavy Armor", 20, /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 20, /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),
	)
