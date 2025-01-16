/obj/structure/transmitter_base
	name = "GS-13 Emergency Data Siphon"
	desc = "A long-term battery powered machine with what looks like multiple hard drives connected to a rather imposing looking antenna. Marked as property of Weyland-Yutani."
	desc_lore = "A standard in Weyland-Yutani facilities, these devices collect information from computer systems in case of an emergency and store it for retrieval by qualified W-Y techs."
	icon = 'icons/Surge/items/tower.dmi'
	icon_state = "tower"
	anchored = 1
	indestructible = 1
	unslashable = 1
	unacidable = 1
	layer = ABOVE_MOB_LAYER
	var/operation_started = 0

/obj/structure/transmitter_base/proc/upload()
	operation_started = 1
	icon_state = "tower_on"
	emoteas("activates and starts to hum loudly")
	update_icon()
	sleep(200)
	name = "CASSANDRA"
	langchat_color = "#910030"
	talkas("He knows you are here! Step away from the transponder!")
	name = initial(name)
	langchat_color = initial(langchat_color)
	sleep(50)
	icon_state = "tower"
	update_icon()
	emoteas("fizzes and shuts down")
	sleep(20)
	var/current_turf = get_turf(src)
	new /mob/living/pve_boss/missle_bot/(current_turf)

/obj/structure/transmitter_base/attack_hand(mob/user)
	var/area/current_area = get_area(src)
	if(operation_started == 1 || (GLOB.boss_stage == GLOB.boss_stage_max))
		to_chat(usr, SPAN_INFO("The device does not respond to any inputs and seems inactive."))
		return
	if(tgui_alert(usr,"The device is unlocked, and the transfer is ready. You may press any key to initiate the process. This may attract unwanted attention.","Start Transfer?",list("Any","CANCEL"),timeout = 0) == "Any")
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(world, SPAN_WARNING("A Transponder is activate in [current_area]!"))
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/transmitter_base/,upload))
	return

/obj/structure/evac_terminal
	name = "Landing Bay control"
	desc = "A red computer terminal with 'Landing Bay' written on the side."
	icon = 'icons/Surge/items/computer.dmi'
	icon_state = "comp"
	anchored = 1
	indestructible = 1
	unslashable = 1
	unacidable = 1
	layer = ABOVE_MOB_LAYER
	var/global/operation_started = 0

/obj/structure/evac_terminal/proc/spawn_boss()
	var/area/current_area = get_area(src)
	var/picked_landmark = null
	for (var/obj/effect/landmark/pve_boss_navigation/boss_landmark in current_area.boss_waypoints)
		if(boss_landmark.id_tag == "center")
			picked_landmark = boss_landmark
			break
	if(picked_landmark == null)
		picked_landmark = pick(current_area.boss_waypoints)
	if(picked_landmark == null)
		message_admins("Warning: No boss waypoint found in [current_area]! Boss spawning aborted.")
		return
	var/turf/picked_turf = get_turf(picked_landmark)
	new /mob/living/pve_boss/missle_bot/(picked_turf)


/obj/structure/evac_terminal/attack_hand(mob/user)
	var/area/current_area = get_area(src)
	if(operation_started == 1 || (GLOB.boss_stage != GLOB.boss_stage_max))
		to_chat(usr, SPAN_INFO("The terminal does not respond to any inputs."))
		return
	if(icon_state == "comp")
		icon_state = "comp_on"
		update_icon()
	if(tgui_alert(usr,"The terminal is ready to initiate evacuation.","Start Evacuation?",list("Yes","CANCEL"),timeout = 0) == "Yes")
		if(tgui_alert(usr,"ARE YOU SURE? This will begin the last phase of the round.","Start Evacuation?",list("Yes","CANCEL"),timeout = 0) == "Yes")
			if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				operation_started = 1
				to_chat(world, SPAN_WARNING("Evacuation was called in from [current_area]!"))
				INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/evac_terminal/,spawn_boss))
		return
