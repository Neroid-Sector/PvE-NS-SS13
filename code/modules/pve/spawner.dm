#define AI_XENOS list(XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_LURKER, XENO_CASTE_CRUSHER, XENO_CASTE_FACEHUGGER)

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
	var/list/spawn_list = list(1 = XENO_CASTE_DRONE, 2 = null,)
	var/xenos_to_spawn_delay = 100
	var/spawner_initiated = FALSE
	var/spawner_id
	var/extra_delay = 0

/obj/structure/xenosurge_spawner/proc/spawner_limit_reached()
	message_admins("Wave limit of [GLOB.xenosurge_wave_xenos_max] reached. Disabling spawners.")
	for (var/obj/structure/xenosurge_spawner/spawner in GLOB.xenosurge_configured_spawners)
		spawner.spawner_initiated = FALSE
	GLOB.xenosurge_wave_xenos_current = 0

/obj/structure/xenosurge_spawner/proc/spawner_loop()
	sleep(xenos_to_spawn_delay + extra_delay)
	if(spawner_initiated == FALSE)
		return
	else
		spawner_spawn()

/obj/structure/xenosurge_spawner/proc/spawner_spawn()
	var/global_xeno_count = 0
	var/ai_count = 0
	for (var/mob/living/carbon/xenomorph/xeno in world)
		if(xeno.loc != null)
			global_xeno_count += 1
			if(xeno.spawner_id == spawner_id)
				ai_count += 1
	if(global_xeno_count > GLOB.xenosurge_spawner_limit)
		if(extra_delay != 0) extra_delay += 50
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))
		return
	if(ai_count >= xenos_to_spawn_max)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))
		return
	else
		var/xenos_to_spawn = xenos_to_spawn_max - ai_count
		var/current_spawnlistpos = 1
		while(xenos_to_spawn > 0)
			var/xenos_to_spawn_type = spawn_list[current_spawnlistpos]
			var/turf/spawner_xeno_turf = get_random_turf_in_range(src, 2, 0)
			var/spawner_xeno_typepath = RoleAuthority.get_caste_by_text(xenos_to_spawn_type)
			var/mob/living/carbon/xenomorph/drone/spawned_xeno = new spawner_xeno_typepath(spawner_xeno_turf, null, "xeno_hive_normal")
			spawned_xeno.spawner_id = spawner_id
			spawned_xeno.health *= GLOB.xenosurge_wave_xenos_hp_factor
			spawned_xeno.maxHealth *= GLOB.xenosurge_wave_xenos_hp_factor
			spawned_xeno.melee_damage_lower = ceil(spawned_xeno.melee_damage_lower * GLOB.xenosurge_wave_xenos_dam_factor)
			spawned_xeno.melee_damage_upper = ceil(spawned_xeno.melee_damage_upper * GLOB.xenosurge_wave_xenos_dam_factor)
			if(spawn_list[current_spawnlistpos + 1] != null)
				current_spawnlistpos += 1
			else
				current_spawnlistpos = 1
			xenos_to_spawn -= 1
			global_xeno_count += 1
			GLOB.xenosurge_wave_xenos_current += 1
			if(global_xeno_count >= GLOB.xenosurge_spawner_limit)
				xenos_to_spawn = 0
				extra_delay += 150
				break
		if(GLOB.xenosurge_wave_xenos_current >= GLOB.xenosurge_wave_xenos_max)
			spawner_limit_reached()
		else
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))

/obj/structure/xenosurge_spawner/proc/setup_spawner(max = null, delay = null)
	if(max == null)
		xenos_to_spawn_max = tgui_input_number(usr, "How many xenos total from this spawner","Spawner Setup",xenos_to_spawn_max, timeout = 0)
		if(xenos_to_spawn_max == null) return 0
	else
		xenos_to_spawn_max = max
	if(delay == null)
		xenos_to_spawn_delay = tgui_input_number(usr, "Dealy, in ticks (~10 a second) between spawn checks.","Spawner Setup",xenos_to_spawn_delay, timeout = 0)
		if(xenos_to_spawn_delay == null) return 0
	else
		xenos_to_spawn_delay = delay
	if(!spawner_id)
		spawner_id = GLOB.spawner_number
		GLOB.spawner_number += 1
	spawner_initiated = TRUE
	to_chat(usr, SPAN_INFO("Spawner number [spawner_id] set."))
	GLOB.xenosurge_configured_spawners.Add(src)
	if(GLOB.xenosurge_wave_xenos_current > 0)
		to_chat(usr, SPAN_INFO("In-Progress Xenosurge detected. Starting spawn loop for spawner [spawner_id]."))
		spawner_spawn()
	return 1

/obj/structure/xenosurge_spawner/proc/start_spawning()
	if(spawner_initiated == FALSE)
		to_chat(usr, SPAN_WARNING("Failed. Spawner not initiated."))
		return
	else
		message_admins("Spawner [spawner_id] starting.")
		spawner_spawn()
		return

/obj/structure/xenosurge_veteran_spawner
	name = "veteran AI spawner"
	desc = "just spawnin' veteran shit"
	opacity = FALSE
	density = FALSE
	invisibility = INVISIBILITY_OBSERVER
	icon_state = "campfire_on"
	indestructible = TRUE
	unacidable = TRUE
	unslashable = TRUE
	var/xenos_to_spawn_max = 5
	var/list/spawn_list = list(1 = XENO_CASTE_DRONE, 2 = null,)
	var/xenos_to_spawn_delay = 200
	var/spawner_variance = 100
	var/spawner_initiated = FALSE
	var/spawner_id
	var/extra_delay = 0

/obj/structure/xenosurge_veteran_spawner/proc/spawner_loop()
	sleep(xenos_to_spawn_delay + extra_delay + rand(1,spawner_variance))
	if(spawner_initiated == FALSE)
		return
	else
		spawner_spawn()

/obj/structure/xenosurge_veteran_spawner/proc/spawner_spawn()
	var/xenos_to_spawn = xenos_to_spawn_max
	var/current_spawnlistpos = 1
	while(xenos_to_spawn > 0)
		var/xenos_to_spawn_type = spawn_list[current_spawnlistpos]
		var/turf/spawner_xeno_turf = get_random_turf_in_range(src, 2, 0)
		var/spawner_xeno_typepath = RoleAuthority.get_caste_by_text(xenos_to_spawn_type)
		var/mob/living/carbon/xenomorph/drone/spawned_xeno = new spawner_xeno_typepath(spawner_xeno_turf, null, "xeno_hive_normal")
		spawned_xeno.spawner_id = spawner_id
		spawned_xeno.health *= GLOB.xenosurge_veteran_xenos_hp_factor
		spawned_xeno.maxHealth *= GLOB.xenosurge_veteran_xenos_hp_factor
		spawned_xeno.melee_damage_lower = ceil(spawned_xeno.melee_damage_lower * GLOB.xenosurge_veteran_xenos_dam_factor)
		spawned_xeno.melee_damage_upper = ceil(spawned_xeno.melee_damage_upper * GLOB.xenosurge_veteran_xenos_dam_factor)
		if(spawn_list[current_spawnlistpos + 1] != null)
			current_spawnlistpos += 1
		else
			current_spawnlistpos = 1
		xenos_to_spawn -= 1
		sleep(rand(1,spawner_variance))
	spawner_initiated = FALSE


/obj/structure/xenosurge_veteran_spawner/proc/setup_spawner(max = null, delay = null, variance = null)
	if(max == null)
		xenos_to_spawn_max = tgui_input_number(usr, "How many veteran xenos to spawn","Spawner Setup",xenos_to_spawn_max, timeout = 0)
		if(xenos_to_spawn_max == null) return 0
	else
		xenos_to_spawn_max = max
	if(delay == null)
		xenos_to_spawn_delay = tgui_input_number(usr, "Base dealy until spawner starts spawning.","Spawner Setup",xenos_to_spawn_delay, timeout = 0)
		if(xenos_to_spawn_delay == null) return 0
	else
		xenos_to_spawn_delay = delay
	if(variance == null)
		spawner_variance = tgui_input_number(usr, "Variance in pause (in ticks) to dealy and individual spawns.","Spawner Setup",spawner_variance, timeout = 0)
		if(spawner_variance == null) return 0
	else
		spawner_variance = variance

	if(!spawner_id)
		spawner_id = GLOB.veteran_spawner_number
		GLOB.veteran_spawner_number += 1
	spawner_initiated = TRUE
	to_chat(usr, SPAN_INFO("Veteran spawner number [spawner_id] set."))
	GLOB.xenosurge_configured_veteran_spawners.Add(src)
	if(GLOB.xenosurge_wave_xenos_current > 0)
		to_chat(usr, SPAN_INFO("In-Progress Xenosurge detected. Starting spawn loop for veteran spawner [spawner_id]."))
		spawner_spawn()
	return 1

/obj/structure/xenosurge_veteran_spawner/proc/start_spawning()
	if(spawner_initiated == FALSE)
		to_chat(usr, SPAN_WARNING("Failed. Spawner not initiated."))
		return
	else
		message_admins("Veteran Spawner [spawner_id] starting.")
		spawner_loop()
		return

#undef AI_XENOS
