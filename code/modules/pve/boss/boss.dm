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

	var/boss_loop_override = 0
	var/datum/boss_action/boss_ability //The main ability datum, containing ALL boss abilities. Said datum is pretty disorganized :P

	// Needs to be set per mob. Used by automation script to determine when abilities were used and expected delays. Order in _log matters, it will be the order the AI tries to fire the abilities which can produce some minor changes in behavior

	var/list/ability_log = list()
	var/list/ability_delays = list()

	//Individual skill values should also be defined here. This can be pushed down the tree by messing with the boss_ability datum (specfically plug in something from down its own tree to it with a custom set or waht have you), but I dont feel like doing that.
	var/standard_range_salvo_count = 3
	var/standard_range_salvo_delay = 3
	var/explosion_damage = 15
	var/aoe_delay = 50
	var/missile_storm_missiles = 25
	//Handles missile storm targeting. This list makes sure that people who were already hit arent targetted again.
	var/list/hit_by_explosions = list()

	//movement control
	var/turf/movement_target
	var/movement_switch = 0
	var/list/movement_turfs = list()

	//npc drone spawning
	var/list/drone_turfs = list()
	var/boss_add_phase = 0
	var/boss_adds_spawned = 0
	var/boss_adds_spawned_max = 4
	var/boss_add_phases_cleared = 0

	//pain goes here. Also the AI datum.
	var/datum/boss_ai/ai_datum
	var/boss_delays_started = 0
	var/GlobalCoolDown = 15		//Ability cooldowns are multiplied by this. This also determines how often the firing proc is fired, so setting this too low with resource heavy abilities will cause hitching.

/mob/living/pve_boss/Move(NewLoc, direct)
	if(boss_immobilized == 1) return
	if(movement_switch == 0)
		return
	if(movement_switch == 1)
		movement_switch = 0
		. = ..()

/mob/living/pve_boss/proc/PhaseControl() // This is important for specific mobs, but the generic can be empty. This sets the abilities/stats/etc to the different phases, a critical element of the boss fight.
	return

/mob/living/pve_boss/Initialize()
	. = ..()
	boss_ability = new /datum/boss_action/(boss = src)
	click_intercept = new /datum/bossclicking/(boss = src)
	ai_datum = new /datum/boss_ai/(boss = src)
	PhaseControl()
	var/area/boss_area = get_area(src)
	if(boss_area.mob_spawners != null)
		for(var/obj/effect/landmark/pve_mob/mob_spawner in boss_area.mob_spawners)
			var/turf_to_add = get_turf(mob_spawner)
			drone_turfs.Add(turf_to_add)
	if(drone_turfs == null)
		message_admins("Warning: [src] spawned in an area without mob spawner waypoints. Add phase will not trigger. This may be intended.")
	if(boss_area.boss_waypoints != null)
		for(var/obj/effect/landmark/pve_boss_navigation/nav_waypoint in boss_area.boss_waypoints)
			var/turf_to_add = get_turf(nav_waypoint)
			movement_turfs.Add(turf_to_add)
	if(movement_turfs == null)
		message_admins("Warning: [src] spawned in an area without navigation waypoints. Movement automation offline.")

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
			return
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

/mob/living/pve_boss/proc/RestoreShield()
	boss_shield = boss_shield_max
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, animate_shield), 3)
	say("RESUMING PURGE PROTOCOL.")
	boss_shield_broken = 0
	boss_immobilized = 0

/mob/living/pve_boss/proc/ShieldDown()
	boss_shield_broken = 1
	boss_immobilized = 1
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, EmergencyAction))
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
	color = initial(color)

/mob/living/pve_boss/proc/AddPhaseCheck()
	switch(GLOB.boss_stage)
		if(1)
			if(boss_add_phases_cleared == 0)
				if(boss_shield <= (boss_shield_max / 2))
					boss_adds_spawned_max = 4
					ai_datum.add_phase()
					return
		if(2)
			if(boss_add_phases_cleared == 0)
				if(boss_shield <= ((boss_shield_max / 3)*2))
					boss_adds_spawned_max = 8
					ai_datum.add_phase()
					return
			if(boss_add_phases_cleared == 1)
				if(boss_shield <= ((boss_shield_max / 3)))
					boss_adds_spawned_max = 8
					ai_datum.add_phase()
					return
		if(3)
			if(boss_add_phases_cleared == 0)
				if(boss_shield <= ((boss_shield_max / 4)*3))
					boss_adds_spawned_max = 8
					ai_datum.add_phase()
					return
			if(boss_add_phases_cleared == 1)
				if(boss_shield <= ((boss_shield_max / 4)*2))
					boss_adds_spawned_max = 8
					ai_datum.add_phase()
					return
			if(boss_add_phases_cleared == 2)
				if(boss_shield <= (boss_shield_max / 4))
					boss_adds_spawned_max = 12
					ai_datum.add_phase()
					return
		if(4)
			if(boss_add_phases_cleared == 0)
				if(boss_shield <= (boss_shield_max / 2))
					boss_adds_spawned_max = 16
					ai_datum.add_phase()
					return

/mob/living/pve_boss/proc/AddPhaseResolutionCheck()
	if(boss_adds_spawned <= 0)
		ai_datum.add_phase_finish()
		return

/mob/living/pve_boss/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	if(boss_no_damage == 1) return
	if(boss_health <= 0) return
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
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/, AddPhaseCheck))
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

/mob/living/pve_boss/Destroy()
	boss_loop_override = 1
	. = ..()

/datum/boss_action/

	var/mob/owner = null


/datum/boss_action/New(mob/boss)
	. = ..()
	owner = boss

/mob/living/pve_boss/proc/AnimateEntry()
	return

/mob/living/pve_boss_drone
	name = "B-6A supression drone"
	desc = "A flying object that fires a laser. Seems straightforward enough."
	icon = 'icons/Surge/boss_bot/drone.dmi'
	icon_state = "drone"

	var/obj/effect/landmark/pve_mob/source_landmark

	var/drone_health = 5
	var/drone_delay = 50
	var/drone_no_damage = 0
	var/drone_attack_breakpoint = 0
	var/drone_last_fired = 0
	var/drone_no_animation = 0

/mob/living/pve_boss_drone/proc/fire_on_target(turf/target)
	var/turf/drone_target = target
	if(drone_attack_breakpoint == 1) return
	if(!drone_target) return
	if((drone_last_fired + 10) > world.time) return
	if(drone_attack_breakpoint == 0)
		animate(src,color = "#FF0000", time = 3)
		animate(color = "#FFFFFF", time = 3)
		animate(color = "#FF0000", time = 3)
	sleep(10)
	if(drone_attack_breakpoint == 0)
		var/obj/projectile/projectile = new /obj/projectile(src.loc, create_cause_data("[src.name]"), src)
		var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/laser]
		projectile.generate_bullet(ammo_datum)
		projectile.fire_at(drone_target, src, src, ammo_datum.max_range, ammo_datum.shell_speed)
		drone_last_fired = world.time
		animate(src, color = "#FFFFFF", time = 3)
		sleep(3)
	color = "#FFFFFF"
	return

/mob/living/pve_boss_drone/proc/scan_cycle()
	if(drone_attack_breakpoint == 1) return
	for(var/mob/living/carbon/human/potential_target in range(12,src))
		if(potential_target)
			var/target_turf = get_turf(potential_target)
			if(!target_turf) return
			fire_on_target(target_turf)
	sleep(10)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss_drone/, scan_cycle))
	return

/mob/living/pve_boss_drone/proc/DeathAnim()
	icon_state = initial(icon_state) + "_dead"
	update_icons()
	if(source_landmark) source_landmark.mob_destroyed = 1
	var/turf/drone_turf = get_turf(src)
	if(drone_turf) drone_turf.vis_contents += src
	var/flip_angle = rand(30,150)
	flip_angle = pick(flip_angle, -flip_angle)
	var/angle_low = floor(flip_angle / 2)
	var/angle_high = ceil(flip_angle / 2)
	var/matrix/A = matrix()
	var/matrix/B = matrix()
	color = "#FFFFFF"
	A.Turn(angle_low)
	B.Turn(angle_high)
	var/anim_height = rand(10,30)
	anim_height = pick(anim_height, -anim_height)
	var/anim_height_low = floor(anim_height / 2)
	var/anim_height_high = ceil(anim_height / 2)
	var/anim_width = rand(10,30)
	anim_width = pick(anim_width, -anim_width)
	var/anim_width_low = floor(anim_width / 2)
	var/anim_width_high = ceil(anim_width / 2)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(3, 1, src)
	sparks.start()
	animate(src, time = 3, transform = A, pixel_x = anim_width_low, pixel_y = anim_height_low, easing=QUAD_EASING|EASE_IN, flags = ANIMATION_RELATIVE)
	animate(time = 3, transform = B, pixel_x = anim_width_high, pixel_y = anim_height_high, easing=QUAD_EASING|EASE_OUT, flags = ANIMATION_RELATIVE)
	sleep(30)
	qdel(src)

/mob/living/pve_boss_drone/apply_damage(damage, damagetype, def_zone, used_weapon, sharp, edge, force)
	if(drone_health <= 0) return
	if(drone_no_damage == 0)
		drone_health -= 1
		if(drone_health <= 0)
			drone_attack_breakpoint = 1
			DeathAnim()

/mob/living/pve_boss_drone/Destroy()
	drone_attack_breakpoint = 1
	GLOB.boss_drones.Remove(src)
	if(source_landmark)
		source_landmark.spawned_bot = null
		source_landmark = null
	. = ..()

/mob/living/pve_boss_drone/proc/AnimateEntry()
	drone_no_damage = 1
	pixel_y = 300
	animate(src, pixel_y = 0, time = 15, easing = CUBIC_EASING|EASE_IN)
	sleep(15)
	drone_no_damage = 0

/mob/living/pve_boss_drone/proc/AnimateExit()
	var/turf/drone_turf = get_turf(src)
	if(drone_turf)
		drone_turf.vis_contents += src
	animate(src, pixel_y = 300, time = 15, easing = CUBIC_EASING|EASE_IN)

/mob/living/pve_boss_drone/Initialize()
	. = ..()
	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)
	GLOB.boss_drones.Add(src)
	if(drone_no_animation == 0)
		INVOKE_ASYNC(src,TYPE_PROC_REF(/mob/living/pve_boss_drone/,AnimateEntry))
	INVOKE_ASYNC(src,TYPE_PROC_REF(/mob/living/pve_boss_drone/,scan_cycle))


/mob/living/pve_boss_drone/boss_variant

	name = "Baltheus-6A Damage Deferral Drone"
	icon_state = "boss_drone"
	var/mob/living/pve_boss/boss_mob

/mob/living/pve_boss_drone/boss_variant/DeathAnim()
	if(boss_mob)
		boss_mob.boss_adds_spawned -= 1
		boss_mob.AddPhaseResolutionCheck()
	. = ..()
