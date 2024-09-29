/mob/living/pve_boss/missle_bot
	name = "BALTHEUS-6 Pursuit Wrepons Platform"
	desc = "A heavilly modified automated weapons platform of unknown make."
	icon = 'icons/Surge/boss_bot/boss.dmi'
	icon_state = "Boss Walking"
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

/* Old Xeno vars for reference

	melee_vehicle_damage = 40

	armor_deflection = 100
	evasion = XENO_EVASION_NONE

	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	fire_immunity = FIRE_IMMUNITY_NO_IGNITE
	small_explosives_stun = FALS


	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	minimap_icon = "runner"

/datum/action/xeno_action/onclick/toggle_long_range/boss_bot
	handles_movement = TRUE
	should_delay = FALSE
*/
