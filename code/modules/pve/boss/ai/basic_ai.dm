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
	if(boss_mob.boss_loop_override == 1) return
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
	if(boss_mob.boss_loop_override == 1) return
	var/ability_to_use = ability_name
	switch(ability_to_use)
		if("shot")
			boss.boss_ability.fire_cannon(target)
		if("aoe_shot")
			boss.boss_ability.surge_proj(target)
		if("missiles")
			boss.boss_ability.rapid_missles(target)
	return


/datum/boss_ai/proc/combat_loop()
	var/mob/living/pve_boss/boss = boss_mob
	var/mob/living/pve_boss/boss_turf = get_turf(boss)
	if(boss_mob.boss_loop_override == 1) return
	var/list/abilities_to_try = list()
	if(boss.ability_log == null)
		message_admins("[boss] has no ability_log. Combat loop cannot initialize.")
		return
	var/list/poitential_targets = list()
	for(var/mob/living/carbon/human/human_mob in range(10,boss_turf))
		poitential_targets += human_mob
	if(poitential_targets.len > 0)
		var/final_target = get_turf(pick(poitential_targets))
		abilities_to_try = boss.ability_log
		while(abilities_to_try.len > 0)
			if(world.time > boss.ability_delays[abilities_to_try[1]])
				INVOKE_ASYNC(src,PROC_REF(use_ability),abilities_to_try[1],final_target)
				abilities_to_try = list()
				break
			else
				abilities_to_try.Cut(1,2)
	sleep(10)
	INVOKE_ASYNC(src,PROC_REF(combat_loop))
	return
