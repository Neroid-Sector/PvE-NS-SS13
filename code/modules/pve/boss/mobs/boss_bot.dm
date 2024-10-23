/mob/living/pve_boss/missle_bot
	name = "BALTHEUS-6 Autonomous Anti-Personnel Platform"
	desc = "A heavilly modified automated weapons platform of unknown make."
	icon = 'icons/Surge/boss_bot/boss.dmi'
	icon_state = "boss_off"
	icon_size = 64
	speed = 1
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_sound = null
	health = 10000 // This will obviously need adjustments
	layer = MOB_LAYER
	pixel_x = -8
	old_x = -8
	base_pixel_x = 0
	base_pixel_y = 0
	pull_speed = -0.5
	universal_understand = 1
	universal_speak = 1
	langchat_color = "#ff1313"
	mob_size = MOB_SIZE_IMMOBILE
	see_in_dark = 255

/mob/living/pve_boss/missle_bot/proc/EntryCrawl()
	show_blurb(GLOB.player_list, 60 , "Autonomous Anti-Personnel Platform", screen_position = "CENTER,BOTTOM+2:16", text_alignment = "center", text_color = "#ffffff", blurb_key = "boss_head", ignore_key = TRUE, speed = 1)
	sleep(34)
	show_blurb(GLOB.player_list, 50, "<b>BALTHEUS-6</b>", screen_position = "CENTER,BOTTOM+1:16", text_alignment = "center", text_color = "#ff6810", blurb_key = "boss_name", ignore_key = TRUE, speed = 1)

/mob/living/pve_boss/missle_bot/proc/ThrowAnimate(thing)
	var/turf/current_turf = get_turf(src)
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

/mob/living/pve_boss/missle_bot/AnimateEntry()
	pixel_y = 300
	animate(src, pixel_y = 0, time = 15, easing = CUBIC_EASING|EASE_IN)
	sleep(15)
	var/turf/current_turf = get_turf(src)
	var/list/nearby_area = range(5, current_turf)
	for(var/mob/living/carbon/carbon_in_range in nearby_area)
		if(carbon_in_range == src) continue
		if(carbon_in_range)
			INVOKE_ASYNC(src,TYPE_PROC_REF(/mob/living/pve_boss/missle_bot/, ThrowAnimate), carbon_in_range)
	for(var/obj/item/items in nearby_area)
		if(items == src) continue
		if(items)
			INVOKE_ASYNC(src,TYPE_PROC_REF(/mob/living/pve_boss/missle_bot/, ThrowAnimate), items)
	new /obj/effect/shockwave(current_turf, 5)
	for(var/obj/structure/structure in nearby_area)
		var/icon_data = structure.icon
		var/icon_state_data = structure.icon_state
		var/turf_data = get_turf(structure)
		boss_ability.icon_chunk(icon_data, icon_state_data, structure.dir, turf_data)
		nearby_area -= structure
		qdel(structure)

	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/missle_bot, EntryCrawl))
	sleep(10)
	icon_state = "boss_normal"
	update_icons()
	say("UNIT ONLINE.")

/mob/living/pve_boss/missle_bot/Initialize()
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/missle_bot/, AnimateEntry))
	. = ..()
