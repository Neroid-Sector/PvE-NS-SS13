/datum/action/xeno_action/activable/runner_skillshot/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] fires a burst of bone chips at [affected_atom]!"), SPAN_XENOWARNING("You fire a burst of bone chips at [affected_atom]!"))

	var/turf/target = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/projectile = new /obj/projectile(xeno.loc, create_cause_data(initial(xeno.caste_type), xeno))

	var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]

	projectile.generate_bullet(ammo_datum)

	projectile.fire_at(target, xeno, xeno, ammo_datum.max_range, ammo_datum.shell_speed)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/acider_acid/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(affected_atom, /obj/item) && !istype(affected_atom, /obj/structure/) && !istype(affected_atom, /obj/vehicle/multitile))
		to_chat(xeno, SPAN_XENOHIGHDANGER("Can only melt barricades and items!"))
		return
	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if (!istype(behavior_delegate))
		return
	if(behavior_delegate.acid_amount < acid_cost)
		to_chat(xeno, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	xeno.corrosive_acid(affected_atom, acid_type, 0)
	for(var/obj/item/explosive/plastic/plastic_explosive in affected_atom.contents)
		xeno.corrosive_acid(plastic_explosive, acid_type, 0)
	return ..()

/mob/living/carbon/xenomorph/runner/corrosive_acid(atom/affected_atom, acid_type, plasma_cost)
	if (mutation_type != RUNNER_ACIDER)
		return ..()
	if(!affected_atom.Adjacent(src))
		if(istype(affected_atom,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/plastic_explosive = affected_atom
			if(plastic_explosive.plant_target && !plastic_explosive.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("You can't reach [affected_atom]."))
				return
		else
			to_chat(src, SPAN_WARNING("[affected_atom] is too far away."))
			return

	if(!isturf(loc) || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_WARNING("You can't melt [affected_atom] from here!"))
		return

	face_atom(affected_atom)

	var/wait_time = 10

	var/turf/turf = get_turf(affected_atom)

	for(var/obj/effect/xenomorph/acid/acid in turf)
		if(acid_type == acid.type && acid.acid_t == affected_atom)
			to_chat(src, SPAN_WARNING("[affected_atom] is already drenched in acid."))
			return

	var/obj/object
	//OBJ CHECK
	if(isobj(affected_atom))
		object = affected_atom

		if(istype(object, /obj/structure/window_frame))
			var/obj/structure/window_frame/window_frame = object
			if(window_frame.reinforced && acid_type != /obj/effect/xenomorph/acid/strong)
				to_chat(src, SPAN_WARNING("This [object.name] is too tough to be melted by your weak acid."))
				return

		wait_time = object.get_applying_acid_time()
		if(wait_time == -1)
			to_chat(src, SPAN_WARNING("You cannot dissolve [object]."))
			return
	else
		to_chat(src, SPAN_WARNING("You cannot dissolve [affected_atom]."))
		return
	wait_time = wait_time / 4
	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/acid in turf)
		if(acid_type == acid.type && acid.acid_t == affected_atom)
			to_chat(src, SPAN_WARNING("[acid] is already drenched in acid."))
			return

	if(!check_state())
		return

	if(!affected_atom || QDELETED(affected_atom)) //Some logic.
		return

	if(!affected_atom.Adjacent(src) || (object && !isturf(object.loc)))//not adjacent or inside something
		if(istype(affected_atom, /obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/plastic_explosive = affected_atom
			if(plastic_explosive.plant_target && !plastic_explosive.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("You can't reach [affected_atom]."))
				return
		else
			to_chat(src, SPAN_WARNING("[affected_atom] is too far away."))
			return

	var/datum/behavior_delegate/runner_acider/behavior_del = behavior_delegate
	if (!istype(behavior_del))
		return
	if(behavior_del.acid_amount < behavior_del.melt_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	behavior_del.modify_acid(-behavior_del.melt_acid_cost)

	var/obj/effect/xenomorph/acid/acid = new acid_type(turf, affected_atom)

	if(istype(affected_atom, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = affected_atom
		multitile_vehicle.take_damage_type(20 / acid.acid_delay, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"), \
			SPAN_XENOWARNING("You vomit globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(acid, 20)
		return

	acid.add_hiddenprint(src)
	acid.name += " ([affected_atom])"

	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"), \
	SPAN_XENOWARNING("You vomit globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)


/datum/action/xeno_action/activable/acider_for_the_hive/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("It is too cramped in here to activate this!"))
		return

	var/area/xeno_area = get_area(xeno)
	if(xeno_area.flags_area & AREA_CONTAINMENT)
		to_chat(xeno, SPAN_XENOWARNING("You can't activate this here!"))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(xeno.mutation_type != RUNNER_ACIDER)
		return

	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if(!istype(behavior_delegate))
		return

	if(behavior_delegate.caboom_trigger)
		cancel_ability()
		return

	if(behavior_delegate.acid_amount < minimal_acid)
		to_chat(xeno, SPAN_XENOWARNING("Not enough acid built up for an explosion."))
		return

	notify_ghosts(header = "For the Hive!", message = "[xeno] is going to explode for the Hive!", source = xeno, action = NOTIFY_ORBIT)

	to_chat(xeno, SPAN_XENOWARNING("Your stomach starts turning and twisting, getting ready to compress the built up acid."))
	xeno.color = "#22FF22"
	xeno.set_light_color("#22FF22")
	xeno.set_light_range(3)

	behavior_delegate.caboom_trigger = TRUE
	behavior_delegate.caboom_left = behavior_delegate.caboom_timer
	behavior_delegate.caboom_last_proc = 0
	xeno.set_effect(behavior_delegate.caboom_timer*2, SUPERSLOW)

	xeno.say(";FOR THE HIVE!!!")
	return ..()

/datum/action/xeno_action/activable/acider_for_the_hive/proc/cancel_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return
	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if(!istype(behavior_delegate))
		return

	behavior_delegate.caboom_trigger = FALSE
	xeno.color = null
	xeno.set_light_range(0)
	behavior_delegate.modify_acid(-behavior_delegate.max_acid / 4)

	// Done this way rather than setting to 0 in case something else slowed us
	// -Original amount set - (time exploding + timer inaccuracy) * how much gets removed per tick / 2
	xeno.adjust_effect(behavior_delegate.caboom_timer * -2 - (behavior_delegate.caboom_timer - behavior_delegate.caboom_left + 2) * xeno.life_slow_reduction * 0.5, SUPERSLOW)

	to_chat(xeno, SPAN_XENOWARNING("You remove all your explosive acid before it combusted."))


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
	xeno.armor_deflection = 200
	sleep(40)
	xeno.overlays -= (image('icons/effects/surge_hit_warning_64.dmi', "aoe_surge"))
	xeno.anchored = 0
	xeno.armor_deflection = initial(xeno.armor_deflection)
	xeno.can_block_movement = 1
	var/list/mobs_in_view = list()
	for(var/mob/living/carbon/human/target in view("15x15",xeno))
		if(mobs_in_view.Find(target) == 0)
			mobs_in_view.Add(target)
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
	sleep(60)
	qdel(ping)

/obj/item/prop/missile_storm_up
	name = "going up"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/effects/missile_storm.dmi'
	icon_state = "up"


/obj/item/prop/missile_storm_up/proc/animate_takeoff()
	var/new_pixel_x = pixel_x + 48
	animate(src, pixel_x=new_pixel_x,pixel_y=384,time = 10,easing=QUAD_EASING|EASE_IN)
	sleep(11)
	qdel(src)

/obj/item/prop/missile_storm_up/Initialize(mapload, ...)
	. = ..()
	pixel_x += rand(-10,10)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/prop/missile_storm_up/, animate_takeoff))

/obj/item/prop/missile_storm_down
	name = "going down"
	opacity = FALSE
	mouse_opacity = FALSE
	anchored = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/effects/missile_storm.dmi'
	icon_state = "down"


/obj/item/prop/missile_storm_down/proc/animate_landing()
	var/new_pixel_x = pixel_x + 48
	animate(src, pixel_x=new_pixel_x,pixel_y=0,time = 10,easing=QUAD_EASING|EASE_IN)
	sleep(11)
	qdel(src)

/obj/item/prop/missile_storm_down/Initialize(mapload, ...)
	. = ..()
	pixel_y = 384
	pixel_x += rand(-10,10)
	pixel_x -= -48
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/prop/missile_storm_down/, animate_landing))

/datum/action/xeno_action/activable/rapid_missles/proc/fire_animation()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/turf/owner_turf = get_turf(owner)
	xeno.anchored = TRUE
	xeno.armor_deflection = 100
	var/spawned_props = 1
	while(spawned_props <= 25)
		new /obj/item/prop/missile_storm_up(owner_turf)
		spawned_props += 1
		sleep(rand(1,3))
	xeno.armor_deflection = initial(xeno.armor_deflection)
	xeno.anchored = FALSE

/datum/action/xeno_action/activable/rapid_missles/proc/hit_animation(turf/turf_to_hit_animate)
		new /obj/item/prop/missile_storm_down(turf_to_hit_animate)
		sleep(13)
		var/datum/cause_data/cause_data = create_cause_data("surge bombardment")
		cell_explosion(turf_to_hit_animate, 50, 15, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)


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
	for(var/mob/living/carbon/human/target in range("15x15",turf_center))
	if(mobs_in_range.Find(target) == 0)
		mobs_in_range.Add(target)
	if(mobs_in_range.len != 0)
		to_chat(mobs_in_range,SPAN_BOLDWARNING("The [usr] launches a series of rockets into the air! Look out for impact markers!"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/action/xeno_action/activable/rapid_missles, fire_animation))
	turf_center.warning_ping()
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/action/xeno_action/activable/rapid_missles, fire_loop), turf_center)
	apply_cooldown()
	return ..()
