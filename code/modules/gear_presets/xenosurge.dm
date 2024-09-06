/datum/skills/pve/standard
	name = "UER Marine Operator"
	skills = list(
		SKILL_CQC = SKILL_CQC_TRAINED,
		SKILL_ENGINEER = SKILL_ENGINEER_ENGI,
		SKILL_CONSTRUCTION = SKILL_CONSTRUCTION_ENGI,
		SKILL_OVERWATCH = SKILL_OVERWATCH_TRAINED,
		SKILL_MEDICAL = SKILL_MEDICAL_DOCTOR,
		SKILL_SURGERY = SKILL_SURGERY_TRAINED,
		SKILL_POLICE = SKILL_POLICE_SKILLED,
		SKILL_FIREMAN = SKILL_FIREMAN_SKILLED,
		SKILL_POWERLOADER = SKILL_POWERLOADER_MASTER,
		SKILL_JTAC = SKILL_JTAC_MASTER,
		SKILL_SPEC_WEAPONS = SKILL_SPEC_ALL,
		SKILL_INTEL = SKILL_INTEL_EXPERT,
		SKILL_ENDURANCE = SKILL_ENDURANCE_TRAINED,
	)

/datum/job/marine/pve/base
	title = JOB_UER_MARINE
	total_positions = 6
	spawn_positions = 6
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/base
	entry_message_body = "haha"



/datum/equipment_preset/pve/base
	name = "UER Marine Operator"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE
	rank = JOB_UER_MARINE
	paygrade = "ME3"
	role_comm_title = "OPR"
	skills = /datum/skills/pve/standard
	minimap_icon = "smartgunner"

/datum/equipment_preset/pve/base/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	var/obj/item/stim_injector/injector = new /obj/item/stim_injector(get_turf(new_human))
	new_human.bind_stimpack(injector)
	new_human.put_in_any_hand_if_possible(injector)


/datum/job/marine/pve/point
	title = JOB_UER_MARINE_POINT
	total_positions = 2
	spawn_positions = 2
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/point
	entry_message_body = "haha"

/datum/equipment_preset/pve/point
	name = "UER Marine Point"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE_POINT
	rank = JOB_UER_MARINE_POINT
	paygrade = "ME4"
	role_comm_title = "PNT"
	skills = /datum/skills/pve/standard
	minimap_icon = "spec"

/datum/equipment_preset/pve/point/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	var/obj/item/stim_injector/injector = new /obj/item/stim_injector(get_turf(new_human))
	new_human.bind_stimpack(injector)
	new_human.put_in_any_hand_if_possible(injector)

/datum/job/marine/pve/lead
	title = JOB_UER_MARINE_LEAD
	total_positions = 2
	spawn_positions = 2
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/lead
	entry_message_body = "haha"

/datum/equipment_preset/pve/lead
	name = "UER Marine Lead"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE_LEAD
	rank = JOB_UER_MARINE_LEAD
	paygrade = "ME5"
	role_comm_title = "TML"
	skills = /datum/skills/pve/standard
	minimap_icon = "leader"

/datum/equipment_preset/pve/lead/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	var/obj/item/stim_injector/injector = new /obj/item/stim_injector(get_turf(new_human))
	new_human.bind_stimpack(injector)
	new_human.put_in_any_hand_if_possible(injector)
