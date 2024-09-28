/mob/living/carbon/human/proc/warning_ping()
	to_chat(src, SPAN_BOLDWARNING("A Surge is targeting you with a special attack!"))
	overlays += (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	sleep(40)
	overlays -= (image('icons/effects/surge_hit_warning.dmi', "aoe"))

/datum/boss_action/proc/surge_proj(atom/affected_atom, mob/owner)
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

/datum/boss_action/proc/rapid_missles(atom/affected_atom, mob/owner)
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

/datum/boss_action/proc/relocate(atom/target, mob/owner)
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

/datum/boss_action/proc/fire_cannon(atom/target, mob/owner)
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

