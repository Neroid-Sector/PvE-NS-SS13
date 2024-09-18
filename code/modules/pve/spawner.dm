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
	if(GLOB.xenosurge_veteran_xenos_max <= GLOB.xenosurge_wave_veteran_xenos_current) return
	var/veterans_to_spawn = GLOB.xenosurge_veteran_spawner_xenos_max
	while(veterans_to_spawn > 0)
		if(GLOB.xenosurge_surge_started == 0)
			veterans_to_spawn = 0
			break
		sleep(GLOB.xenosurge_veteran_spawner_delay + (rand(1,GLOB.xenosurge_veteran_spawner_variance)))
		var/veteran_xenos_to_spawn_type = XENO_CASTE_DRONE
		var/turf/veteran_spawner_xeno_turf = get_random_turf_in_range(src, 1, 0)
		var/veteran_spawner_xeno_typepath = RoleAuthority.get_caste_by_text(veteran_xenos_to_spawn_type)
		var/mob/living/carbon/xenomorph/drone/spawned_veteran = new veteran_spawner_xeno_typepath(veteran_spawner_xeno_turf, null, "xeno_hive_normal")
		var/veteran_type
		if(GLOB.xenosurge_veteran_type == 4)
			veteran_type = rand(1,3)
		else
			veteran_type = GLOB.xenosurge_veteran_type
		switch(veteran_type)
			if(1) // Pusher
				spawned_veteran.name = "Surge Pusher"
				spawned_veteran.desc = "A very agressive Surge that seems very dangerous up close."
				spawned_veteran.health = 800
				spawned_veteran.maxHealth = 800
				spawned_veteran.melee_damage_lower = 25
				spawned_veteran.melee_damage_upper = 40
				spawned_veteran.armor_deflection = 10
				spawned_veteran.caste.attack_delay = -2
				spawned_veteran.speed = -0.2
				switch(rand(1,2))
					if(1)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_pusher_1.dmi'
					if(2)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_pusher_2.dmi'
			if(2) // Ambusher
				spawned_veteran.name = "Surge Ambusher"
				spawned_veteran.desc = "A fast and quick moving Surge."
				spawned_veteran.health = 500
				spawned_veteran.maxHealth = 500
				spawned_veteran.melee_damage_lower = 15
				spawned_veteran.melee_damage_upper = 15
				spawned_veteran.armor_deflection = 10
				spawned_veteran.caste.attack_delay = -5
				spawned_veteran.speed = -0.5
				switch(rand(1,2))
					if(1)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_ambusher_1.dmi'
					if(2)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_ambusher_2.dmi'
			if(3) // Breaker
				spawned_veteran.name = "Surge Breaker"
				spawned_veteran.desc = "A bulky Surge that moves slowly, but looks like it can both take and hand out a lot of damage."
				spawned_veteran.health = 1500
				spawned_veteran.maxHealth = 1500
				spawned_veteran.melee_damage_lower = 60
				spawned_veteran.melee_damage_upper = 40
				spawned_veteran.armor_deflection = 30
				spawned_veteran.caste.attack_delay = 4
				spawned_veteran.speed = 0.6
				switch(rand(1,2))
					if(1)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_breaker_1.dmi'
					if(2)
						spawned_veteran.icon = 'icons/mob/xenos/Surge/veteran_breaker_2.dmi'
		spawned_veteran.update_icons()
		veterans_to_spawn -= 1
		GLOB.xenosurge_wave_veteran_xenos_current += 1
	veterans_spawned = 1

/obj/structure/xenosurge_spawner/proc/spawner_spawn()
	if(veterans_spawned == 0)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, veteran_spawn_loop))
	var/global_xeno_count = 0
	for (var/mob/living/carbon/xenomorph/xeno in world)
		if(xeno.loc != null)
			global_xeno_count += 1
	if(global_xeno_count > GLOB.xenosurge_spawner_limit)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_loop))
		return
	else
		var/surge_to_spawn = GLOB.xenosurge_spawner_xenos
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
			spawned_xeno.name = "Surge Regular"
			spawned_xeno.desc = "A creature that looks and moves like a xenomorph, but with a distinct bright pink scar on its head."
			switch(rand(1,3))
				if(1)
					spawned_xeno.icon = 'icons/mob/xenos/Surge/surge_1.dmi'
				if(2)
					spawned_xeno.icon = 'icons/mob/xenos/Surge/surge_2.dmi'
				if(3)
					spawned_xeno.icon = 'icons/mob/xenos/Surge/surge_3.dmi'
			spawned_xeno.update_icons()
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
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/xenosurge_spawner/, spawner_spawn))
		return


#undef AI_XENOS
