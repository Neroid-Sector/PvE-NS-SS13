/client/proc/setup_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Setup"
	set desc = "Sets parameters for next wave surge."

	if(!check_rights(R_ADMIN))
		return
	var/surge_setup_value
	switch(tgui_input_list(usr, "Max:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]", "SURGE SETUP CHOICE", list("Global Xeno Limit","Number of Surge","Number of Veteran Surge","Veteran Surge Type")))
		if(null)
			return
		if("Global Xeno Limit")
			surge_setup_value = tgui_input_number(usr, "Pick maximum xenos at once. This is a global control to prevent lag. Generally suggest leaving this alone.", "SURGE SETUP GLOBAL XENOS",GLOB.xenosurge_spawner_limit,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_limit = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Number of Surge")
			surge_setup_value = tgui_input_number(usr, "Xenos to spawn in the wave", "SURGE SETUP SURGE NO",GLOB.xenosurge_wave_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_max = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Number of Veteran Surge")
			surge_setup_value = tgui_input_number(usr, "Xenos to spawn in the wave", "SURGE SETUP VETERAN NO",GLOB.xenosurge_veteran_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_veteran_xenos_max = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Veteran Surge Type")
			surge_setup_value = tgui_input_list(usr, "1 - Pusher\n2 - Amubsher\n3 - Breaker\n4 - Random", "SURGE SETUP VETERAN MOB",list(1,2,3,4),timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_veteran_type = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))

/client/proc/setup_surge_globals()
	set category = "DM.Xenosurge"
	set name = "Surge - Globals Setup"
	set desc = "Accesses Surge Globals."

	if(!check_rights(R_ADMIN))
		return
	var/surge_setup_value
	switch(tgui_input_list(usr, "Max:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]", "ADVANCED SURGE SETUP CHOICE", list("Global Xeno Limit","Number of Surge Xenos","Factors","Spawn List")))
		if(null)
			return
		if("Regular HP")
			surge_setup_value = tgui_input_number(usr, "Regular Wave HP", "REGULAR WAVE HP",GLOB.xenosurge_wave_xenos_hp,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_hp = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular ARMOR")
			surge_setup_value = tgui_input_number(usr, "Regular Wave Armor", "REGULAR WAVE ARMOR",GLOB.xenosurge_wave_xenos_armor,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_armor = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular DAM MIN")
			surge_setup_value = tgui_input_number(usr, "Regular Damage Min", "REGULAR DAM MIN",GLOB.xenosurge_wave_xenos_dam_min,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_dam_min = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular DAM MAX")
			surge_setup_value = tgui_input_number(usr, "Regular Damage Max", "REGULAR DAM MAX",GLOB.xenosurge_wave_xenos_dam_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_dam_max = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular Spawner Xenos")
			surge_setup_value = tgui_input_number(usr, "Regular Spawner Xenos spawned per spawning loop", "REGULAR SPAWNER XENOS",GLOB.xenosurge_spawner_xenos,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_xenos = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular Spawner Dealy")
			surge_setup_value = tgui_input_number(usr, "Regular Spawner Delay between loops", "REGULAR SPAWNER DELAY",GLOB.xenosurge_spawner_delay,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_delay = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Regular Spawner Variance")
			surge_setup_value = tgui_input_number(usr, "Regular Spawner Loop Spawn Variance", "REGULAR SPAWNER VARIANCE",GLOB.xenosurge_spawner_variance,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_variance = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Veteran Spawner Xenos")
			surge_setup_value = tgui_input_number(usr, "Veteran Spawner Xenos spawned per spawning loop", "VETERAN SPAWNER XENOS",GLOB.xenosurge_veteran_spawner_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_veteran_spawner_xenos_max = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Veteran Spawner Dealy")
			surge_setup_value = tgui_input_number(usr, "Veteran Spawner Delay between loops", "VETERAN SPAWNER DELAY",GLOB.xenosurge_veteran_spawner_delay,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_veteran_spawner_delay = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Veteran Spawner Variance")
			surge_setup_value = tgui_input_number(usr, "Veteran Spawner Loop Spawn Variance", "VETERAN SPAWNER VARIANCE",GLOB.xenosurge_veteran_spawner_variance,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_veteran_spawner_variance = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))

	return
/client/proc/surge_status()
	set category = "DM.Xenosurge"
	set name = "Surge - Status"
	set desc = "Checks surge status"
	if(!check_rights(R_ADMIN))
		return
	if(GLOB.xenosurge_surge_started == 0)
		to_chat(usr, SPAN_INFO("Xenosurge nor started."))
	else
		to_chat(usr, SPAN_INFO("Xenosurge Ongoing!"))
	to_chat(usr, SPAN_INFO("Spawned Normal:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max], Veterans: [GLOB.xenosurge_wave_veteran_xenos_current] out of [GLOB.xenosurge_veteran_xenos_max]."))

/client/proc/start_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Start"
	set desc = "Checks critcial params, starts surge."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Start Xenosurge?\nMax:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]","START",list("Cancel","OK"), timeout = 0) == "OK")
		GLOB.xenosurge_surge_started = 1
		var/spawner_count = 0
		var/veteran_spawner_count = 0
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner == null)
				to_chat(usr, SPAN_WARNING("No spawner found. Aborted."))
				return
			if(spawner.spawner_initiated == TRUE)
				playsound(spawner, 'sound/voice/xenos_roaring.ogg', 80)
				spawner.start_spawning()
				spawner_count += 1
		to_chat(world, SPAN_WARNING("A roar echoes through the AO as the Surge locks in on a target!"))
		to_chat(usr, SPAN_INFO("Spawner activation complete. Spawners activated: [spawner_count] and [veteran_spawner_count] veterans."))
		message_admins("[usr] has activated a [spawner_count] spawner Xenosurge. Parameters: Max:[GLOB.xenosurge_spawner_limit], Xenos:[GLOB.xenosurge_wave_xenos_max]")

/client/proc/stop_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Stop"
	set desc = "Deinitalizes all spawners, stopping them."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Stop Xenosurge?","STOP",list("Cancel","OK"), timeout = 0) == "OK")
		GLOB.xenosurge_surge_started = 0
		GLOB.xenosurge_wave_xenos_current = 0
		GLOB.xenosurge_wave_veteran_xenos_current = 0		
		to_chat(world, SPAN_INFO("The end is in sight! The onslaught seems to be letting up!"))
		to_chat(usr, SPAN_INFO("All spawners have been deactivated, the surge is effectively stopped."))

/client/proc/remove_spawners()
	set category = "DM.Xenosurge"
	set name = "Spawners - Remove All"
	set desc = "Removes all spawners."
	if(!check_rights(R_ADMIN))
		return

	if(tgui_alert(usr, "Confirm: Remove spawners?","START",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in world)
			qdel(spawner)
		GLOB.xenosurge_configured_spawners = list()
		GLOB.spawner_number = 1
		to_chat(usr, SPAN_INFO("Spawners removed and ID number reset."))

/client/proc/surge_preset_hp()
	set category = "DM.Xenosurge"
	set name = "Surge - Xeno HP and Damage"
	set desc = "Common use surge preset HP/attack values."
	if(!check_rights(R_ADMIN))
		return
	switch(tgui_input_list(usr, "Selecta a HP/ATTACK factor ratio:","SURGE",list("Fodder","Very Weak","Weak","Normal","Strong","Very Strong"), timeout = 0, default = "Normal"))
		if(null)
			return
		if("Fodder")
			GLOB.xenosurge_wave_xenos_hp = 50
			GLOB.xenosurge_wave_xenos_armor = 0
			GLOB.xenosurge_wave_xenos_dam_min = 5
			GLOB.xenosurge_wave_xenos_dam_max = 7
		if("Very Weak")
			GLOB.xenosurge_wave_xenos_hp = 100
			GLOB.xenosurge_wave_xenos_armor = 0
			GLOB.xenosurge_wave_xenos_dam_min = 5
			GLOB.xenosurge_wave_xenos_dam_max = 8
		if("Weak")
			GLOB.xenosurge_wave_xenos_hp = 150
			GLOB.xenosurge_wave_xenos_armor = 0
			GLOB.xenosurge_wave_xenos_dam_min = 5
			GLOB.xenosurge_wave_xenos_dam_max = 9
		if("Normal")
			GLOB.xenosurge_wave_xenos_hp = 200
			GLOB.xenosurge_wave_xenos_armor = 0
			GLOB.xenosurge_wave_xenos_dam_min = 5
			GLOB.xenosurge_wave_xenos_dam_max = 10
		if("Strong")
			GLOB.xenosurge_wave_xenos_hp = 250
			GLOB.xenosurge_wave_xenos_armor = 20
			GLOB.xenosurge_wave_xenos_dam_min = 7
			GLOB.xenosurge_wave_xenos_dam_max = 10
		if("Very Strong")
			GLOB.xenosurge_wave_xenos_hp = 300
			GLOB.xenosurge_wave_xenos_armor = 20
			GLOB.xenosurge_wave_xenos_dam_min = 9
			GLOB.xenosurge_wave_xenos_dam_max = 12

/client/proc/create_surge_spawner(turf/T in turfs)
	set name = "Create Surge Spawner"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	new /obj/structure/xenosurge_spawner(T)
	return
