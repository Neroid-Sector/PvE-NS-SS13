/datum/boss_ai/

	var/mob/living/pve_boss/boss_mob

/datum/boss_ai/New(mob/boss)
	. = ..()
	boss_mob = boss

/datum/boss_ai/proc/pick_and_move()
	var/mob/living/pve_boss/boss = boss_mob
	var/current_turf = get_turf(boss)
	var/list/potential_turfs = list()
	potential_turfs = boss.movement_turfs.Copy()
	if(potential_turfs.Find(current_turf) == 1)
		potential_turfs.Remove(current_turf)
	var/picked_turf = pick(potential_turfs)
	boss.boss_ability.move_destination(picked_turf)

/datum/boss_ai/proc/movement_loop()
	var/mob/living/pve_boss/boss = boss_mob
	var/boss_turf = get_turf(boss)
	if(boss.boss_loop_override == 1 || boss.boss_add_phase == 1) return
	if(boss.movement_target != null)
		if(boss.movement_target == boss_turf)
			boss.movement_target = null
			INVOKE_ASYNC(src,PROC_REF(movement_loop))
			return
		else
			sleep(10)
			INVOKE_ASYNC(src,PROC_REF(movement_loop))
			return
	if(boss.movement_turfs == null)
		message_admins("[boss] tried to load navigation waypoints, but failed because its mob has none saved. Likely a mapping issue.")
		return
	INVOKE_ASYNC(src,PROC_REF(pick_and_move))
	sleep(10)
	INVOKE_ASYNC(src,PROC_REF(movement_loop))
	return

/datum/boss_ai/proc/use_ability(ability_name = null, ability_target = null)
	if(ability_name == null || ability_target == null) return
	var/mob/living/pve_boss/boss = boss_mob
	var/turf/target = ability_target
	if(boss.boss_loop_override == 1 || boss.boss_add_phase == 1) return
	var/ability_to_use = ability_name
	switch(ability_to_use)
		if("shot")
			boss.boss_ability.fire_cannon(target)
		if("aoe_shot")
			boss.boss_ability.surge_proj(target)
		if("missiles")
			boss.boss_ability.rapid_missles(target)
		if("drone")
			boss.boss_ability.SummonDrone()
	return

/datum/boss_ai/proc/init_delays()
	var/mob/living/pve_boss/boss = boss_mob
	var/p
	for(p in boss.ability_log)
		boss.ability_log[p] = world.time + (boss.ability_delays[p] * boss.GlobalCoolDown)
	return

/datum/boss_ai/proc/combat_loop(ability_name = null, ability_delay = null)
	var/mob/living/pve_boss/boss = boss_mob
	var/mob/living/pve_boss/boss_turf = get_turf(boss)
	if(boss.boss_loop_override == 1 || boss.boss_add_phase == 1) return
	var/list/abilities_to_try = list()
	if(boss.ability_log == null)
		message_admins("[boss] has no ability_log. Combat loop cannot initialize.")
		return
	if(boss.boss_delays_started == 0)
		init_delays()
		boss.boss_delays_started = 1
		boss.say("Termination Loop Initiated. Removing strays.")
	var/list/poitential_targets = list()
	for(var/mob/living/carbon/human/human_mob in range(10,boss_turf))
		poitential_targets += human_mob
	if(poitential_targets.len > 0)
		var/final_target = get_turf(pick(poitential_targets))
		abilities_to_try = boss.ability_log.Copy()
		var/p
		for(p in abilities_to_try)
			if(world.time > (abilities_to_try[p] + (boss.ability_delays[p] * boss.GlobalCoolDown)))
				INVOKE_ASYNC(src,PROC_REF(use_ability),p,final_target)
				boss.ability_log[p] = world.time
				abilities_to_try.Remove(p)
	sleep(boss.GlobalCoolDown)
	INVOKE_ASYNC(src,PROC_REF(combat_loop))
	return

/datum/boss_ai/proc/add_covering_fire()
	var/mob/living/pve_boss/boss = boss_mob
	var/mob/living/pve_boss/boss_turf = get_turf(boss)
	if(boss.boss_add_phase == 0) return
	var/list/poitential_targets = list()
	for(var/mob/living/carbon/human/human_mob in range(16,boss_turf))
		poitential_targets += human_mob
	if(poitential_targets.len > 0)
		var/final_target = get_turf(pick(poitential_targets))
		boss.boss_ability.fire_cannon(final_target)
	sleep(10)
	INVOKE_ASYNC(src, PROC_REF(add_covering_fire))
	return

/datum/boss_ai/proc/add_phase()
	var/mob/living/pve_boss/boss = boss_mob
	if(boss.boss_add_phase == 1) return
	var/area/boss_area = get_area(boss)
	var/turf/center_turf
	for(var/obj/effect/landmark/pve_boss_navigation/landmark_to_check in boss_area.boss_waypoints)
		if(landmark_to_check.id_tag == "center")
			center_turf = get_turf(landmark_to_check)
			break
	if(!center_turf)
		message_admins("Error: [boss] has no central waypoint. Picking one at random. This may be intended, but really shoudn't be.")
		center_turf = pick(boss.movement_turfs)
	boss.boss_add_phase = 1
	boss.boss_no_damage = 1
	boss.say("Considerable damage to shield detected. Activating damage deferral drones.")
	boss.boss_ability.relocate(center_turf)
	var/list/turfs_to_use = boss.drone_turfs.Copy()
	turfs_to_use.Remove(center_turf)
	while(boss.boss_adds_spawned < boss.boss_adds_spawned_max)
		var/turf/boss_mob_turf = pick(turfs_to_use)
		var/mob/living/pve_boss_drone/boss_variant/boss_drone = new(boss_mob_turf)
		boss_drone.boss_mob = boss
		turfs_to_use.Remove(boss_mob_turf)
		boss.boss_adds_spawned += 1
		if(turfs_to_use.len == 0)
			message_admins(SPAN_WARNING("Warning: [boss] ran out of add phase waypoints. Mapping/perp whoopsie. Adds actually spawned: [boss.boss_adds_spawned]"))
			break
	INVOKE_ASYNC(src, PROC_REF(add_covering_fire))

/datum/boss_ai/proc/add_phase_finish()
	var/mob/living/pve_boss/boss = boss_mob
	boss.boss_add_phases_cleared += 1
	boss.boss_add_phase = 0
	boss.boss_no_damage = 0
	boss.boss_delays_started = 0
	boss.say("Error: Deferral drones signal lost. Resuming standard operation. Increasing power draw.")
	movement_loop()
	combat_loop()
	boss.name = "ANATHEMA"
	boss.langchat_color = "#5f1414"
	boss.say("The Surge cannot be stopped. The Surge cannot be stopped. ...cannot be...")
	boss.name = initial(boss.name)
	boss.langchat_color = initial(boss.langchat_color)
