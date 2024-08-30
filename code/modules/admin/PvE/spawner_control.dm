/client/proc/create_spawner()
	set category = "Xenosurge.Spawners"
	set name = "Spawners - Create"
	set desc = "Creates and launches configuration of a spawner at current location."

	if(!check_rights(R_ADMIN))
		return

	var/max_to_pass = tgui_input_number(usr, "How many xenos total from this spawner","Spawner Setup",5, timeout = 0)
	if(max_to_pass == null) return 0
	var/delay_to_pass = tgui_input_number(usr, "Dealy, in ticks (~10 a second) between spawn checks","Spawner Setup",100, timeout = 0)
	if(delay_to_pass == null) return 0
	var/type_to_pass = tgui_input_list(usr, "Xeno Type","Spawner Setup",list(XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_LURKER, XENO_CASTE_CRUSHER, XENO_CASTE_FACEHUGGER),timeout = 0, default = XENO_CASTE_DRONE)
	if(type_to_pass == null) return 0
	var/spawner_cycle
	spawner_cycle = tgui_alert(usr, "Move your ghost to the postion of the spawner and press OK. Cancel to cancel.","SPAWNER",list("Cancel","OK"), timeout = 0)
	while(spawner_cycle == "OK")
		var/turf/spawner_turf = mob.loc
		var/obj/structure/xenosurge_spawner/spawner = new(spawner_turf)
		if(spawner.setup_spawner(max = max_to_pass, delay = delay_to_pass, type = type_to_pass) == 0)
			to_chat(usr, SPAN_WARNING("Spawner not configured. Discarding."))
			qdel(spawner)
		spawner_cycle = tgui_alert(usr, "Move your ghost to the postion of the spawner and press OK. Cancel to cancel.","SPAWNER",list("Cancel","OK"), timeout = 0)
	return

/client/proc/setup_surge()
	set category = "Xenosurge.Spawners"
	set name = "Xenosurge - Setup"
	set desc = "Sets parameters for next wave surge."

	if(!check_rights(R_ADMIN))
		return
	var/surge_setup_value
	switch(tgui_input_list(usr, "Max:[GLOB.xenosurge_spawner_limit]\nWaves:[GLOB.xenosurge_wave_max]\nDelay:[GLOB.xenosurge_wave_delay]\nXenos:[GLOB.xenosurge_wave_xenos_max]", "SURGE", list("Max","Waves","Delay","Xenos")))
		if(null)
			return
		if("Max")
			surge_setup_value = tgui_input_number(usr, "Pick maximum xenos at once. This is a global control to prevent lag. Generally suggest leaving this alone.", "SURGE",GLOB.xenosurge_spawner_limit,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_limit = surge_setup_value
		if("Waves")
			surge_setup_value = tgui_input_number(usr, "Select ammount of WAVES", "SURGE",GLOB.xenosurge_wave_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_max = surge_setup_value
		if("Delay")
			surge_setup_value = tgui_input_number(usr, "Pick delay, in ticks (~10 per second), between waves.", "SURGE",GLOB.xenosurge_wave_delay,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_delay = surge_setup_value
		if("Xenos")
			surge_setup_value = tgui_input_number(usr, "Xenos to spawn per wave", "SURGE",GLOB.xenosurge_wave_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_max = surge_setup_value
	return

/client/proc/start_surge()
	set category = "Xenosurge.Spawners"
	set name = "Xenosurge - Start"
	set desc = "Checks critcial params, starts surge."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Start Xenosurge?","START",list("Cancel","OK"), timeout = 0) == "OK")
		var/spawner_count = 0
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner == null)
				to_chat(usr, SPAN_WARNING("No spawner found. Aborted."))
				return
			if(spawner.spawner_initiated == TRUE)
				spawner.start_spawning()
				spawner_count += 1
		to_chat(usr, SPAN_INFO("Spawner activation complete. Spawners activated: [spawner_count]."))
		log_admin("[usr] has activated a [spawner_count] spawner Xenosurge. Parameters: Max:[GLOB.xenosurge_spawner_limit], Waves:[GLOB.xenosurge_wave_max], Delay:[GLOB.xenosurge_wave_delay], Xenos:[GLOB.xenosurge_wave_xenos_max]")

/client/proc/stop_surge()
	set category = "Xenosurge.Spawners"
	set name = "Xenosurge - Stop"
	set desc = "Deinitalizes all spawners, stopping them."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Stop Xenosurge?","START",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner.spawner_initiated == TRUE)
				spawner.spawner_initiated = FALSE
		GLOB.xenosurge_wave_xenos_current = 0
		GLOB.xenosurge_wave_current = 0
		to_chat(usr, SPAN_INFO("All spawners have been deactivated, the surge is effectively stopped."))

/client/proc/remove_spawners()
	set category = "Xenosurge.Spawners"
	set name = "Spawners - Remove All"
	set desc = "Removes all spawners."
	if(!check_rights(R_ADMIN))
		return

	if(tgui_alert(usr, "Confirm: Remove spawners?","START",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in world)
			qdel(spawner)
		GLOB.spawner_number = 1
		to_chat(usr, SPAN_INFO("Spawners removed and ID number reset."))
