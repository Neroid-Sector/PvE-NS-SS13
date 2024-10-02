/mob/living/carbon/human/proc/warning_ping()
	to_chat(src, SPAN_BOLDWARNING("A Surge is targeting you with a special attack!"))
	overlays += (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	sleep(40)
	overlays -= (image('icons/effects/surge_hit_warning.dmi', "aoe"))

/datum/boss_action/proc/surge_proj(atom/affected_atom)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return

	if (!action_cooldown_check())
		return
	var/list/mobs_in_range = list()
	for(var/mob/living/carbon/human/target in range("15x15",boss))
		if(mobs_in_range.Find(target) == 0)
			mobs_in_range.Add(target)
	if(mobs_in_range.len == 0)
		to_chat(boss, SPAN_WARNING("No potential targets in visible range"))
		return
	for(var/mob/living/carbon/human/target_to_warn in mobs_in_range)
		INVOKE_ASYNC(target_to_warn, TYPE_PROC_REF(/mob/living/carbon/human/, warning_ping))
	apply_cooldown()
	boss.overlays += (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	boss.anchored = 1
	sleep(boss.aoe_delay)
	boss.overlays -= (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	boss.anchored = 0
	playsound(boss, 'sound/items/pulse3.ogg', 50)
	for(var/mob/living/carbon/human/target_to_shoot in mobs_in_range)
		var/turf/target = get_turf(target_to_shoot)
		var/obj/projectile/projectile = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
		var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/surge_proj]
		projectile.generate_bullet(ammo_datum)
		projectile.fire_at(target, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)

	return

/obj/item/prop/big_warning_ping
	name = "warning ping"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	pixel_x = -80
	pixel_y = -80
	icon = 'icons/effects/surge_hit_warning_160.dmi'
	icon_state = "big_boom"

/turf/proc/warning_ping()
	var/obj/item/prop/big_warning_ping/ping = new(src)
	sleep(100)
	qdel(ping)

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

/datum/boss_action/proc/hit_animation(turf/turf_to_hit_animate)
		var/mob/living/pve_boss/boss = owner
		new /obj/item/prop/missile_storm_down(turf_to_hit_animate)
		sleep(13)
		var/obj/item/prop/explosion_fx/boom = new(turf_to_hit_animate)
		var/datum/cause_data/cause_data = create_cause_data("surge bombardment")
		cell_explosion(turf_to_hit_animate, boss.explosion_damage, (boss.explosion_damage / 2), EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		sleep(10)
		qdel(boom)

/datum/boss_action/proc/fire_loop(turf/target_turf)
	var/list/turfs_to_hit = list()
	for (var/turf/turf in range("5x5", target_turf))
		if(turfs_to_hit.Find(turf) == 0)
			turfs_to_hit += turf
	while(turfs_to_hit.len > 0)
		var/turf/turf_to_hit = pick(turfs_to_hit)
		turfs_to_hit -= turf_to_hit
		INVOKE_ASYNC(src, PROC_REF(hit_animation), turf_to_hit)
		sleep(rand(1,5))

/datum/boss_action/proc/rapid_missles(atom/affected_atom)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	if (!action_cooldown_check())
		return
	var/turf/turf_center = get_turf(affected_atom)
	var/list/mobs_in_range = list()
	apply_cooldown()
	boss.anchored = 1
	for(var/mob/living/carbon/human/target in range("15x15",turf_center))
		if(mobs_in_range.Find(target) == 0)
			mobs_in_range.Add(target)
	if(mobs_in_range.len != 0)
		to_chat(mobs_in_range,SPAN_BOLDWARNING("The [usr] launches a series of rockets into the air! Look out for impact markers!"))
	INVOKE_ASYNC(src, PROC_REF(fire_animation))
	turf_center.warning_ping()
	INVOKE_ASYNC(src, PROC_REF(fire_loop), turf_center)
	sleep(100)
	boss.anchored = 0
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
	boss.client.perspective = EYE_PERSPECTIVE
	boss.client.eye = target_turf
	sleep(20)
	new_pixel_y = new_pixel_y + 10
	animate(boss, pixel_y = new_pixel_y , time = 5, easing=LINEAR_EASING)
	boss.client.perspective = EYE_PERSPECTIVE
	boss.client.eye = target_turf
	sleep(5)
	new_pixel_y = initial(boss.pixel_y)
	animate(boss, pixel_y = new_pixel_y, time = 3, easing=QUAD_EASING|EASE_IN)
	boss.client.perspective = EYE_PERSPECTIVE
	boss.client.eye = target_turf
	sleep(3)
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
	if (!action_cooldown_check())
		return
	var/turf/targeted_turf = get_turf(target)
	for(var/turf/turf_in_range in range(5,get_turf(boss)))
		if(turf_in_range == targeted_turf)
			to_chat(boss, SPAN_WARNING("Target Turf is too close!"))
			return
	animate_warnings(targeted_turf)
	sleep(50)
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

/datum/boss_action/proc/handle_crosshair_animation(mob/target_mob)
	var/obj/item/prop/ring_line/ring_line_left = new()
	var/obj/item/prop/ring_line/ring_line_right = new()
	var/obj/item/prop/ring_rings/ring_ring = new()
	var/mob/living/carbon/human/target_human = target_mob
	if(!target_mob)return
	var/matrix/A = matrix()
	var/matrix/B = matrix()
	var/matrix/C = matrix()
	var/matrix/D = matrix()
	var/matrix/E = matrix()
	E.Scale(0.001,0.001)
	A.Turn(30)
	B.Turn(90)
	ring_line_left.apply_transform(A)
	ring_line_left.color = "#680606"
	C.Turn(-30)
	D.Turn(-90)
	ring_line_right.apply_transform(C)
	ring_line_right.color = "#680606"
	ring_ring.color = "#680606"

	animate(ring_line_left, transform = B, color = "#ff0000", time = 30, easing = LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(transform = E, color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

	animate(ring_line_right, transform = D, color = "#ff0000", time = 30, easing = LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(transform = E, color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

	animate(ring_ring, color = "#ff0000", time = 30, easing = LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(color = "#ff7575", time = 1,easing=LINEAR_EASING)
	animate(color = "#722525", time = 1,easing=LINEAR_EASING)
	animate(transform = E, color = "#707070", alpha = 0, time = 4,easing=LINEAR_EASING)

	target_human.vis_contents += ring_line_left
	target_human.vis_contents += ring_line_right
	target_human.vis_contents += ring_ring

	sleep(50)

	target_human.vis_contents -= ring_line_left
	target_human.vis_contents -= ring_line_right
	target_human.vis_contents -= ring_ring
	qdel(ring_line_right)
	qdel(ring_line_left)
	qdel(ring_ring)

/datum/boss_action/proc/fire_cannon(atom/target)
	var/mob/living/pve_boss/boss = owner
	if (!istype(boss))
		return
	if (!action_cooldown_check())
		return
	var/mob/living/carbon/human/laser_target = target
	if(!laser_target) return
	INVOKE_ASYNC(src, PROC_REF(handle_crosshair_animation),laser_target)
	sleep(30)
	var/mob/mob_to_shoot
	for(var/mob/mob in view("15x15",boss))
		if(mob == laser_target)
			mob_to_shoot = mob
			break
	if(!mob_to_shoot)
		return
	else
		var/turf/target_to_hit = get_turf(mob_to_shoot)
		var/obj/projectile/projectile = new /obj/projectile(boss.loc, create_cause_data("[boss.name]"), boss)
		var/datum/ammo/ammo_datum = GLOB.ammo_list[/datum/ammo/boss/dbl_laser]
		projectile.generate_bullet(ammo_datum)
		projectile.fire_at(target_to_hit, boss, boss, ammo_datum.max_range, ammo_datum.shell_speed)
	return

/datum/boss_action/proc/accelerate_to_target(turf/target, on_bump = FALSE)
	var/mob/living/pve_boss/boss_mob = owner
	var/turf/owner_turf = get_turf(boss_mob)
	var/turf/target_turf = target
	var/boss_velocity = 1
	if(on_bump == TRUE) boss_velocity = 3
	while(boss_velocity <= 5)
		var/distance_to_target = abs(target_turf.x - owner_turf.x) + abs(target_turf.y - owner_turf.y)
		if(distance_to_target == 0)
			boss_velocity = 6
			break
		walk_towards(boss_mob,target_turf,(6 - (1 * boss_velocity)))
		sleep(6 - (1 * boss_velocity))
		boss_velocity += 1
		owner_turf = get_turf(boss_mob)

/datum/boss_action/proc/proceed_to_target(turf/target)
	var/mob/living/pve_boss/boss_mob = owner
	var/turf/target_turf = target
	walk_towards(boss_mob,target_turf,1)

/datum/boss_action/proc/process_regular_movement(turf/target)
	var/mob/living/pve_boss/boss_mob = owner
	var/turf/owner_turf = get_turf(boss_mob)
	var/turf/target_turf = target
	var/distance_to_target = abs(target_turf.x - owner_turf.x) + abs(target_turf.y - owner_turf.y)
	if(distance_to_target < 3)
		walk_towards(boss_mob,target_turf,1)
		return
	else
		accelerate_to_target(target_turf)
		return

/datum/boss_action/proc/move_towards(atom/target)
	var/mob/living/pve_boss/boss = owner
	var/turf/target_turf = target
	if(!target_turf) return
	boss.movement_target = target_turf
	INVOKE_ASYNC(src, PROC_REF(process_regular_movement), target)

/obj/item/prop/icon_chunk
	name = "Its an arrow. Catch if if you can."
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	blend_mode = BLEND_OVERLAY
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER + 0.01
	icon_state = null

/datum/boss_action/proc/icon_chunk(icon, icon_state,icon_dir, turf/chunked_turf)
	INVOKE_ASYNC(src, PROC_REF(process_icon_chunk), icon,icon_state,icon_dir,chunked_turf)

/datum/boss_action/proc/process_icon_chunk(icon, icon_state, icon_dir, turf/chunked_turf)
	var/mob/living/pve_boss/boss_mob = owner
	var/turf/boss_turf = get_turf(boss_mob)
	var/turf/turf_to_chunk = chunked_turf

	var/icon/chunk1 = icon(icon,icon_state,icon_dir)
	chunk1.Crop(1,1,8,8)
	var/icon/chunk2 = icon(icon,icon_state,icon_dir)
	chunk2.Crop(9,1,16,8)
	var/icon/chunk3 = icon(icon,icon_state,icon_dir)
	chunk3.Crop(17,1,24,8)
	var/icon/chunk4 = icon(icon,icon_state,icon_dir)
	chunk4.Crop(25,1,32,8)
	var/icon/chunk5 = icon(icon,icon_state,icon_dir)
	chunk5.Crop(1,9,8,16)
	var/icon/chunk6 = icon(icon,icon_state,icon_dir)
	chunk6.Crop(9,9,16,16)
	var/icon/chunk7 = icon(icon,icon_state,icon_dir)
	chunk7.Crop(17,9,24,16)
	var/icon/chunk8 = icon(icon,icon_state,icon_dir)
	chunk8.Crop(25,9,32,16)
	var/icon/chunk9 = icon(icon,icon_state,icon_dir)
	chunk9.Crop(1,17,8,24)
	var/icon/chunk10 = icon(icon,icon_state,icon_dir)
	chunk10.Crop(9,17,16,24)
	var/icon/chunk11 = icon(icon,icon_state,icon_dir)
	chunk11.Crop(17,17,24,24)
	var/icon/chunk12 = icon(icon,icon_state,icon_dir)
	chunk12.Crop(25,17,32,24)
	var/icon/chunk13 = icon(icon,icon_state,icon_dir)
	chunk13.Crop(1,25,8,32)
	var/icon/chunk14 = icon(icon,icon_state,icon_dir)
	chunk14.Crop(9,25,16,32)
	var/icon/chunk15 = icon(icon,icon_state,icon_dir)
	chunk15.Crop(17,25,24,32)
	var/icon/chunk16 = icon(icon,icon_state,icon_dir)
	chunk16.Crop(25,25,32,32)

	var/matrix/A = matrix()

	var/obj/item/prop/icon_chunk/chunk_item1 = new()
	chunk_item1.icon = chunk1
	chunk_item1.pixel_x = 1
	chunk_item1.pixel_y = 1
	var/obj/item/prop/icon_chunk/chunk_item2 = new()
	chunk_item2.icon = chunk2
	chunk_item2.pixel_x = 9
	chunk_item2.pixel_y = 1
	var/obj/item/prop/icon_chunk/chunk_item3 = new()
	chunk_item3.icon = chunk3
	chunk_item3.pixel_x = 17
	chunk_item3.pixel_y = 1
	var/obj/item/prop/icon_chunk/chunk_item4 = new()
	chunk_item4.icon = chunk4
	chunk_item4.pixel_x = 25
	chunk_item4.pixel_y = 1
	var/obj/item/prop/icon_chunk/chunk_item5 = new()
	chunk_item5.icon = chunk5
	chunk_item5.pixel_x = 1
	chunk_item5.pixel_y = 9
	var/obj/item/prop/icon_chunk/chunk_item6 = new()
	chunk_item6.icon = chunk6
	chunk_item6.pixel_x = 9
	chunk_item6.pixel_y = 9
	var/obj/item/prop/icon_chunk/chunk_item7 = new()
	chunk_item7.icon = chunk7
	chunk_item7.pixel_x = 17
	chunk_item7.pixel_y = 9
	var/obj/item/prop/icon_chunk/chunk_item8 = new()
	chunk_item8.icon = chunk8
	chunk_item8.pixel_x = 25
	chunk_item8.pixel_y = 9
	var/obj/item/prop/icon_chunk/chunk_item9 = new()
	chunk_item9.icon = chunk9
	chunk_item9.pixel_x = 1
	chunk_item9.pixel_y = 17
	var/obj/item/prop/icon_chunk/chunk_item10 = new()
	chunk_item10.icon = chunk10
	chunk_item10.pixel_x = 9
	chunk_item10.pixel_y = 17
	var/obj/item/prop/icon_chunk/chunk_item11 = new()
	chunk_item11.icon = chunk11
	chunk_item11.pixel_x = 17
	chunk_item11.pixel_y = 17
	var/obj/item/prop/icon_chunk/chunk_item12 = new()
	chunk_item12.icon = chunk12
	chunk_item12.pixel_x = 25
	chunk_item12.pixel_y = 17
	var/obj/item/prop/icon_chunk/chunk_item13 = new()
	chunk_item13.icon = chunk13
	chunk_item13.pixel_x = 1
	chunk_item13.pixel_y = 25
	var/obj/item/prop/icon_chunk/chunk_item14 = new()
	chunk_item14.icon = chunk14
	chunk_item14.pixel_x = 9
	chunk_item14.pixel_y = 25
	var/obj/item/prop/icon_chunk/chunk_item15 = new()
	chunk_item15.icon = chunk15
	chunk_item15.pixel_x = 17
	chunk_item15.pixel_y = 25
	var/obj/item/prop/icon_chunk/chunk_item16 = new()
	chunk_item16.icon = chunk16
	chunk_item16.pixel_x = 25
	chunk_item16.pixel_y = 25
	switch(get_dir(boss_turf,turf_to_chunk))
		if(NORTHEAST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(1,64), pixel_y = rand(1,64), transform = A, time = 5)
		if(EAST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(1,64), pixel_y = rand(32,-32), transform = A, time = 5)
		if(SOUTHEAST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(1,64), pixel_y = rand(-1,-64), transform = A, time = 5)
		if(SOUTH)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(-32,32), pixel_y = rand(-1,-64), transform = A, time = 5)
		if(SOUTHWEST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
		if(WEST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(-1,-64), pixel_y = rand(32,-32), transform = A, time = 5)
		if(NORTHWEST)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(-1,-64), pixel_y = rand(-1,-64), transform = A, time = 5)
		if(NORTH)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item1,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item2,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item3,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item4,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item5,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item6,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item7,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item8,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item9,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item10,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item11,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item12,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item13,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item14,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item15,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)
			A = matrix()
			A.Turn(rand(-360,360))
			animate(chunk_item16,pixel_x = rand(-32,32), pixel_y = rand(1,64), transform = A, time = 5)

	turf_to_chunk.vis_contents += chunk_item1
	turf_to_chunk.vis_contents += chunk_item2
	turf_to_chunk.vis_contents += chunk_item3
	turf_to_chunk.vis_contents += chunk_item4
	turf_to_chunk.vis_contents += chunk_item5
	turf_to_chunk.vis_contents += chunk_item6
	turf_to_chunk.vis_contents += chunk_item7
	turf_to_chunk.vis_contents += chunk_item8
	turf_to_chunk.vis_contents += chunk_item9
	turf_to_chunk.vis_contents += chunk_item10
	turf_to_chunk.vis_contents += chunk_item11
	turf_to_chunk.vis_contents += chunk_item12
	turf_to_chunk.vis_contents += chunk_item13
	turf_to_chunk.vis_contents += chunk_item14
	turf_to_chunk.vis_contents += chunk_item15
	turf_to_chunk.vis_contents += chunk_item16
	new /obj/effect/shockwave(turf_to_chunk, 4)
	sleep(15)
	qdel(chunk_item1)
	qdel(chunk_item2)
	qdel(chunk_item3)
	qdel(chunk_item4)
	qdel(chunk_item5)
	qdel(chunk_item6)
	qdel(chunk_item7)
	qdel(chunk_item8)
	qdel(chunk_item9)
	qdel(chunk_item10)
	qdel(chunk_item11)
	qdel(chunk_item12)
	qdel(chunk_item13)
	qdel(chunk_item14)
	qdel(chunk_item15)
	qdel(chunk_item16)
