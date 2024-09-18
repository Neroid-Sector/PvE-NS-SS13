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
	var/spawner_initiated = FALSE
	var/veterans_spawned = 0
	var/spawner_id

/obj/structure/xenosurge_spawner/Initialize(mapload, ...)
	. = ..()
	if(!spawner_id)
		spawner_id = GLOB.spawner_number
		GLOB.spawner_number += 1
	spawner_initiated = TRUE
	to_chat(usr, SPAN_INFO("Spawner number [spawner_id] set."))
	GLOB.xenosurge_configured_spawners.Add(src)
	if(GLOB.xenosurge_surge_started == 1)
		to_chat(usr, SPAN_INFO("In-Progress Xenosurge detected. Starting spawn loop for spawner [spawner_id]."))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_spawn))
	return 1

/obj/structure/xenosurge_spawner/proc/spawner_limit_reached()
	message_admins("Wave limit of [GLOB.xenosurge_wave_xenos_max] reached. Disabling spawners.")
	GLOB.xenosurge_surge_started = 0
	GLOB.xenosurge_wave_xenos_current = 0
	GLOB.xenosurge_wave_veteran_xenos_current = 0

/obj/structure/xenosurge_spawner/proc/spawner_loop()
	sleep(GLOB.xenosurge_spawner_delay)
	if(GLOB.xenosurge_surge_started == FALSE)
		return
	else
		spawner_spawn()

/obj/structure/xenosurge_spawner/proc/veteran_spawn_loop()
	if(GLOB.xenosurge_wave_veteran_xenos_current >= GLOB.xenosurge_veteran_xenos_max) return
	var/veterans_to_spawn = GLOB.xenosurge_veteran_spawner_xenos_max
	while(veterans_to_spawn > 0)
		if(GLOB.xenosurge_surge_started == 0)
			veterans_to_spawn = 0
			break
		sleep(GLOB.xenosurge_veteran_spawner_delay + (rand(1,GLOB.xenosurge_spawner_variance)))
		var/veteran_xenos_to_spawn_type = XENO_CASTE_DRONE
		var/turf/veteran_spawner_xeno_turf = get_random_turf_in_range(src, 2, 0)
		var/veteran_spawner_xeno_typepath = RoleAuthority.get_caste_by_text(veteran_xenos_to_spawn_type)
		var/mob/living/carbon/xenomorph/drone/spawned_veteran = new veteran_spawner_xeno_typepath(veteran_spawner_xeno_turf, null, "xeno_hive_normal")
		spawned_veteran.health = 1000
		spawned_veteran.maxHealth = 1000
		spawned_veteran.melee_damage_lower = 15
		spawned_veteran.melee_damage_upper = 25
		spawned_veteran.armor_deflection = 20
		veterans_to_spawn -= 1
		GLOB.xenosurge_wave_veteran_xenos_current += 1

/obj/structure/xenosurge_spawner/proc/spawner_spawn()
	var/global_xeno_count = 0
	for (var/mob/living/carbon/xenomorph/xeno in world)
		if(xeno.loc != null)
			global_xeno_count += 1
	if(global_xeno_count > GLOB.xenosurge_spawner_limit)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))
		return
	else
		var/surge_to_spawn = GLOB.xenosurge_spawner_xenos
		if(veterans_spawned == 0)
			veterans_spawned = 1
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, veteran_spawn_loop))
		while(surge_to_spawn > 0)
			var/xenos_to_spawn_type = XENO_CASTE_DRONE
			var/turf/spawner_xeno_turf = get_random_turf_in_range(src, 2, 0)
			var/spawner_xeno_typepath = RoleAuthority.get_caste_by_text(xenos_to_spawn_type)
			var/mob/living/carbon/xenomorph/drone/spawned_xeno = new spawner_xeno_typepath(spawner_xeno_turf, null, "xeno_hive_normal")
			spawned_xeno.health = GLOB.xenosurge_wave_xenos_hp
			spawned_xeno.maxHealth = GLOB.xenosurge_wave_xenos_hp
			spawned_xeno.melee_damage_lower = GLOB.xenosurge_wave_xenos_dam_min
			spawned_xeno.melee_damage_upper = GLOB.xenosurge_wave_xenos_dam_max
			spawned_xeno.armor_deflection = GLOB.xenosurge_wave_xenos_armor
			surge_to_spawn -= 1
			GLOB.xenosurge_wave_xenos_current += 1
			sleep(rand(1,GLOB.xenosurge_spawner_variance))
		if(GLOB.xenosurge_wave_xenos_current >= GLOB.xenosurge_wave_xenos_max)
			spawner_limit_reached()
		else
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))


/obj/structure/xenosurge_spawner/proc/start_spawning()
	if(spawner_initiated == FALSE)
		to_chat(usr, SPAN_WARNING("Failed. Spawner not initiated."))
		return
	else
		message_admins("Spawner [spawner_id] starting.")
		spawner_spawn()
		return


#undef AI_XENOS
