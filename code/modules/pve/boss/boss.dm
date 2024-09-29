//Critical defines go here. Why here and not where Cm keeps its ohter defines? Because I'm tired of constantly having to look somewhere else during dev.


/mob/living/pve_boss
	icon = 'icons/Surge/surge_default.dmi'
	icon_state = "default"
	name = "Boss entities and associated procs. This should not be out in the wild."
	//Xenosurge vars that go here for same reasons as above
	var/boss_type = "default"
	//below should be safely disregarded if type is not set to 1
	var/boss_stage = 1
	var/datum/boss_action/boss_ability = /datum/boss_action/
	var/datum/bossclicking/boss_click_intercept = /datum/bossclicking/
	var/list/boss_abilities = list()
	var/list/ability_cooldowns = list()
	var/explosion_damage = 30
	var/aoe_delay = 40
	var/missile_storm_missiles = 25
	var/current_ability
	var/action_activated = 0
	var/list/action_cooldowns = list()
	var/list/action_last_use_time = list()

/mob/living/pve_boss/Initialize()
	. = ..()
	boss_ability.set_owner(src)
	boss_click_intercept.AssignMob(src)
	click_intercept = boss_click_intercept

/datum/boss_action/

	var/mob/owner = null


/datum/boss_action/proc/set_owner(mob/owner_mob) // Assigns owner reference, makes some of the ability code easier. null will null the owner value.
	if(!owner_mob)
		if(owner)
			owner = null
		else
			return
	owner = owner_mob
	return

/datum/boss_action/proc/switch_action() // Called to switch the active action. This also defines which action is getting its cooldown set etc
	var/mob/living/pve_boss/boss_mob = owner
	var/ability_pos = boss_mob.boss_abilities.Find(boss_mob.current_ability)
	if(ability_pos == 0)
		to_chat(usr, SPAN_WARNING("Boss ability not found. Misconfiguration likely."))
		return

/datum/boss_action/proc/apply_cooldown(cooldown)
	var/mob/living/pve_boss/boss_mob = owner
	if(cooldown)
		boss_mob.action_cooldowns[boss_mob.current_ability] = cooldown
	boss_mob.action_last_use_time[boss_mob.current_ability] = world.time

/datum/boss_action/proc/action_cooldown_check()
	var/mob/living/pve_boss/boss_mob = owner
	if(boss_mob.action_activated) return 0
	if(!boss_mob.action_last_use_time[boss_mob.current_ability])
		return 1
	else if(world.time > boss_mob.action_last_use_time[boss_mob.current_ability] + boss_mob.action_cooldowns[boss_mob.current_ability])
		return 1
	else
		return 0
