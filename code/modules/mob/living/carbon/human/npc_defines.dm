/mob/living/carbon/human/npc

	//talking npc identifier to limit speaking picker

	var/talking_npc = 0

	//Npc master control

	var/datum/npc/npc_datum

/mob/living/carbon/human/npc/proc/InitializeNPCDatum()
	npc_datum = new /datum/npc/(human = src)

/mob/living/carbon/human/npc/proc/NPCWalk()
	if(!npc_datum)
		to_chat(usr, SPAN_WARNING("NPC Control datum not initalized. Call InitializeNPCDatum first."))
		return
	var/npc_walk_group = tgui_input_text(usr, "Enter name of waypoint group for this NPC to follow", "Waypoint name", timeout = 0)
	if(npc_walk_group == null) return
	var/direction_choice = tgui_alert(usr, "Select order of waypoints", "Direction input",list("Forward","Backward"), timeout = 0)
	if(direction_choice == null) return
	if(direction_choice == "Forward") direction_choice = 1
	if(direction_choice == "Backward") direction_choice = 2
	npc_datum.WalkDesignate(npc_walk_group,direction_choice)
	return

/mob/living/carbon/human/npc/Destroy()
	if(npc_datum)
		npc_datum.current_nav_point = null
	. = ..()
