/datum/equipment_preset/clf
	name = FACTION_CLF
	languages = LANGUAGE_ENGLISH
	assignment = JOB_COLONIST
	rank = FACTION_CLF
	faction = FACTION_CLF
	origin_override = ORIGIN_CIVILIAN
	idtype = /obj/item/card/id/lanyard

/datum/equipment_preset/clf/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE)

/datum/equipment_preset/clf/load_name(mob/living/carbon/human/new_human, randomise)

/datum/equipment_preset/uscm/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	var/static/list/hair_colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "AUBURN" = list(77, 48, 36), "BLONDE" = list(95, 76, 44))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	if(new_human.gender == MALE)
		new_human.h_style = pick("Undercut", "Partly Shaved", "Side Undercut", "Side Hang Undercut (Reverse)", "Undercut, Top", "Medium Fade", "High Fade", "Coffee House Cut")
		new_human.f_style = pick("Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		new_human.h_style = pick("Side Undercut", "Side Hang Undercut (Reverse)", "Undercut, Top", "CIA", "CIA","Mulder", "Pixie Cut Left", "Pixie Cut Right", "Bun")
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,50)

//*****************************************************************************************************/

/datum/equipment_preset/clf/soldier
	name = "Insurgent - Guerilla"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Class C Inhabitant"
	rank = JOB_CLF

	skills = /datum/skills/clf

/datum/equipment_preset/clf/soldier/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	var/random_gear = rand(1,6)
	switch(random_gear)
		if(1)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/grey(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(new_human), WEAR_JACKET)
		if(2)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/offwhite(new_human), WEAR_BODY)
		if(3)
		if(4)

		if(5)

		if(6)
//*****************************************************************************************************/

/datum/equipment_preset/clf/specialist
	name = "CLF - RPG"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Class C Inhabitant"
	rank = JOB_CLF_SPECIALIST
	skills = /datum/skills/clf/specialist

/datum/equipment_preset/clf/specialist/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CLF_ARMORY)

/datum/equipment_preset/clf/specialist/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(1,6)
	switch(random_gear)
		if(1)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/grey(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/pilot(new_human), WEAR_JACKET)
		if(2)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/offwhite(new_human), WEAR_BODY)
		if(3)
		if(4)

		if(5)

		if(6)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/cct(new_human), WEAR_L_EAR)
	//standard backpack stuff
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	//specialist backpack stuff
	new_human.equip_to_slot_or_del(new /obj/item/prop/folded_anti_tank_sadar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/ears/earmuffs(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)

	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(new_human), WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(new_human), WEAR_IN_BACK)
		spawn_rebel_specialist_weapon(new_human, 10)
	else
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(new_human), WEAR_IN_JACKET)
		spawn_weapon(/obj/item/weapon/gun/lever_action/r4t, /obj/item/ammo_magazine/handful/lever_action, new_human)

//*****************************************************************************************************/

/datum/equipment_preset/clf/leader
	name = "Insurgent - Armed"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Class C Inhabitant"
	rank = JOB_CLF_LEADER
	skills = /datum/skills/clf/leader

/datum/equipment_preset/clf/leader/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_BASE) + list(ACCESS_CLF_ARMORY, ACCESS_CLF_LEADERSHIP, ACCESS_CLF_FLIGHT)

/datum/equipment_preset/clf/leader/load_gear(mob/living/carbon/human/new_human)

	//No random armor, so that it's more clear that he's the leader
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/grey(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine(new_human), WEAR_WAIST)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/mar40, /obj/item/ammo_magazine/rifle/mar40, new_human)

//*****************************************************************************************************/

/datum/equipment_preset/clf/synth
	name = "CLF Multipurpose Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = ALL_SYNTH_LANGUAGES

	skills = /datum/skills/colonial_synthetic
	assignment = "Class C Inhabitant"
	rank = JOB_CLF_SYNTH

/datum/equipment_preset/clf/synth/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_ALL)

/datum/equipment_preset/clf/synth/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(prob(10))
		random_name = "[capitalize(randomly_generate_japanese_word(rand(2, 3)))]"
	else if(new_human.gender == MALE)
		random_name = "[pick(first_names_male_clf)]"
	else
		random_name = "[pick(first_names_female_clf)]"

	if(new_human.gender == MALE)
		new_human.f_style = "5 O'clock Shadow"

	new_human.change_real_name(new_human, random_name)
	new_human.r_hair = 15
	new_human.g_hair = 15
	new_human.b_hair = 25
	new_human.r_eyes = 139
	new_human.g_eyes = 62
	new_human.b_eyes = 19
	idtype = /obj/item/card/id/data

/datum/equipment_preset/clf/synth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COLONY_GEN_ONE)

/datum/equipment_preset/clf/synth/load_gear(mob/living/carbon/human/new_human)
	load_name(new_human)
	var/obj/item/clothing/under/boiler/grey/CLF = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	CLF.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(CLF, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/mar40/carbine, /obj/item/ammo_magazine/rifle/mar40/extended, new_human, 0, 10)

	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/bayonet/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_R_STORE)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/clf/commander
	name = "CLF - Cell Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Class C Inhabitant"
	rank = JOB_CLF_COMMANDER
	skills = /datum/skills/clf/commander

/datum/equipment_preset/clf/commander/New()
	. = ..()
	access = get_access(ACCESS_LIST_CLF_ALL)

/datum/equipment_preset/clf/commander/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/boiler/grey(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia/smartgun(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba/highimpact(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/mateba/highimpact(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/clf(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/clf/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
