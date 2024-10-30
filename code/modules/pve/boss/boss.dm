//Critical defines go here. Why here and not where Cm keeps its ohter defines? Because I'm tired of constantly having to look somewhere else during dev.


/mob/living/pve_boss
	icon = 'icons/Surge/surge_default.dmi'
	icon_state = "default"
	name = "Boss entities and associated procs. This should not be out in the wild."
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS|SEE_THRU|SEE_INFRA
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	//Xenosurge vars that go here for same reasons as above
	var/boss_type = "default"
	var/boss_alpha = 0 // Setting this to 1 bypasses intro and mid phase flavor texts/actions
	//below should be safely disregarded if type is not set to 1
	var/boss_shield_max = 0
	var/boss_shield = 0 // This will also be the shields max value on spawn for simplicity
	var/boss_shield_reset_delay = 0
	var/boss_health = 0

	var/boss_exposed = 0
	var/boss_no_damage = 0
	var/boss_immobilized = 0

	var/boss_shield_broken = 0
	var/boss_critical_available = 0

	var/datum/boss_action/boss_ability //The main ability datum, containing ALL boss abilities. Said datum is pretty disorganized :P

	// None of these should be touched, they are used by the datums for reference.
	var/action_activated = 0

	//Individual skill values should also be defined here. This can be pushed down the tree by messing with the boss_ability datum (specfically plug in something from down its own tree to it with a custom set or waht have you), but I dont feel like doing that.
	var/standard_range_salvo_count = 3
	var/standard_range_salvo_delay = 3
	var/explosion_damage = 15
	var/aoe_delay = 50
	var/missile_storm_missiles = 25
	//Handles missile storm targeting. This list makes sure that people who were already hit arent targetted again.
	var/list/hit_by_explosions = list()

	//movement resuming after destruction calls
	var/turf/movement_target
	var/movement_switch = 0

/mob/living/pve_boss/Move(NewLoc, direct)
	if(boss_immobilized == 1) return
	if(movement_switch == 0)
		return
	if(movement_switch == 1)
		movement_switch = 0
		. = ..()

/mob/living/pve_boss/Initialize()
	. = ..()
	boss_ability = new /datum/boss_action/(boss = src)
	click_intercept = new /datum/bossclicking/(boss = src)
	boss_shield_max = boss_shield

/mob/living/pve_boss/update_icons()
	overlays.Cut()
	overlays += image(icon, src, icon_state)

/mob/living/pve_boss/proc/CheckSpaceTurf(turf/target_turf)
	if(!target_turf) return
	var/turf/turf_to_check = target_turf
	var/turf_to_check_x = turf_to_check.x
	var/turf_to_check_y = turf_to_check.y
	var/turf_to_check_z = turf_to_check.z
	var/list/turf_to_check_neighbors = list()
	turf_to_check_neighbors.Add(locate((turf_to_check_x + 1),turf_to_check_y,turf_to_check_z),locate((turf_to_check_x - 1),turf_to_check_y,turf_to_check_z),locate(turf_to_check_x,(turf_to_check_y + 1),turf_to_check_z),locate(turf_to_check_x,(turf_to_check_y - 1),turf_to_check_z))
	for (var/turf/neighbor_checked in turf_to_check_neighbors)
		if(istype(turf_to_check_neighbors,/turf/open/space))
			return 1
	return 0


/mob/living/pve_boss/Bump(Obstacle)
	if(istype(Obstacle, /turf/))
		if(CheckSpaceTurf(Obstacle) == 1)
			var/turf/obstacle_turf = get_turf(Obstacle)
			src.forceMove(obstacle_turf)
		else
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
				new /obj/effect/shockwave(bumped_turf, 3)
			if(istype(Obstacle, /turf/open))
				var/turf/open/open_turf = Obstacle
				src.forceMove(open_turf)
	if(istype(Obstacle, /obj))
		var/obj/bumped_obj = Obstacle
		var/saved_icon = bumped_obj.icon
		var/saved_icon_state = bumped_obj.icon_state
		var/turf/saved_turf = get_turf(bumped_obj)
		var/saved_dir = bumped_obj.dir
		qdel(bumped_obj)
		boss_ability.icon_chunk(saved_icon,saved_icon_state,saved_dir,saved_turf)
		new /obj/effect/shockwave(saved_turf, 3)
	if(istype(Obstacle, /mob))
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
	if(movement_target) boss_ability.process_regular_movement(on_bump = TRUE)
	. = ..()

/obj/item/prop/shield_ping
	name = "Shield ping icon animation."
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = 6
	icon = 'icons/Surge/boss_bot/boss.dmi'
	icon_state = "shield"

/mob/living/pve_boss/proc/animate_shield(type)
	if(!type) return
	var/obj/item/prop/shield_ping/ping_object = new()
	ping_object.color = "#FF0000"
	switch(type)
		if(1)
			var/shield_proportion = (round((boss_shield / boss_shield_max),0.01))
			var/alpha_value = 255 * shield_proportion
			ping_object.alpha = 1
			animate(ping_object,alpha = alpha_value, easing = CIRCULAR_EASING|EASE_IN, time = 2)
			animate(alpha = 1, easing = CIRCULAR_EASING|EASE_OUT, time = 2)
		if(2)
			ping_object.alpha = 255
			var/matrix/A = matrix()
			A.Scale(3)
			animate(ping_object,alpha = 1,transform = A, easing = SINE_EASING|EASE_IN, time = 3)
		if(3)
			ping_object.alpha = 1
			ping_object.color = "#FF0000"
			var/matrix/A = matrix()
			var/matrix/B = matrix()
			A.Scale(2)
			ping_object.apply_transform(A)
			B.Scale(1)
			animate(ping_object,alpha = 255,transform = B, easing = SINE_EASING|EASE_IN, time = 3)
			animate(alpha = 1, easing = SINE_EASING|EASE_IN, time = 1)

	src.vis_contents += ping_object
	sleep(5)
	src.vis_contents -= ping_object
	qdel(ping_object)

/mob/living/pve_boss/proc/EmergencyAction()
	say("SHIELD DOWN. INITIATING EMERGENCY DETERENCE.")
	boss_ability.WardingFire()

/mob/living/pve_boss/proc/ShieldDown()
	boss_shield_broken = 1
	boss_immobilized = 1
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, EmergencyAction))
	if(GLOB.boss_stage < 3)
		sleep(rand(300,600))
		if(boss_health > 0)
			boss_shield = boss_shield_max
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, animate_shield), 3)
			say("RESUMING PURGE PROTOCOL.")
			boss_shield_broken = 0
			boss_immobilized = 0
	return

/mob/living/pve_boss/proc/BossStage()
	boss_no_damage = 1
	walk_towards(src, null)
	boss_immobilized = 1
	if(GLOB.boss_stage < GLOB.boss_stage_max)
		GLOB.boss_stage += 1
		animate(src, pixel_y = 200, time = 10, easing = CUBIC_EASING|EASE_IN)
		visible_message("activates an emergency thruster and smashes through the ceiling!")
		to_chat(world, SPAN_WARNING("The platform smashes through the ceiling and out of sight. Emergency shutters seal the breach."))
		sleep(10)
		qdel(src)
	else
		src.death(gibbed = FALSE, deathmessage = "loses power to its engines, spins in place, smashes into the ground and shuts down.", should_deathmessage = TRUE)

/mob/living/pve_boss/proc/animate_hit()
	var/color_value = "#FF0000"
	var/max_health = initial(boss_health)
	var/pixel_x_org = pixel_x
	var/pixel_y_org = pixel_y
	var/pixel_x_val = rand(0,2)
	var/pixel_y_val = rand(0,2)
	var/health_proportion = round((boss_health / max_health),0.1)
	switch(health_proportion)
		if(1)
			color_value = "#ffecdd"
		if(0.9)
			color_value = "#ffdfc5"
		if(0.8)
			color_value = "#ffcba1"
		if(0.7)
			color_value = "#ffbf8b"
		if(0.6)
			color_value = "#ffb272"
		if(0.5)
			color_value = "#ffa052"
		if(0.4)
			color_value= "#ff8928"
		if(0.3)
			color_value = "#ff811a"
		if(0.2)
			color_value = "#ff790b"
		if(0.1)
			color_value = "#ff5e00"
		if(0)
			color_value = "#ff0000"
	animate(src, pixel_x = pixel_x_val, pixel_y = pixel_y_val, color = color_value, time = 1)
	animate(color = "#FFFFFF", pixel_x = pixel_x_org, pixel_y = pixel_y_org, time = 1)


/mob/living/pve_boss/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	if(boss_no_damage == 1) return
	var/damage_ammount = damage
	GLOB.stats_boss_total_damage += damage_ammount
	GLOB.stats_boss_hits += 1
	damage_ammount = 1
	if(boss_shield > 0)
		if(boss_exposed == 1) damage_ammount *= 3
		boss_shield -= damage_ammount
		if(boss_alpha == 1) to_chat(world, SPAN_INFO("SHIELD|D:[damage_ammount]|S:[boss_shield]"))
		if(boss_shield > 0)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, animate_shield), 1)
		else
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, animate_shield), 2)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, ShieldDown))
		return
	else
		if((boss_health - damage_ammount) <= 0)
			if(boss_alpha == 1) to_chat(world, SPAN_INFO("HEALTH|D:[damage_ammount]|H:[boss_health]"))
			boss_health = 0
			BossStage()
			return
		else
			if(boss_alpha == 1) to_chat(world, SPAN_INFO("HEALTH|D:[damage_ammount]|H:[boss_health]"))
			boss_health -= damage_ammount
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, animate_hit))

/datum/boss_action/

	var/mob/owner = null


/datum/boss_action/New(mob/boss)
	. = ..()
	owner = boss


/datum/boss_action/proc/action_cooldown_check()
	var/mob/living/pve_boss/boss_mob = owner
	if(boss_mob.action_activated) return 0


/datum/boss_action/proc/usage_cooldown_loop(amount)
	var/mob/living/pve_boss/boss_mob = owner
	if(!amount) return
	boss_mob.action_activated = 1
	sleep(amount)
	boss_mob.action_activated = 0

/mob/living/pve_boss/proc/AnimateEntry()
	return
