#define AI_XENOS list(XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_LURKER, XENO_CASTE_CRUSHER, XENO_CASTE_FACEHUGGER)
#define XENO_BEHAVIORS list("Attack", "Capture", "Hive", "Build")
#define XENO_BEHAVIORS_ASSOC list("Attack" = /datum/component/ai_behavior_override/attack, "Capture" = /datum/component/ai_behavior_override/capture, "Hive" = /datum/component/ai_behavior_override/hive, "Build" = /datum/component/ai_behavior_override/build)
GLOBAL_VAR_INIT(spawner_number, 1)


/obj/structure/xenosurge_spawner
	name = "AI spawner"
	desc = "just spawnin' shit"
	opacity = FALSE
	density = FALSE
	invisibility = INVISIBILITY_OBSERVER
	icon_state = "brazier"
	indestructible = TRUE
	unacidable = TRUE
	unslashable = TRUE
	var/xenos_to_spawn_max = 5
	var/xenos_to_spawn_type = XENO_CASTE_DRONE
	var/xenos_to_spawn_delay = 100
	var/spawner_initiated = FALSE
	var/spawner_id

/obj/structure/xenosurge_spawner/proc/spawner_limit_reached()
	log_admin("Wave limit of [GLOB.xenosurge_wave_xenos_max] reached. Disabling spawners.")
	for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
		spawner.spawner_initiated = FALSE
	GLOB.xenosurge_wave_xenos_current = 0

/obj/structure/xenosurge_spawner/proc/spawner_loop()
	sleep(xenos_to_spawn_delay)
	if(spawner_initiated == FALSE)
		return
	else
		spawner_spawn()

/obj/structure/xenosurge_spawner/proc/spawner_spawn()
	var/global_xeno_count = 0
	var/ai_count = 0
	for (var/mob/living/carbon/xenomorph/xeno in GLOB.living_xeno_list)
		if(xeno.loc != null)
			global_xeno_count += 1
			if(xeno.spawner_id == spawner_id)
				ai_count += 1
	if(global_xeno_count > GLOB.xenosurge_spawner_limit)
		log_admin("Spawner [spawner_id] returns [global_xeno_count] global xenos, over the [GLOB.xenosurge_spawner_limit], skipping.")
	if(ai_count >= xenos_to_spawn_max)
		log_admin("Spawner [spawner_id] returns [ai_count] out of [xenos_to_spawn_max], skipping.")
	else
		var/xenos_to_spawn = xenos_to_spawn_max - ai_count
		log_admin("Spawner [spawner_id] returns [ai_count] out of [xenos_to_spawn_max], generating [xenos_to_spawn].")
		while(xenos_to_spawn > 0)
			var/turf/spawner_xeno_turf = get_random_turf_in_range(src, 2, 0)
			var/spawner_xeno_typepath = RoleAuthority.get_caste_by_text(xenos_to_spawn_type)
			var/mob/living/carbon/xenomorph/drone/spawned_xeno = new spawner_xeno_typepath(spawner_xeno_turf, null, "xeno_hive_normal")
			spawned_xeno.spawner_id = spawner_id
			xenos_to_spawn -= 1
			global_xeno_count += 1
			GLOB.xenosurge_wave_xenos_current += 1
			if(global_xeno_count >= GLOB.xenosurge_spawner_limit)
				log_admin("Spawner [spawner_id] has reached [xenos_to_spawn_max] spawned xenos, skipping rest.")
				break
	if(GLOB.xenosurge_wave_xenos_current >= GLOB.xenosurge_wave_xenos_max)
		spawner_limit_reached()
	else
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))

/obj/structure/xenosurge_spawner/proc/setup_spawner(max = null, delay = null, type = null)
	if(max == null)
		xenos_to_spawn_max = tgui_input_number(usr, "How many xenos total from this spawner","Spawner Setup",xenos_to_spawn_max, timeout = 0)
		if(xenos_to_spawn_max == null) return 0
	else
		xenos_to_spawn_max = max
	if(delay == null)
		xenos_to_spawn_delay = tgui_input_number(usr, "Dealy, in ticks (~10 a second) between spawn checks","Spawner Setup",xenos_to_spawn_delay, timeout = 0)
		if(xenos_to_spawn_delay == null) return 0
	else
		xenos_to_spawn_delay = delay
	if(type == null)
		xenos_to_spawn_type = tgui_input_list(usr, "Xeno Type","Spawner Setup",AI_XENOS,timeout = 0, default = xenos_to_spawn_type)
		if(xenos_to_spawn_type == null) return 0
	else
		xenos_to_spawn_type = type
	if(!spawner_id)
		spawner_id = GLOB.spawner_number
		GLOB.spawner_number += 1
	spawner_initiated = TRUE
	to_chat(usr, SPAN_INFO("Spawner number [spawner_id] set."))
	GLOB.xenosurge_configured_spawners.Add(src)
	return 1

/obj/structure/xenosurge_spawner/proc/start_spawning()
	if(spawner_initiated == FALSE)
		to_chat(usr, SPAN_WARNING("Failed. Spawner not initiated."))
		return
	else
		log_admin("Spawner [spawner_id] starting.")
		spawner_spawn()
		return

#undef AI_XENOS
#undef XENO_BEHAVIORS
#undef XENO_BEHAVIORS_ASSOC
