/mob/living/pve_boss
	icon = 'icons/Surge/surge_default.dmi'
	icon_state = "default"
	name = "Boss entities and associated procs. This should not be out in the wild."
	//Xenosurge vars that go here for same reasons as above
	var/boss_type = "default"
	//below should be safely disregarded if type is not set to 1
	var/boss_stage = 1
	var/datum/boss_action/boss_ability
	var/explosion_damage = 30
	var/aoe_delay = 40
	var/missile_storm_missiles = 25

/mob/living/pve_boss/Initialize()
	boss_ability.set_owner(src)
	. = ..()


/datum/boss_action/
	var/mob/owner = null
	var/action_activated = 0
	var/action_delay = 10
	var/action_last_use_time

/datum/boss_action/proc/set_owner(mob/owner_mob)
	owner = owner_mob
	return

/datum/boss_action/proc/apply_cooldown(cooldown)
	if(cooldown)
		action_delay = cooldown
	action_last_use_time = world.time


/datum/boss_action/proc/trigger_boss_skill(atom/affected_atom, mob/owner) // Default proccall for boss skills
	return

/datum/boss_action/proc/action_cooldown_check()
	if(action_activated) return 0
	if(!action_last_use_time)
		return 1
	else if(world.time > action_last_use_time + action_delay)
		return 1
	else
		return 0
