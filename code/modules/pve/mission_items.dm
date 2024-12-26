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
	var/operation_started = 0

/obj/structure/transmitter_base/proc/upload()
	icon_state = "tower_on"
	emoteas("activates and starts to hum loudly")
	sleep(200)
	name = "CASSANDRA"
	langchat_color = "#910030"
	talkas("He knows you are here! Step away from the transponder!")
	name = initial(name)
	langchat_color = initial(langchat_color)

/obj/structure/transmitter_base/attack_hand(mob/user)
	var/area/current_area = get_area(src)
	if(operation_started == 0 || (GLOB.boss_stage == GLOB.boss_stage_max))
		to_chat(usr, SPAN_INFO("The device does not respond to any inputs and seems inactive."))
		return
	if(tgui_alert(usr,"The device is unlocked, and the transfer is ready. You may press any key to initiate the process. This may attract unwanted attention.","Start Transfer?",list("Any","CANCEL"),timeout = 0) == "Any")
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(world, SPAN_WARNING("A Transponder is activate in [current_area]!"))
