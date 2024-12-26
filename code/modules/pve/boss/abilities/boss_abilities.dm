//Multi target projectile

/mob/living/carbon/human/proc/warning_ping(text)
	var/text_to_send
	if(!text)
		text_to_send = "A Surge is targeting you with a special attack!"
	else
		text_to_send = text
	to_chat(src, SPAN_BOLDWARNING(text_to_send))
	overlays += (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	sleep(40)
	overlays -= (image('icons/effects/surge_hit_warning.dmi', "aoe"))

/datum/boss_action/proc/surge_proj(atom/affected_atom)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	var/list/mobs_in_range = list()
	for(var/mob/living/carbon/human/target in range("15x15",boss))
		if(mobs_in_range.Find(target) == 0)
			mobs_in_range.Add(target)
	if(mobs_in_range.len == 0)
		to_chat(boss, SPAN_WARNING("No potential targets in visible range"))
		return
	for(var/mob/living/carbon/human/target_to_warn in mobs_in_range)
		INVOKE_ASYNC(target_to_warn, TYPE_PROC_REF(/mob/living/carbon/human/, warning_ping),"The platforms laser visibly heats up as it charges a blast!")
	boss.overlays += (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	boss.boss_exposed = 1
	sleep(boss.aoe_delay)
	boss.overlays -= (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	boss.boss_exposed = 0
	playsound(boss, 'sound/items/pulse3.ogg', 50)
	for(var/mob/living/carbon/human/target_to_shoot in mobs_in_range)
		var/turf/target = get_turf(target_to_shoot)
		var/obj/projectile/projectile = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
		var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/surge_proj]
		projectile.generate_bullet(ammo_datum)
		projectile.fire_at(target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
		mobs_in_range.Remove(target_to_shoot)
	return

//missile barrage, picks a carbon from its z level and sends a missile towards them. Does this a lot, scaling up depending on phase

/obj/item/prop/missile_storm_up
	name = "going up"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/Surge/boss_bot/boss_proj.dmi'
	icon_state = "missile"

/obj/item/prop/missile_storm_up/proc/animate_takeoff()
	var/launch_x = pixel_x + rand(-2,2)
	animate(src,pixel_x=launch_x,pixel_y=384,time = 10,easing=QUAD_EASING|EASE_IN)
	sleep(11)
	qdel(src)

/obj/item/prop/missile_storm_up/Initialize(mapload, ...)
	. = ..()
	pixel_x = pick(-8,-2,2,8)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/prop/missile_storm_up/, animate_takeoff))

/obj/item/prop/missile_storm_down
	name = "going down"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/Surge/boss_bot/boss_proj.dmi'
	icon_state = "missile"


/obj/item/prop/missile_storm_down/proc/animate_landing()
	var/matrix/A = matrix()
	A.Turn(180)
	apply_transform(A)
	animate(src,pixel_x=0,pixel_y=0,time = 10,easing=QUAD_EASING|EASE_IN)
	sleep(11)
	qdel(src)

/obj/item/prop/missile_storm_down/Initialize(mapload, ...)
	. = ..()
	pixel_y = 384
	pixel_x = pick(-8,-2,2,8)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/prop/missile_storm_down/, animate_landing))

/datum/boss_action/proc/fire_animation()
	var/mob/living/pve_boss/boss = owner
	var/spawned_props = 1
	playsound(boss,'sound/surge/rockets_launching.ogg', 80)
	while(spawned_props <= boss.missile_storm_missiles)
		var/turf/owner_turf = get_turf(owner)
		new /obj/item/prop/missile_storm_up(owner_turf)
		spawned_props += 1
		sleep(2)

/obj/item/prop/explosion_fx
	name = "kaboom"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/Surge/effects/boss_boom.dmi'
	icon_state = "explosion"

/datum/boss_action/proc/AnimateThrow(turf/explpsion_center, thing)
	var/turf/current_turf = explpsion_center
	var/facing = get_dir(current_turf, thing)
	var/turf/throw_turf = current_turf
	var/turf/temp = current_turf
	for (var/x in 0 to 5)
		temp = get_step(throw_turf, facing)
		if (!temp)
			break
		throw_turf = temp
	var/atom/movable/atom_to_throw = thing
	atom_to_throw.throw_atom(throw_turf, 4, SPEED_VERY_FAST, src, TRUE)

/datum/boss_action/proc/ExplosionExclusionLoop(mob/living/carbon/passed_carbon/)
	var/mob/living/pve_boss/boss = owner
	var/mob/living/carbon/carbon_ref = passed_carbon
	boss.hit_by_explosions.Add(carbon_ref)
	sleep(50)
	boss.hit_by_explosions.Remove(carbon_ref)

/datum/boss_action/proc/explosion_proc(turf/explosion_center)
	var/center_turf = explosion_center
	var/list/range_list = range(3,center_turf)
	for (var/mob/living/carbon/carbon_to_throw in range_list)
		carbon_to_throw.apply_damage(15, BRUTE)
		AnimateThrow(center_turf,carbon_to_throw)
		INVOKE_ASYNC(src, PROC_REF(ExplosionExclusionLoop), carbon_to_throw)
	for(var/obj/item/item_to_throw in range_list)
		AnimateThrow(center_turf,item_to_throw)

/datum/boss_action/proc/hit_animation(turf/turf_to_hit_animate)
	var/turf/turf_to_hit_animation = turf_to_hit_animate
	turf_to_hit_animation.overlays += (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	sleep(30)
	turf_to_hit_animation.overlays -= (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	new /obj/item/prop/missile_storm_down(turf_to_hit_animation)
	sleep(10)
	var/obj/item/prop/explosion_fx/boom = new(turf_to_hit_animate)
	INVOKE_ASYNC(src, PROC_REF(explosion_proc),turf_to_hit_animation)
	sleep(10)
	qdel(boom)

/datum/boss_action/proc/fire_loop()
	var/mob/living/pve_boss/boss = owner
	var/turf/owner_turf = get_turf(owner)
	var/list/mobs_to_target = list()
	var/empty_loop_counter = 0
	for(var/mob/living/carbon/human/target_potential in world)
		var/turf/potential_target_turf = get_turf(target_potential)
		if(potential_target_turf)
			if(owner_turf.z == potential_target_turf.z)
				mobs_to_target += target_potential
	var/shots_fired = 0
	boss.boss_exposed = 1
	while(shots_fired < 25)
		if(mobs_to_target.len == 0) return
		var/list/temporary_mobs = mobs_to_target
		temporary_mobs.Remove(boss.hit_by_explosions)
		if(temporary_mobs.len == 0)
			if(empty_loop_counter <= 3)
				empty_loop_counter += 1
				sleep(30)
				break
			else
				return
		empty_loop_counter = 0
		var/mob/living/carbon/human/target_to_hit = pick(mobs_to_target)
		if(boss.hit_by_explosions.Find(target_to_hit) == 0)
			var/turf/turf_to_hit = get_turf(target_to_hit)
			var/list/turfs_to_hit = list()
			var/x_min = turf_to_hit.x - 2
			var/y_min = turf_to_hit.y - 2
			var/x_max = turf_to_hit.x + 2
			var/y_max = turf_to_hit.y + 2
			var/current_x = x_min
			var/current_y = y_min
			while(current_x <= x_max)
				while(current_y <= y_max)
					var/turf/checked_turf = locate(current_x, current_y, turf_to_hit.z)
					if(istype(checked_turf, /turf/open))
						turfs_to_hit += checked_turf
					current_y += 1
				current_y = y_min
				current_x += 1
			if(turfs_to_hit.len == 0) break
			var/turf/final_turf = pick(turfs_to_hit)
			to_chat(target_to_hit, SPAN_BOLDWARNING("One of the missiles in the swarm is headed right for you! Run!"))
			INVOKE_ASYNC(src, PROC_REF(hit_animation), final_turf)
			sleep(rand(8,12))
	boss.boss_exposed = 0

/datum/boss_action/proc/rapid_missles(atom/affected_atom)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	boss.hit_by_explosions = list()
	var/turf/target_turf = get_turf(affected_atom)
	for(var/mob/living/carbon/human/target in world)
		var/turf/mob_turf = get_turf(target)
		if(mob_turf)
			if(mob_turf.z == target_turf.z)
				to_chat(target, SPAN_BOLDWARNING("A torrent of missiles takes to the air!"))
	INVOKE_ASYNC(src, PROC_REF(fire_animation))
	INVOKE_ASYNC(src, PROC_REF(fire_loop))
	return

/obj/item/prop/arrow
	name = "Its an arrow. Catch if if you can."
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/Surge/effects/arrow.dmi'
	icon_state = "arrow"

/obj/item/prop/arrow/proc/warning_animation(anim_type)
	if(!anim_type) return
	var/loop_number = 1
	switch(anim_type)
		if(null)
			return
		if(1)
			var/matrix/A = matrix()
			A.Turn(45)
			apply_transform(A)
			pixel_x = 12
			pixel_y = -12
			while(loop_number <= 5)
				animate(src, pixel_x = 64,pixel_y=-64,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = 12
				pixel_y = -12
				loop_number += 1
				sleep(3)
		if(2)
			var/matrix/A = matrix()
			A.Turn(135)
			apply_transform(A)
			pixel_x = -12
			pixel_y = -12
			while(loop_number <= 5)
				animate(src, pixel_x = -64,pixel_y=-64,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = -12
				pixel_y = -12
				loop_number += 1
				sleep(3)
		if(3)
			var/matrix/A = matrix()
			A.Turn(225)
			apply_transform(A)
			pixel_x = -12
			pixel_y = 12
			while(loop_number <= 5)
				animate(src, pixel_x = -64,pixel_y=64,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = -12
				pixel_y = 12
				loop_number += 1
				sleep(3)
		if(4)
			var/matrix/A = matrix()
			A.Turn(315)
			apply_transform(A)
			pixel_x = 12
			pixel_y = 12
			while(loop_number <= 5)
				animate(src, pixel_x = 64,pixel_y=64 ,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = 12
				pixel_y = 12
				loop_number += 1
				sleep(3)
		if(5)
			var/matrix/A = matrix()
			A.Turn(225)
			apply_transform(A)
			pixel_x = 64
			pixel_y = -64
			while(loop_number <= 5)
				animate(src, pixel_x = 16,pixel_y=-16 ,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = 64
				pixel_y = -64
				loop_number += 1
				sleep(3)
		if(6)
			var/matrix/A = matrix()
			A.Turn(315)
			apply_transform(A)
			pixel_x = -64
			pixel_y = -64
			while(loop_number <= 5)
				animate(src, pixel_x = -16,pixel_y=-16 ,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = -64
				pixel_y = -64
				loop_number += 1
				sleep(3)
		if(7)
			var/matrix/A = matrix()
			A.Turn(45)
			apply_transform(A)
			pixel_x = -64
			pixel_y = 64
			while(loop_number <= 5)
				animate(src, pixel_x=-16,pixel_y=16,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = -64
				pixel_y = 64
				loop_number += 1
				sleep(3)
		if(8)
			var/matrix/A = matrix()
			A.Turn(135)
			apply_transform(A)
			pixel_x = 64
			pixel_y = 64
			while(loop_number <= 5)
				animate(src, pixel_x =16,pixel_y=16,time=7,easing=LINEAR_EASING)
				sleep(10)
				pixel_x = 64
				pixel_y = 64
				loop_number += 1
				sleep(3)
	qdel(src)

/datum/boss_action/proc/animate_warnings(turf/target)
	var/mob/living/pve_boss/boss = owner
	var/turf/owner_turf = get_turf(boss)
	var/turf/target_turf = target
	var/obj/item/prop/arrow/target_se = new(target_turf)
	var/obj/item/prop/arrow/target_sw = new(target_turf)
	var/obj/item/prop/arrow/target_nw = new(target_turf)
	var/obj/item/prop/arrow/target_ne = new(target_turf)
	var/obj/item/prop/arrow/owner_se = new(owner_turf)
	var/obj/item/prop/arrow/owner_sw = new(owner_turf)
	var/obj/item/prop/arrow/owner_nw = new(owner_turf)
	var/obj/item/prop/arrow/owner_ne = new(owner_turf)
	INVOKE_ASYNC(owner_se, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),1)
	INVOKE_ASYNC(owner_sw, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),2)
	INVOKE_ASYNC(owner_nw, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),3)
	INVOKE_ASYNC(owner_ne, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),4)
	INVOKE_ASYNC(target_se, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),5)
	INVOKE_ASYNC(target_sw, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),6)
	INVOKE_ASYNC(target_nw, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),7)
	INVOKE_ASYNC(target_ne, TYPE_PROC_REF(/obj/item/prop/arrow, warning_animation),8)

/datum/boss_action/proc/animate_movement(turf/target)
	var/mob/living/pve_boss/boss = owner
	var/turf/owner_turf = get_turf(boss)
	var/turf/target_turf = target
	var/x_distance = target_turf.x - owner_turf.x
	var/y_distance = target_turf.y - owner_turf.y
	var/new_pixel_y = boss.pixel_y + 5
	animate(boss, pixel_y = new_pixel_y , time = 5, easing=LINEAR_EASING)
	sleep(5)
	new_pixel_y = new_pixel_y + (y_distance * 32 + 96)
	var/new_pixel_x = boss.pixel_x + (x_distance * 32)
	animate(boss, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = 20, easing = CUBIC_EASING)
	if(boss.client)
		boss.client.perspective = EYE_PERSPECTIVE
		boss.client.eye = target_turf
	sleep(20)
	new_pixel_y = new_pixel_y + 10
	animate(boss, pixel_y = new_pixel_y , time = 5, easing=LINEAR_EASING)
	if(boss.client)
		boss.client.perspective = EYE_PERSPECTIVE
		boss.client.eye = target_turf
	sleep(5)
	new_pixel_y = initial(boss.pixel_y)
	animate(boss, pixel_y = new_pixel_y, time = 3, easing=QUAD_EASING|EASE_IN)
	if(boss.client)
		boss.client.perspective = EYE_PERSPECTIVE
		boss.client.eye = target_turf
	sleep(3)
	if(boss.client)
		boss.client.perspective = EYE_PERSPECTIVE
		boss.client.eye = target_turf
	return 1

/datum/boss_action/proc/process_movement(turf/target)
	var/mob/living/pve_boss/boss = owner
	var/turf/target_turf = target
	new /obj/effect/shockwave(target_turf, 4)
	boss.pixel_x = initial(boss.pixel_x)
	boss.pixel_y = initial(boss.pixel_y)
	boss.forceMove(target_turf)
	if(boss.client)
		boss.client.lazy_eye = 0
		boss.client.eye = boss.client.mob
		boss.client.perspective = MOB_PERSPECTIVE
	for(var/mob/living/carbon/carbon_in_range in range(3,target_turf))
		if(carbon_in_range == boss) continue
		if(carbon_in_range)
			var/facing = get_dir(target_turf, carbon_in_range)
			var/turf/throw_turf = target_turf
			var/turf/temp = target_turf

			for (var/x in 0 to 3)
				temp = get_step(throw_turf, facing)
				if (!temp)
					break
				throw_turf = temp
			carbon_in_range.throw_atom(throw_turf, 4, SPEED_VERY_FAST, boss, TRUE)

/datum/boss_action/proc/relocate(atom/target)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	if(boss.boss_immobilized == 1) return
	boss.movement_target = null
	walk(boss, 0)
	var/turf/targeted_turf = get_turf(target)
	animate_warnings(targeted_turf)
	boss.boss_exposed = 1
	sleep(50)
	boss.boss_exposed = 0
	animate_movement(targeted_turf)
	process_movement(targeted_turf)
	return

/obj/item/prop/ring_line
	name = "One and two thirds of the laser shot lock icon."
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	blend_mode = BLEND_OVERLAY
	layer = ABOVE_MOB_LAYER
	icon = 'icons/Surge/effects/ring.dmi'
	icon_state = "target_stripe"

/obj/item/prop/ring_rings
	name = "Its an arrow. Catch if if you can."
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	blend_mode = BLEND_OVERLAY
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER + 0.01
	icon = 'icons/Surge/effects/ring.dmi'
	icon_state = "target_rings"

/datum/boss_action/proc/handle_crosshair_animation(turf/target, type)
	switch(type)
		if(null)
			return
		if(1)
			var/obj/item/prop/ring_line/ring_line_left = new()
			var/obj/item/prop/ring_line/ring_line_right = new()
			var/obj/item/prop/ring_rings/ring_ring = new()
			var/turf/target_turf = target
			if(!target)return
			var/matrix/A = matrix()
			var/matrix/B = matrix()
			var/matrix/C = matrix()
			var/matrix/D = matrix()
			A.Turn(30)
			B.Turn(90)
			ring_line_left.apply_transform(A)
			ring_line_left.color = "#680606"
			C.Turn(-30)
			D.Turn(-90)
			ring_line_right.apply_transform(C)
			ring_line_right.color = "#680606"
			ring_ring.color = "#680606"

			animate(ring_line_left,transform = B, color = "#ff0000", time = 16, easing = LINEAR_EASING)
			animate(transform = E, color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)


			animate(ring_line_right, transform = D, color = "#ff0000", time = 16, easing = LINEAR_EASING)
			animate(color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)


			animate(ring_ring,color = "#ff0000", time = 16, easing = LINEAR_EASING)
			animate(color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

			target_turf.vis_contents += ring_line_left
			target_turf.vis_contents += ring_line_right
			target_turf.vis_contents += ring_ring
			sleep(50)
			target_turf.vis_contents -= ring_line_left
			target_turf.vis_contents -= ring_line_right
			target_turf.vis_contents -= ring_ring

			qdel(ring_line_right)
			qdel(ring_line_left)
			qdel(ring_ring)
		if(2)
			var/obj/item/prop/ring_line/ring_line_left = new()
			var/obj/item/prop/ring_line/ring_line_right = new()
			var/obj/item/prop/ring_rings/ring_ring = new()
			var/turf/target_turf = target
			ring_line_left.pixel_x = -16
			ring_line_right.pixel_x = 16
			ring_line_left.color = "#680606"
			ring_line_right.color = "#680606"
			ring_ring.color = "#680606"
			animate(ring_line_left,pixel_x = 16, color = "#ff0000", time = 30, easing = LINEAR_EASING)
			animate(transform = E, color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

			animate(ring_line_right, color = "#ff0000", time = 30, easing = LINEAR_EASING)
			animate(color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

			animate(ring_ring,color = "#ff0000", time = 30, easing = LINEAR_EASING)
			animate(color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

			target_turf.vis_contents += ring_line_left
			target_turf.vis_contents += ring_line_right
			target_turf.vis_contents += ring_ring
			sleep(35)
			target_turf.vis_contents -= ring_line_left
			target_turf.vis_contents -= ring_line_right
			target_turf.vis_contents -= ring_ring

			qdel(ring_line_right)
			qdel(ring_line_left)
			qdel(ring_ring)


/datum/boss_action/proc/fire_cannon(atom/target)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	var/turf/laser_target = get_turf(target)
	if(!laser_target) return
	boss.boss_exposed = 1
	INVOKE_ASYNC(src, PROC_REF(handle_crosshair_animation),laser_target,1)
	sleep(16)
	var/current_shot = 0
	while(current_shot < boss.standard_range_salvo_count)
		current_shot += 1
		var/obj/projectile/projectile = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
		var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/dbl_laser]
		projectile.generate_bullet(ammo_datum, bulllet_color = "#ff0000")
		projectile.fire_at(laser_target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
		sleep(boss.standard_range_salvo_delay)
	boss.boss_exposed = 0

/datum/boss_action/proc/process_regular_movement(on_bump = FALSE)
	var/mob/living/pve_boss/boss_mob = owner
	var/turf/owner_turf = get_turf(boss_mob)
	if(boss_mob.movement_target == null) return
	var/turf/target_turf = boss_mob.movement_target
	if(owner_turf == target_turf)
		target_turf = null
		return
	var/boss_velocity = 1
	if(on_bump == TRUE) boss_velocity = 3
	while(owner_turf != target_turf)
		boss_mob.movement_switch = 1
		step_towards(boss_mob,target_turf)
		owner_turf = get_turf(boss_mob)
		sleep(6 - boss_velocity)
		if(boss_velocity < 5) boss_velocity += 1
	target_turf = null
	return


/datum/boss_action/proc/move_destination(atom/target)
	var/mob/living/pve_boss/boss = owner
	if(boss.boss_immobilized == 1) return
	if(boss.movement_target == get_turf(boss)) boss.movement_target = null
	if(boss.movement_target != null) return
	var/turf/target_turf = get_turf(target)
	if(!target_turf) return
	if(target_turf == get_turf(boss)) return
	boss.movement_target = target_turf
	INVOKE_ASYNC(src, PROC_REF(process_regular_movement))
	to_chat(boss, SPAN_INFO("Coordinate locked in. Moving to target."))
	return

/datum/boss_action/proc/DirectionRef(direction)
	var/letter_to_return
	if(!direction)
		letter_to_return = pick("N","NNE","NE","NEE","E","SEE","SE","SSE","S","SSW","SW","SWW","W","NWW","NW","NWW")
	else
		switch(direction)
			if(1)
				letter_to_return = "N"
			if(2)
				letter_to_return = "NNE"
			if(3)
				letter_to_return = "NE"
			if(4)
				letter_to_return = "NEE"
			if(5)
				letter_to_return = "E"
			if(6)
				letter_to_return = "SEE"
			if(7)
				letter_to_return = "SE"
			if(8)
				letter_to_return = "SSE"
			if(9)
				letter_to_return = "S"
			if(10)
				letter_to_return = "SSW"
			if(11)
				letter_to_return = "SW"
			if(12)
				letter_to_return = "SWW"
			if(13)
				letter_to_return = "W"
			if(14)
				letter_to_return = "NWW"
			if(15)
				letter_to_return = "NW"
			if(16)
				letter_to_return = "NNW"
	return letter_to_return


/datum/boss_action/proc/WardingFire()
	var/mob/living/pve_boss/boss = owner
	var/turf/boss_turf = get_turf(boss)
	var/list/turfarray = list(
		"N" = locate(boss_turf.x,(boss_turf.y + 2),boss_turf.z),
		"NNE" = locate((boss_turf.x + 1),(boss_turf.y + 2),boss_turf.z),
		"NE" = locate((boss_turf.x + 2),(boss_turf.y + 2),boss_turf.z),
		"NEE" = locate((boss_turf.x + 2),(boss_turf.y + 1),boss_turf.z),
		"E" = locate((boss_turf.x + 2),boss_turf.y,boss_turf.z),
		"SEE" = locate((boss_turf.x + 2),(boss_turf.y - 1),boss_turf.z),
		"SE" = locate((boss_turf.x + 2),(boss_turf.y - 2),boss_turf.z),
		"SSE" = locate((boss_turf.x + 1),(boss_turf.y - 2),boss_turf.z),
		"S" = locate(boss_turf.x,(boss_turf.y - 2),boss_turf.z),
		"SSW" = locate((boss_turf.x - 1),(boss_turf.y - 2),boss_turf.z),
		"SW" = locate((boss_turf.x - 2),(boss_turf.y - 2),boss_turf.z),
		"SWW" = locate((boss_turf.x - 2),(boss_turf.y - 1),boss_turf.z),
		"W" = locate((boss_turf.x - 2),boss_turf.y,boss_turf.z),
		"NWW" = locate((boss_turf.x - 2),(boss_turf.y + 1),boss_turf.z),
		"NW" = locate((boss_turf.x - 2),(boss_turf.y + 2),boss_turf.z),
		"NNW" = locate((boss_turf.x - 1),(boss_turf.y + 2),boss_turf.z),
		)
	var/projectile_direction = rand(1,16)
	switch(GLOB.boss_stage)
		if(1)
			while(boss.boss_shield_broken == 1)
				if(boss.boss_loop_override == 1) return
				var/direction1 = DirectionRef(projectile_direction)
				playsound(boss, 'sound/items/pulse3.ogg', 50)
				var/turf/target = turfarray[direction1]
				var/obj/projectile/projectile = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/surge_proj]
				projectile.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile.fire_at(target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				if(projectile_direction < 16)
					projectile_direction += 1
				else
					projectile_direction = 1
				sleep(8)
			return
		if(2)
			while(boss.boss_shield_broken == 1)
				if(boss.boss_loop_override == 1) return
				var/direction1 = DirectionRef(projectile_direction)
				var/direction2
				if(projectile_direction <= 8)
					direction2 = DirectionRef(projectile_direction + 8)
				else
					direction2 = DirectionRef(projectile_direction - 8)
				playsound(boss, 'sound/items/pulse3.ogg', 50)
				var/turf/target = turfarray[direction1]
				var/turf/target2 = turfarray[direction2]
				var/obj/projectile/projectile1 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/obj/projectile/projectile2 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/surge_proj]
				projectile1.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile1.fire_at(target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				projectile2.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile2.fire_at(target2, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				if(projectile_direction < 16)
					projectile_direction += 1
				else
					projectile_direction = 1
				sleep(8)
		if(3,4)
			while(boss.boss_shield_broken == 1)
				if(boss.boss_loop_override == 1) return
				if(boss.boss_health <= 0) return
				var/obj/projectile/projectile1 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/obj/projectile/projectile2 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/obj/projectile/projectile3 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/obj/projectile/projectile4 = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
				var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/surge_proj]
				var/direction1 = DirectionRef(projectile_direction)
				var/direction2
				if(projectile_direction <= 8)
					direction2 = DirectionRef(projectile_direction + 8)
				else
					direction2 = DirectionRef(projectile_direction - 8)
				var/direction3
				if(projectile_direction <= 12)
					direction3 = DirectionRef(projectile_direction + 4)
				else
					direction3 = DirectionRef(projectile_direction - 12)
				var/direction4
				if(projectile_direction <= 4)
					direction4 = DirectionRef(projectile_direction + 12)
				else
					direction4 = DirectionRef(projectile_direction - 4)
				playsound(boss, 'sound/items/pulse3.ogg', 50)
				var/turf/target = turfarray[direction1]
				var/turf/target2 = turfarray[direction2]
				var/turf/target3 = turfarray[direction3]
				var/turf/target4 = turfarray[direction4]
				projectile1.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile1.fire_at(target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				projectile2.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile2.fire_at(target2, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				projectile3.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile3.fire_at(target3, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				projectile4.generate_bullet(ammo_datum, bullet_color = "#ff0000")
				projectile4.fire_at(target4, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
				if(projectile_direction < 16)
					projectile_direction += 1
				else
					projectile_direction = 1
				sleep(5)
	return

/datum/boss_action/proc/SummonDrone()
	var/mob/living/pve_boss/boss = owner
	var/area/boss_area = get_area(boss)
	var/drones_to_spawn = GLOB.boss_stage
	var/drones_spawned = 0
	if(boss_area.mob_spawners.len > 0)
		while(drones_spawned < drones_to_spawn)
			var/turf_to_spawn = get_turf(pick(boss_area.mob_spawners))
			new /mob/living/pve_boss_drone(turf_to_spawn)
			drones_spawned += 1
			if(GLOB.boss_drones.len > boss.boss_adds_spawned_max) return
	return
