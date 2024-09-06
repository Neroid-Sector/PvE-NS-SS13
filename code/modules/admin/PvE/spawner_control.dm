/client/proc/create_spawner_setup()
	set category = "DM.Xenosurge"
	set name = "Spawners - Create Setup"
	set desc = "Configures spawner creation variables."

	if(!check_rights(R_ADMIN))
		return
	var/max_to_pass = tgui_input_number(usr, "How many xenos total from created spawners","Spawner Setup",default = GLOB.xenosurge_spawner_xenos, timeout = 0)
	if(max_to_pass == null) return
	GLOB.xenosurge_spawner_xenos = max_to_pass
	var/delay_to_pass = tgui_input_number(usr, "Dealy, in ticks (~10 a second) between spawn checks","Spawner Setup",default = GLOB.xenosurge_spawner_delay, timeout = 0)
	if(delay_to_pass == null) return
	GLOB.xenosurge_spawner_delay = delay_to_pass

/client/proc/create_spawner()
	set category = "DM.Xenosurge"
	set name = "Spawners - Create Action"
	set desc = "Starts the spawner creation loop."

	if(!check_rights(R_ADMIN))
		return
	var/spawner_cycle
	spawner_cycle = tgui_alert(usr, "Move your ghost to the postion of the spawner and press OK. Cancel to cancel.","SPAWNER",list("Cancel","OK"), timeout = 0)
	while(spawner_cycle == "OK")
		var/turf/spawner_turf = mob.loc
		var/obj/structure/xenosurge_spawner/spawner = new(spawner_turf)
		if(spawner.setup_spawner(max = GLOB.xenosurge_spawner_xenos, delay = GLOB.xenosurge_spawner_delay) == 0)
			to_chat(usr, SPAN_WARNING("Spawner not configured. Discarding."))
			qdel(spawner)
		spawner_cycle = tgui_alert(usr, "Move your ghost to the postion of the spawner and press OK. Cancel to cancel.","SPAWNER",list("Cancel","OK"), timeout = 0)
	return



/client/proc/setup_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Setup"
	set desc = "Sets parameters for next wave surge."

	if(!check_rights(R_ADMIN))
		return
	var/surge_setup_value
	switch(tgui_input_list(usr, "Max:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]", "SURGE", list("Max","Xenos","Factors","Spawns")))
		if(null)
			return
		if("Max")
			surge_setup_value = tgui_input_number(usr, "Pick maximum xenos at once. This is a global control to prevent lag. Generally suggest leaving this alone.", "SURGE",GLOB.xenosurge_spawner_limit,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_limit = surge_setup_value
		if("Xenos")
			surge_setup_value = tgui_input_number(usr, "Xenos to spawn in the wave", "SURGE",GLOB.xenosurge_wave_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_max = surge_setup_value
		if("Factors")
			surge_setup_value = tgui_input_number(usr, "HP Factor", "SURGE",GLOB.xenosurge_wave_xenos_hp_factor,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_hp_factor = surge_setup_value
			surge_setup_value = tgui_input_number(usr, "Damage Factor", "SURGE",GLOB.xenosurge_wave_xenos_dam_factor,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_dam_factor = surge_setup_value
		if("Spawns")
			var/list/spawns_to_set = list()
			var/current_number = 1
			var/adding_finished = 0
			while(adding_finished == 0)
				var/type_to_add = tgui_input_list(usr, "Current position: [current_number], select a xeno to add:", "SURGE", list(XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_LURKER, XENO_CASTE_CRUSHER, XENO_CASTE_FACEHUGGER, "FINISH"), timeout = 0, default = XENO_CASTE_DRONE)
				if(type_to_add == null) return
				if(type_to_add != "FINISH")
					spawns_to_set.Add(list(type_to_add))
					current_number += 1
				else
					spawns_to_set.Add(list(null))
					adding_finished = 1
			for(var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
				if(!spawner)
					to_chat(usr, SPAN_WARNING("No spawners set!"))
					return
				spawner.spawn_list = spawns_to_set

	return


/client/proc/start_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Start"
	set desc = "Checks critcial params, starts surge."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Start Xenosurge?\nMax:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]","START",list("Cancel","OK"), timeout = 0) == "OK")
		var/spawner_count = 0
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner == null)
				to_chat(usr, SPAN_WARNING("No spawner found. Aborted."))
				return
			if(spawner.spawner_initiated == TRUE)
				spawner.start_spawning()
				spawner_count += 1
		to_chat(usr, SPAN_INFO("Spawner activation complete. Spawners activated: [spawner_count]."))
		log_admin("[usr] has activated a [spawner_count] spawner Xenosurge. Parameters: Max:[GLOB.xenosurge_spawner_limit], Xenos:[GLOB.xenosurge_wave_xenos_max]")

/client/proc/stop_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Stop"
	set desc = "Deinitalizes all spawners, stopping them."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Stop Xenosurge?","START",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner.spawner_initiated == TRUE)
				spawner.spawner_initiated = FALSE
		GLOB.xenosurge_wave_xenos_current = 0

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
		GLOB.spawner_number = 1
		to_chat(usr, SPAN_INFO("Spawners removed and ID number reset."))
