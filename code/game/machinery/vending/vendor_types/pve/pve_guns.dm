/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/guns
	name = "\improper UAR Automated Weapons Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "req_guns"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/guns/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/guns/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", 20, /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", 20, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", 20, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 20, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),
		list("XM88 Heavy Rifle", 20, /obj/item/weapon/gun/lever_action/xm88, VENDOR_ITEM_REGULAR),
		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", 20, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", 20, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", 20, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_RECOMMENDED),
		list("M82F Flare Gun", 20, /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),
		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", 20, /obj/item/attachable/bayonet, VENDOR_ITEM_RECOMMENDED),
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/attachies
	name = "\improper UAR Automated Weapon Attachments Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "req_attach"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/attachies/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/attachies/populate_product_list(scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Extended Barrel", 20, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", 20, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 20, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", 20, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("Magnetic Harness", 20, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 20, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 20, /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", 20, /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", 20, /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", 20, /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),
		list("XS-9 targeting relay", 20, /obj/item/attachable/scope/mini/xm88, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", 20, /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", 20, /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 20, /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 20, /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 20, /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", 20, /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", 20, /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", 20, /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 20, /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", 20, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("Underslung Grenade Launcher", 20, /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 20, /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("STOCK", -1, null, null),
		list("M37 Wooden Stock", 20, /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 Arm Brace", 20, /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 Folding Stock", 20, /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M39 Stock", 20, /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", 20, /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M41A Folding Stock", 20, /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("M44 Magnum Sharpshooter Stock", 20, /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR),
		list("XM88 padded stock", 20, /obj/item/attachable/stock/xm88, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/extra_munitions/
	name = "\improper UAR Automated Explosive, Incendiary and Support Munitions Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "gear"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/extra_munitions/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/extra_munitions/populate_product_list(scale)
	listed_products = list(
		list("LAUNCHERS/FLAMETHROWERS", -1, null, null),
		list("M240 Incinerator Unit", 20, /obj/item/storage/box/guncase/flamer, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", 100, /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M79 Grenade Launcher", 20, /obj/item/storage/box/guncase/m79, VENDOR_ITEM_REGULAR),
		list("EXPLOSIVES", -1, null, null),
		list("M15 Fragmentation Grenade", 20, /obj/item/explosive/grenade/high_explosive/m15, VENDOR_ITEM_REGULAR),
		list("M20 Claymore Anti-Personnel Mine", 20, /obj/item/explosive/mine, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade", 20, /obj/item/explosive/grenade/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Grenade", 20, /obj/item/explosive/grenade/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Smoke Grenade", 20, /obj/item/explosive/grenade/phosphorus, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Grenade", 20, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Grenade", 20, /obj/item/explosive/grenade/high_explosive/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Icendiary Airburst Grenade", 20, /obj/item/explosive/grenade/incendiary/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Grenade", 20, /obj/item/explosive/grenade/smokebomb/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Star Shell", 20, /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Shell", 20, /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		list("M40 HIRR Baton Slug", 20, /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 20, /obj/item/explosive/grenade/metal_foam, VENDOR_ITEM_REGULAR),
		list("Plastic Explosives", 20, /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 20, /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo/
	name = "\improper UAR Automated Ammunition Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "req_ammo"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/ammo/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box Of Buckshot Shells", 200, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells", 200, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs", 200, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24mm)", 200, /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M4RA AP Magazine (10x24mm)", 200, /obj/item/ammo_magazine/rifle/m4ra/ap, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK2 Magazine (10x24mm)", 200, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M41A MK2 AP Magazine (10x24mm)", 200, /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK2 Extended Magazine (10x24mm)", 200, /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", 200, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 200, /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_RECOMMENDED),
		list("M39 Extended Magazine (10x20mm)", 200 + 3, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("XM88 .458 bullets box (.458 x 300)", 200, /obj/item/ammo_magazine/lever_action/xm88, VENDOR_ITEM_REGULAR),
		list("SECONDARY AMMUNITION", -1, null, null),
		list("M44 Speed Loader (.44)", 200, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 200, /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 200, /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", 200, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", 200, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 HP Magazine (9mm)", 200, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("88 Mod 4 Magazine (9mm)", 200, /obj/item/ammo_magazine/pistol/mod88/normalpoint, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/accesories/
	name = "\improper UAR Automated Accesories Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "intel_gear"
	req_access = list()
	req_one_access = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/accesories/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pve/accesories/populate_product_list(scale)
	listed_products = list(
		list("WEBBINGS", -1, null, null),
		list("Black Webbing Vest", 20, /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 20, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 20, /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),
		list("Webbing", 20, /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Knife Webbing", 20, /obj/item/clothing/accessory/storage/knifeharness, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 20, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Lightweight IMP Backpack", 20, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 20, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("Pyrotechnician G4-1 Fueltank", 20, /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", 20, /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Mortar Shell Backpack", 20, /obj/item/storage/backpack/marine/mortarpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", 20, /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("IMP Ammo Rack", 20, /obj/item/storage/backpack/marine/ammo_rack, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Pack", 20, /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),
		list("Parachute", 20, /obj/item/parachute, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("G8-A General Utility Pouch", 20, /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 20, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 20, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig", 20, /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 20, /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 20, /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 20, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 20, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 20, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Mortar Operator Belt", 20, /obj/item/storage/belt/gun/mortarbelt, VENDOR_ITEM_REGULAR),
		list("M300 pattern .458 SOCOM loading rig", 20, /obj/item/storage/belt/shotgun/xm88, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
		list("Autoinjector Pouch", 20, /obj/item/storage/pouch/autoinjector, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 20, /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Full)", 20, /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 20, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Syringe Pouch", 20, /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 20, /obj/item/storage/pouch/tools/full, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 20, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch", 20, /obj/item/storage/pouch/electronics, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 20, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 20, /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 20, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 20, /obj/item/storage/pouch/machete/full, VENDOR_ITEM_REGULAR),
		list("Bayonet Pouch", 20, /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 20, /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 20, /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 20, /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 20, /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 20, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 20, /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 20, /obj/item/storage/pouch/general/large, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 20, /obj/item/storage/pouch/magazine/large, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 20, /obj/item/storage/pouch/shotgun/large, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("TacMap Viewer", 20, /obj/item/tacmap_view, VENDOR_ITEM_RECOMMENDED),
		list("Combat Flashlight", 20, /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 20, /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 20, /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", 20, /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 20, /obj/item/device/motiondetector, VENDOR_ITEM_REGULAR),
		list("Binoculars", 20, /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 20, /obj/item/device/binoculars/range, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 20, /obj/item/device/binoculars/range/designator, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 20, /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 20, /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		)








