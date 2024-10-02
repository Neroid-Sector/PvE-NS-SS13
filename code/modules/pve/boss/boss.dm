//Critical defines go here. Why here and not where Cm keeps its ohter defines? Because I'm tired of constantly having to look somewhere else during dev.


/mob/living/pve_boss
	icon = 'icons/Surge/surge_default.dmi'
	icon_state = "default"
	name = "Boss entities and associated procs. This should not be out in the wild."
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS|SEE_THRU|SEE_INFRA
	//Xenosurge vars that go here for same reasons as above
	var/boss_type = "default"
	//below should be safely disregarded if type is not set to 1
	var/boss_stage = 1 // Boss powers get stronger depenidng on stage, this should be trigerred during major events or at HP pool ammoutns, dealers choice
	var/datum/boss_action/boss_ability //The main ability datum, containing ALL boss abilities. Said datum is pretty disorganized :P

	var/list/boss_abilities = list() // This regulates which skills are available.

	// None of these should be touched, they are used by the datums for reference.
	var/list/ability_cooldowns = list()
	var/current_ability
	var/action_activated = 0
	var/list/action_cooldowns = list()
	var/list/action_last_use_time = list()

	//Individual skill values should also be defined here. This can be pushed down the tree by messing with the boss_ability datum (specfically plug in something from down its own tree to it with a custom set or waht have you), but I dont feel like doing that.
	var/explosion_damage = 30
	var/aoe_delay = 40
	var/missile_storm_missiles = 25

	//movement resuming after destruction calls
	var/turf/movement_target

/mob/living/pve_boss/Initialize()
	. = ..()
	boss_ability = new /datum/boss_action/(boss = src)
	click_intercept = new /datum/bossclicking/(boss = src)

/mob/living/pve_boss/Bump(Obstacle)
	if(istype(Obstacle, /turf/closed))
		var/turf/closed/bumped_turf = Obstacle
		var/saved_icon = bumped_turf.icon
		var/saved_icon_state
		if(istype(Obstacle, /turf/closed/wall))
			var/turf/closed/wall/no_base_icon_state_turf = Obstacle
			saved_icon_state = no_base_icon_state_turf.walltype
		else
			saved_icon_state = bumped_turf.icon_state
		var/saved_turf_x = bumped_turf.x
		var/saved_turf_y = bumped_turf.y
		var/saved_turf_z = bumped_turf.z
		var/saved_dir = bumped_turf.dir
		bumped_turf.ScrapeAway(INFINITY, CHANGETURF_DEFER_CHANGE)
		var/turf_ref = locate(saved_turf_x,saved_turf_y,saved_turf_z)
		boss_ability.icon_chunk(saved_icon,saved_icon_state,saved_dir,turf_ref)
	if(istype(Obstacle, /turf/open))
		var/turf/open/open_turf = Obstacle
		src.forceMove(open_turf)
	else if(istype(Obstacle, /obj))
		var/obj/bumped_obj = Obstacle
		var/saved_icon = bumped_obj.icon
		var/saved_icon_state = bumped_obj.icon_state
		var/turf/saved_turf = get_turf(bumped_obj)
		var/saved_dir = bumped_obj.dir
		qdel(bumped_obj)
		boss_ability.icon_chunk(saved_icon,saved_icon_state,saved_dir,saved_turf)
	else if(istype(Obstacle, /mob))
		var/mob/bumped_mob = Obstacle
		var/facing = get_dir(get_turf(src), bumped_mob)
		var/turf/throw_turf = get_turf(src)
		var/turf/temp = get_turf(src)

		for (var/x in 0 to 3)
			temp = get_step(throw_turf, facing)
			if (!temp)
				break
			throw_turf = temp
		bumped_mob.throw_atom(throw_turf, 4, SPEED_VERY_FAST, src, TRUE)
	if(movement_target) boss_ability.accelerate_to_target(movement_target, on_bump = TRUE)
	. = ..()


/datum/boss_action/

	var/mob/owner = null


/datum/boss_action/New(mob/boss)
	. = ..()
	owner = boss

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
