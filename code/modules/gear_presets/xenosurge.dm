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
	total_positions = 8
	spawn_positions = 8
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/base
	entry_message_intro = "You are a <b>Marine Operator</b> serving as part of the <b>United Expeditionary Response</b> formation."
	entry_message_body = "You have been hand-picked after volunteering by your original armed formation to <b>take part in the UER’s first mission on LV-624.</b> Whether you truly believe the ideas of humanity joining forces to fight outside threats, see the UER as a stepping stone for your career back home, or have other reasons for wanting to be a part of this force, you have spent the last months under intensive training getting to know both the joint protocols that the UER uses as well as some of your new formation-mates."
	entry_message_end = "You have been assigned to one of the <b>Force Recon</b> teams serving on the <b>UAS Arrowhead</b>. With your squad mates, you will participate in reconnaissance and scouting operations, as well as assist in delicate information, personnel and equipment securing and retrieval operations. <b>Good luck!</b>"

/datum/equipment_preset/pve/base
	name = "UER Marine Operator"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE
	rank = JOB_UER_MARINE
	faction = FACTION_MARINE
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

/obj/effect/landmark/start/marine/pve/base/
	name = JOB_UER_MARINE
	icon_state = "smartgunner_spawn"
	job = /datum/job/marine/pve/base

/obj/effect/landmark/start/marine/pve/base/squad1
	icon_state = "smartgunner_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/pve/base/squad2
	icon_state = "smartgunner_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/pve/point
	title = JOB_UER_MARINE_POINT
	total_positions = 2
	spawn_positions = 2
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/point
	entry_message_intro = "You are a <b>Marine Point</b> serving as part of the <b>United Expeditionary Response</b> formation."
	entry_message_body = "You have been hand-picked after volunteering by your original armed formation to <b>take part in the UER’s first mission on LV-624.</b> Whether you truly believe the ideas of humanity joining forces to fight outside threats, see the UER as a stepping stone for your career back home, or have other reasons for wanting to be a part of this force, you have spent the last months under intensive training getting to know both the joint protocols that the UER uses as well as some of your new formation-mates."
	entry_message_end = "You have been assigned to one of the <b>Force Recon</b> teams serving on the <b>UAS Arrowhead</b>. With your squad mates, you will participate in reconnaissance and scouting operations, as well as assist in delicate information, personnel and equipment securing and retrieval operations. <b>Good luck!</b>"

/datum/equipment_preset/pve/point
	name = "UER Marine Point"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE_POINT
	rank = JOB_UER_MARINE_POINT
	faction = FACTION_MARINE
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


/obj/effect/landmark/start/marine/pve/point/
	name = JOB_UER_MARINE_POINT
	icon_state = "spec_spawn"
	job = /datum/job/marine/pve/point

/obj/effect/landmark/start/marine/pve/point/squad1
	icon_state = "spec_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/pve/point/squad2
	icon_state = "spec_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/pve/lead
	title = JOB_UER_MARINE_LEAD
	total_positions = 2
	spawn_positions = 2
	supervisors = "Mission Control"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/pve/lead
	entry_message_intro = "You are a <b>Marine Team Lead</b> serving as part of the <b>United Expeditionary Response</b> formation."
	entry_message_body = "You have been hand-picked after volunteering by your original armed formation to <b>take part in the UER’s first mission on LV-624.</b> Whether you truly believe the ideas of humanity joining forces to fight outside threats, see the UER as a stepping stone for your career back home, or have other reasons for wanting to be a part of this force, you have spent the last months under intensive training getting to know both the joint protocols that the UER uses as well as some of your new formation-mates."
	entry_message_end = "You have been assigned to one of the <b>Force Recon</b> teams serving on the <b>UAS Arrowhead</b>. With your squad mates, you will participate in reconnaissance and scouting operations, as well as assist in delicate information, personnel and equipment securing and retrieval operations. <b>Good luck!</b>"

/datum/equipment_preset/pve/lead
	name = "UER Marine Lead"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_MARINE_LEAD
	rank = JOB_UER_MARINE_LEAD
	faction = FACTION_MARINE
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

/obj/effect/landmark/start/marine/pve/lead/
	name = JOB_UER_MARINE_LEAD
	icon_state = "leader_spawn"
	job = /datum/job/marine/pve/lead

/obj/effect/landmark/start/marine/pve/lead/squad1
	icon_state = "leader_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/pve/lead/squad2
	icon_state = "leader_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/pve/pilot_npc
	title = JOB_UER_PO
	total_positions = 0
	spawn_positions = 0
	supervisors = "Mission Control"
	gear_preset = /datum/equipment_preset/pve/pilot_npc
	entry_message_body = "haha"

/datum/equipment_preset/pve/pilot_npc
	name = "UER Marine Lead"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_UER_PO
	rank = JOB_UER_PO
	faction = FACTION_MARINE
	paygrade = "NO3"
	role_comm_title = "PO"
	skills = /datum/skills/pve/standard

/datum/equipment_preset/pve/pilot_npc/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/po(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/pilot(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/pilot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
