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

/client/proc/setup_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Setup"
	set desc = "Sets parameters for next wave surge."

	if(!check_rights(R_ADMIN))
		return
	var/surge_setup_value
	switch(tgui_input_list(usr, "Max:[GLOB.xenosurge_spawner_limit]\nSpawned:[GLOB.xenosurge_wave_xenos_current] out of [GLOB.xenosurge_wave_xenos_max]", "SURGE", list("Global Xeno Limit","Number of Surge Xenos","Factors","Spawn List")))
		if(null)
			return
		if("Global Xeno Limit")
			surge_setup_value = tgui_input_number(usr, "Pick maximum xenos at once. This is a global control to prevent lag. Generally suggest leaving this alone.", "SURGE",GLOB.xenosurge_spawner_limit,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_spawner_limit = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Number of Surge Xenos")
			surge_setup_value = tgui_input_number(usr, "Xenos to spawn in the wave", "SURGE",GLOB.xenosurge_wave_xenos_max,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_max = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Factors")
			surge_setup_value = tgui_input_number(usr, "HP Factor", "SURGE",GLOB.xenosurge_wave_xenos_hp_factor,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_hp_factor = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
			surge_setup_value = tgui_input_number(usr, "Damage Factor", "SURGE",GLOB.xenosurge_wave_xenos_dam_factor,timeout = 0)
			if(surge_setup_value == null) return
			GLOB.xenosurge_wave_xenos_dam_factor = surge_setup_value
			to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
		if("Spawn List")
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
		var/veteran_spawner_count = 0
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner == null)
				to_chat(usr, SPAN_WARNING("No spawner found. Aborted."))
				return
			if(spawner.spawner_initiated == TRUE)
				spawner.start_spawning()
				spawner_count += 1
		for (var/obj/structure/xenosurge_veteran_spawner/veteran_spawner in GLOB.xenosurge_configured_veteran_spawners)
			if(veteran_spawner.spawner_initiated == TRUE)
				veteran_spawner.start_spawning()
				veteran_spawner_count += 1
		to_chat(usr, SPAN_INFO("Spawner activation complete. Spawners activated: [spawner_count] and [veteran_spawner_count] veterans."))
		message_admins("[usr] has activated a [spawner_count] spawner Xenosurge. Parameters: Max:[GLOB.xenosurge_spawner_limit], Xenos:[GLOB.xenosurge_wave_xenos_max]")

/client/proc/stop_surge()
	set category = "DM.Xenosurge"
	set name = "Surge - Stop"
	set desc = "Deinitalizes all spawners, stopping them."

	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Stop Xenosurge?","STOP",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner.spawner_initiated == TRUE)
				spawner.spawner_initiated = FALSE
		for (var/obj/structure/xenosurge_veteran_spawner/veteran_spawner in GLOB.xenosurge_configured_veteran_spawners)
			if(veteran_spawner.spawner_initiated == TRUE)
				veteran_spawner.spawner_initiated = FALSE
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
		GLOB.xenosurge_configured_spawners = list()
		GLOB.spawner_number = 1
		for (var/obj/structure/xenosurge_veteran_spawner/veteran_spawner in world)
			qdel(veteran_spawner)
		GLOB.xenosurge_configured_veteran_spawners = list()
		GLOB.veteran_spawner_number = 1
		to_chat(usr, SPAN_INFO("Spawners removed and ID number reset."))

/client/proc/reinitialize_spawners()
	set category = "DM.Xenosurge"
	set name = "Spawners - Reinitialize"
	set desc = "Reinits spawners to let them be used in active surges again."
	if(!check_rights(R_ADMIN))
		return
	if(tgui_alert(usr, "Confirm: Reinit spawners?","REINIT",list("Cancel","OK"), timeout = 0) == "OK")
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner.spawner_initiated == FALSE)
				spawner.spawner_initiated = TRUE
		for (var/obj/structure/xenosurge_veteran_spawner/veteran_spawner in GLOB.xenosurge_configured_veteran_spawners)
			if(veteran_spawner.spawner_initiated == FALSE)
				veteran_spawner.spawner_initiated = TRUE
		to_chat(usr, SPAN_INFO("Spawners reinitialized. You may now restart a surge."))

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
			GLOB.xenosurge_wave_xenos_hp_factor = 0.3
			GLOB.xenosurge_wave_xenos_dam_factor = 0.5
		if("Very Weak")
			GLOB.xenosurge_wave_xenos_hp_factor = 0.5
			GLOB.xenosurge_wave_xenos_dam_factor = 0.5
		if("Weak")
			GLOB.xenosurge_wave_xenos_hp_factor = 0.7
			GLOB.xenosurge_wave_xenos_dam_factor = 0.7
		if("Normal")
			GLOB.xenosurge_wave_xenos_hp_factor = 1
			GLOB.xenosurge_wave_xenos_dam_factor = 1
		if("Strong")
			GLOB.xenosurge_wave_xenos_hp_factor = 1.3
			GLOB.xenosurge_wave_xenos_dam_factor = 1.2
		if("Very Strong")
			GLOB.xenosurge_wave_xenos_hp_factor = 1.5
			GLOB.xenosurge_wave_xenos_dam_factor = 1.5

/client/proc/surge_preset_waves()
	set category = "DM.Xenosurge"
	set name = "Surge - Xeno types"
	set desc = "Switch all spawner xeno lists to a specific type."
	if(!check_rights(R_ADMIN))
		return
	var/list/list_to_set = list()
	switch(tgui_input_list(usr, "Select a surge preset:","SURGE",list("Drones","Runners","Lurkers","Crushers","Drones-Runners","Drones-Lurkers","Runners-Lurkers","Drones-Runners-Lurkers","Drones-Crushers","Runners-Crushers","All-Out"), timeout = 0, default = "Normal"))
		if(null)
			return
		if("Drones")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = null,)
		if("Runners")
			list_to_set = list(1 = XENO_CASTE_RUNNER, 2 = null,)
		if("Lurkers")
			list_to_set = list(1 = XENO_CASTE_LURKER, 2 = null,)
		if("Crushers")
			list_to_set = list(1 = XENO_CASTE_CRUSHER, 2 = null,)
		if("Drones-Runners")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = XENO_CASTE_DRONE, 3 = XENO_CASTE_RUNNER, 4 = null)
		if("Drones-Lurkers")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = XENO_CASTE_DRONE, 3 = XENO_CASTE_LURKER, 4 = null)
		if("Runners-Lurkers")
			list_to_set = list(1 = XENO_CASTE_RUNNER, 2 = XENO_CASTE_RUNNER, 3 = XENO_CASTE_LURKER, 4 = null)
		if("Drones-Runners-Lurkers")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = XENO_CASTE_DRONE, 3 = XENO_CASTE_RUNNER, 4 = XENO_CASTE_LURKER, 5 = null)
		if("Drones-Crushers")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = XENO_CASTE_DRONE, 3 = XENO_CASTE_DRONE, 4 = XENO_CASTE_CRUSHER, 5 = null)
		if("Runners-Crushers")
			list_to_set = list(1 = XENO_CASTE_RUNNER, 2 = XENO_CASTE_RUNNER, 3 = XENO_CASTE_RUNNER, 4 = XENO_CASTE_CRUSHER, 5 = null)
		if("All-Out")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = XENO_CASTE_DRONE, 3 = XENO_CASTE_DRONE, 4 = XENO_CASTE_RUNNER, 5 = XENO_CASTE_RUNNER, 6 = XENO_CASTE_LURKER, 7 = XENO_CASTE_CRUSHER, 8 = null)
	if(list_to_set.len != 0)
		var/spawner_count = 0
		for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
			if(spawner.spawner_initiated == TRUE)
				spawner.spawn_list = list_to_set
				spawner_count += 1
		to_chat(usr, SPAN_INFO("Done. [spawner_count] spawners set."))

/client/proc/create_surge_spawner(turf/T in turfs)
	set name = "Create Surge Spawner"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/obj/structure/xenosurge_spawner/spawner = new(T)
	if(spawner.setup_spawner(max = GLOB.xenosurge_spawner_xenos, delay = GLOB.xenosurge_spawner_delay) == 0)
		to_chat(usr, SPAN_WARNING("Spawner not configured. Discarding."))
		qdel(spawner)
	return

/client/proc/create_veteran_spawner_setup()
	set category = "DM.Xenosurge"
	set name = "Veterans - Creation"
	set desc = "Configures Veteran spawner creation variables."

	if(!check_rights(R_ADMIN))
		return
	var/max_to_pass = tgui_input_number(usr, "How many total veterans per spawner?","Spawner Setup",default = GLOB.xenosurge_veteran_spawner_xenos, timeout = 0)
	if(max_to_pass == null) return
	GLOB.xenosurge_veteran_spawner_xenos = max_to_pass
	var/delay_to_pass = tgui_input_number(usr, "Base veteran spawn delay","Spawner Setup",default = GLOB.xenosurge_veteran_spawner_delay, timeout = 0)
	if(delay_to_pass == null) return
	GLOB.xenosurge_veteran_spawner_delay = delay_to_pass
	var/variance_to_pass = tgui_input_number(usr, "Delay variance, added maximum between this and 1 is added to base delay","Spawner Setup",default = GLOB.xenosurge_veteran_spawner_variance, timeout = 0)
	if(variance_to_pass == null) return
	GLOB.xenosurge_veteran_spawner_variance = variance_to_pass

/client/proc/veteran_setup()
	set category = "DM.Xenosurge"
	set name = "Veterans - Setup"
	set desc = "Changes Veteran spawners"
	if(!check_rights(R_ADMIN))
		return
	var/list/list_to_set = list()
	switch(tgui_input_list(usr, "Select a veteran type:","VETERAN",list("Drones","Runners","Lurkers","Crushers"), timeout = 0, default = "Normal"))
		if(null, "Drones")
			list_to_set = list(1 = XENO_CASTE_DRONE, 2 = null,)
		if("Runners")
			list_to_set = list(1 = XENO_CASTE_RUNNER, 2 = null,)
		if("Lurkers")
			list_to_set = list(1 = XENO_CASTE_LURKER, 2 = null,)
		if("Crushers")
			list_to_set = list(1 = XENO_CASTE_CRUSHER, 2 = null,)
	if(list_to_set.len != 0)
		var/spawner_count = 0
		for (var/obj/structure/xenosurge_veteran_spawner/spawner in GLOB.xenosurge_configured_veteran_spawners)
			if(spawner.spawner_initiated == TRUE)
				spawner.spawn_list = list_to_set
				spawner_count += 1
		to_chat(usr, SPAN_INFO("Done. [spawner_count] veteran spawners set."))
	var/surge_setup_value
	surge_setup_value = tgui_input_number(usr, "HP Factor", "VETERAN",GLOB.xenosurge_veteran_xenos_hp_factor,timeout = 0)
	if(surge_setup_value == null) surge_setup_value = GLOB.xenosurge_veteran_xenos_hp_factor
	GLOB.xenosurge_veteran_xenos_hp_factor = surge_setup_value
	to_chat(usr, SPAN_INFO("[surge_setup_value] set."))
	surge_setup_value = tgui_input_number(usr, "Damage Factor", "VETERAN",GLOB.xenosurge_veteran_xenos_dam_factor,timeout = 0)
	if(surge_setup_value == null) surge_setup_value = GLOB.xenosurge_veteran_xenos_dam_factor
	GLOB.xenosurge_veteran_xenos_dam_factor = surge_setup_value
	to_chat(usr, SPAN_INFO("[surge_setup_value] set."))

/client/proc/create_veteran_surge_spawner(turf/T in turfs)
	set name = "Create Veteran Surge Spawner"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/obj/structure/xenosurge_veteran_spawner/spawner = new(T)
	if(spawner.setup_spawner(max = GLOB.xenosurge_veteran_spawner_xenos, delay = GLOB.xenosurge_veteran_spawner_delay, variance = GLOB.xenosurge_veteran_spawner_variance) == 0)
		to_chat(usr, SPAN_WARNING("Spawner not configured. Discarding."))
		qdel(spawner)
	return
