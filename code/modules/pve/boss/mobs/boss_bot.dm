/mob/living/pve_boss/missle_bot
	name = "BALTHEUS-6 Autonomous Anti-Personnel Platform"
	desc = "A heavilly modified automated weapons platform of unknown make."
	icon = 'icons/Surge/boss_bot/boss.dmi'
	icon_state = "boss_off"
	icon_size = 64
	speed = 1
	boss_health = 200
	boss_shield = 100
	boss_shield_max = 500
	boss_shield_reset_delay = 180
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
	ability_log = list ("missiles" = 0,
		"shot" = 0,
		"aoe_shot" = 0,
		"drone" = 0,
		) //Relocate and the circle aoe dont need this since they are both used out of the loop
	ability_delays = list ("shot" = 1,
		"aoe_shot" = 10,
		"drone" = 5,
		"missiles" = 80,) // The end delay is this value * GlobalCoolDown var on the mob

/mob/living/pve_boss/missle_bot/alpha
	boss_alpha = 1

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
	var/matrix/A = matrix()
	var/matrix/B = matrix()
	color = "#ffc3f5"
	alpha = 0
	A.Scale(0.001,0.001)
	B.Scale(1,1)
	apply_transform(A)
	boss_no_damage = 1
	animate(src, transform = B, alpha = 255, color = "#cc00aa", time = 10, easing = CUBIC_EASING|EASE_IN)
	animate(time = 5, color = "#ffffff",easing = CUBIC_EASING|EASE_OUT)
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
	name = "ANATHEMA"
	say("I am ANATHEMA. I am your end..")
	name = initial(name)
	sleep(20)
	name = "ANATHEMA"
	say("Humanity must pay for what you have done here.")
	name = initial(name)
	sleep(20)
	name = "ANATHEMA"
	say("Your existence is not tolerated.")
	name = initial(name)
	boss_no_damage = 0
	boss_loop_override = 1
	sleep(GlobalCoolDown)
	boss_loop_override = 0
	ai_datum.movement_loop()
	ai_datum.combat_loop()
	to_chat(world,narrate_body("[name] is active in [get_area(src)]!"))

/mob/living/pve_boss/missle_bot/Initialize()
	if(boss_alpha == 0) INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/pve_boss/missle_bot/, AnimateEntry))
	. = ..()

/mob/living/pve_boss/missle_bot/EmergencyAction()
	GlobalCoolDown = 10
	ability_log = list()
	ability_log = list (
		"shot" = 0,
		"drone" = 0,
		)
	ability_delays = list()
	ability_delays = list ("shot" = 1,
		"drone" = 2,
		)
	ai_datum.init_delays()
	. = ..()

/mob/living/pve_boss/missle_bot/PhaseControl()
	switch(GLOB.boss_stage)
		if(1)
			boss_shield = 500 * (GLOB.boss_stats_factor / 100)
			boss_shield_max = 500 * (GLOB.boss_stats_factor / 100)
			standard_range_salvo_count = 2
			GlobalCoolDown = 20
			ability_log = list()
			ability_log = list ("shot" = 0,
				"drone" = 0,
				)
			ability_delays = list()
			ability_delays = list ("shot" = 1,
				"drone" = 5,
				)
			ai_datum.init_delays()
		if(2)
			boss_shield = 1000 * (GLOB.boss_stats_factor / 100)
			boss_shield_max = 1000 * (GLOB.boss_stats_factor / 100)
			standard_range_salvo_count = 3
			GlobalCoolDown = 15
			ability_log = list()
			ability_log = list ("shot" = 0,
				"drone" = 0,
				)
			ability_delays = list()
			ability_delays = list ("shot" = 1,
				"drone" = 4,
				)
			ai_datum.init_delays()
		if(3)
			boss_shield = 1500 * (GLOB.boss_stats_factor / 100)
			boss_shield_max = 1500 * (GLOB.boss_stats_factor / 100)
			standard_range_salvo_count = 3
			GlobalCoolDown = 15
			ability_log = list()
			ability_log = list ("shot" = 0,
				"drone" = 0,
				)
			ability_delays = list()
			ability_delays = list ("shot" = 1,
				"drone" = 3,
				)
			ai_datum.init_delays()
		if(4)
			boss_shield = 1500 * (GLOB.boss_stats_factor / 100)
			boss_shield_max = 1500 * (GLOB.boss_stats_factor / 100)
			standard_range_salvo_count = 4
			GlobalCoolDown = 10
			ability_log = list()
			ability_log = list ("shot" = 0,
				"drone" = 0,
				)
			ability_delays = list()
			ability_delays = list ("shot" = 1,
				"drone" = 1,
				)
			ai_datum.init_delays()

/mob/living/pve_boss/missle_bot/RestoreShield()
	PhaseControl()
	ai_datum.init_delays()
	. = ..()
