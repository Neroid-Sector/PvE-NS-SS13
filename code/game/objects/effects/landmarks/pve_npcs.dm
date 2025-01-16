/obj/effect/landmark/npc_spawner
	name = "NPC spawner"
	icon_state = "x2"
	var/npc_id = "none"
	var/equipment_path = /datum/equipment_preset/pve/pilot_npc
	var/npc_name = "John Doe"
	var/npc_chat_color = "#ffffff"
	var/gender_to_set = MALE
	var/Initialize_NPC = 1 // Set to 0 if for some reason this npc should not use the standard NPC datum. I can't really figure out why one would want to do this on this level, but seems like this should be a switch.

/obj/effect/landmark/npc_spawner/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(spawn_npc))
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/npc_spawner/Destroy()
	equipment_path = null
	return ..()

/obj/effect/landmark/npc_spawner/proc/spawn_npc()
	var/mob/living/carbon/human/npc/H = new(loc)
	H.setDir(dir)
	if(!H.hud_used)
		H.create_hud()
	arm_equipment(H, equipment_path, FALSE, FALSE)
	H.name = npc_name
	H.npc_id = npc_id
	H.langchat_color = npc_chat_color
	H.gender = gender_to_set
	H.talking_npc = 1
	H.wear_id.set_user_data(H)
	if(Initialize_NPC == 1)
		H.InitializeNPCDatum()
	for(var/obj/structure/bed/chair/chair in get_turf(H))
		if(chair != null)
			if(get_turf(chair) == get_turf(H))
				chair.do_buckle(H,H)
				break

/obj/effect/landmark/npc_spawner/pilot_left
	npc_id = "PO-Vasquez"
	npc_name = "Isabel 'Shrike' Vasquez"
	npc_chat_color = "#e40f3d"
	gender_to_set = FEMALE

/obj/effect/landmark/npc_spawner/pilot_right
	npc_id = "PO-Biggs"
	npc_name = "James 'Jim' Biggs"
	npc_chat_color = "#59eec9"
