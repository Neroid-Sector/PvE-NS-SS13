/mob/living/carbon/human/proc/warning_ping()
	to_chat(src, SPAN_BOLDWARNING("A Surge is targeting you with a special attack!"))
	overlays += (image('icons/effects/surge_hit_warning.dmi', "aoe"))
	sleep(40)
	overlays -= (image('icons/effects/surge_hit_warning.dmi', "aoe"))

/datum/action/xeno_action/activable/surge_proj/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return
	var/list/mobs_in_range = list()
	for(var/mob/living/carbon/human/target in range("15x15",xeno))
		if(mobs_in_range.Find(target) == 0)
			mobs_in_range.Add(target)
	if(mobs_in_range.len == 0)
		to_chat(xeno, SPAN_WARNING("No potential targets in visible range"))
		return
	for(var/mob/living/carbon/human/target_to_warn in mobs_in_range)
		INVOKE_ASYNC(target_to_warn, TYPE_PROC_REF(/mob/living/carbon/human/, warning_ping))
	xeno.overlays += (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	xeno.anchored = 1
	if(xeno.armor_deflection > 20) xeno.armor_deflection = 20
	sleep(xeno.aoe_delay)
	xeno.overlays -= (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	xeno.anchored = 0
	xeno.armor_deflection = initial(xeno.armor_deflection)
	var/list/mobs_in_view = list()
	for(var/mob/living/carbon/human/target in view("15x15",xeno))
		if(mobs_in_view.Find(target) == 0)
			mobs_in_view.Add(target)
	if(mobs_in_view.len == 0) return
	playsound(xeno, 'sound/items/pulse3.ogg', 50)
	for(var/mob/living/carbon/human/target_to_shoot in mobs_in_range)
		if(mobs_in_view.Find(target_to_shoot) != 0)
			var/turf/target = get_turf(target_to_shoot)
			var/obj/projectile/projectile = new /obj/projectile(xeno.loc, create_cause_data(initial(xeno.caste_type), xeno))
			var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]
			projectile.generate_bullet(ammo_datum)
			projectile.fire_at(target, xeno, xeno, ammo_datum.max_range, ammo_datum.shell_speed)

	apply_cooldown()
	return ..()

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

/datum/action/xeno_action/activable/rapid_missles/proc/fire_animation()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/spawned_props = 1
	playsound(xeno,'sound/surge/rockets_launching.ogg', 80)
	while(spawned_props <= xeno.missile_storm_missiles)
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

/datum/action/xeno_action/activable/rapid_missles/proc/hit_animation(turf/turf_to_hit_animate)
		var/mob/living/carbon/xenomorph/xeno = owner
		new /obj/item/prop/missile_storm_down(turf_to_hit_animate)
		sleep(13)
		var/obj/item/prop/explosion_fx/boom = new(turf_to_hit_animate)
		var/datum/cause_data/cause_data = create_cause_data("surge bombardment")
		cell_explosion(turf_to_hit_animate, xeno.explosion_damage, (xeno.explosion_damage / 2), EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		sleep(10)
		qdel(boom)

/datum/action/xeno_action/activable/rapid_missles/proc/fire_loop(turf/target_turf)
	var/list/turfs_to_hit = list()
	for (var/turf/turf in range("5x5", target_turf))
		if(turfs_to_hit.Find(turf) == 0)
			turfs_to_hit += turf
	while(turfs_to_hit.len > 0)
		var/turf/turf_to_hit = pick(turfs_to_hit)
		turfs_to_hit -= turf_to_hit
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/action/xeno_action/activable/rapid_missles, hit_animation), turf_to_hit)
		sleep(rand(1,5))

/datum/action/xeno_action/activable/rapid_missles/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	if (!action_cooldown_check())
		return
	var/turf/turf_center = get_turf(affected_atom)
	var/list/mobs_in_range = list()
	xeno.anchored = 1
	if(xeno.armor_deflection > 20) xeno.armor_deflection = 20
	for(var/mob/living/carbon/human/target in range("15x15",turf_center))
	if(mobs_in_range.Find(target) == 0)
		mobs_in_range.Add(target)
	if(mobs_in_range.len != 0)
		to_chat(mobs_in_range,SPAN_BOLDWARNING("The [usr] launches a series of rockets into the air! Look out for impact markers!"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/action/xeno_action/activable/rapid_missles, fire_animation))
	turf_center.warning_ping()
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/action/xeno_action/activable/rapid_missles, fire_loop), turf_center)
	sleep(100)
	xeno.anchored = 0
	xeno.armor_deflection = initial(xeno.armor_deflection)

	apply_cooldown()
	return ..()
