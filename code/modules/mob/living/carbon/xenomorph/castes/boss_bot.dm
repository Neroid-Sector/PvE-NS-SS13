/datum/caste_datum/boss_bot
	caste_type = XENO_CASTE_XENOSURGE_BOSS_BOT
	caste_desc = "An agile defense platform, saturating the battlefield with defensive fire."
	tier = 4
	melee_damage_lower = 25
	melee_damage_upper = 40
	melee_vehicle_damage = 40
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_NO_PLASMA
	armor_deflection = 100
	max_health = 3000
	evasion = XENO_EVASION_NONE
	speed = 1
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	fire_immunity = FIRE_IMMUNITY_NO_IGNITE
	attack_delay = -4
	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4
	minimap_icon = "runner"


/datum/action/xeno_action/onclick/toggle_long_range/boss_bot
	handles_movement = TRUE
	should_delay = FALSE


/mob/living/carbon/xenomorph/boss_bot
	caste_type = XENO_CASTE_XENOSURGE_BOSS_BOT
	name = "BALTHEUS-6 Pursuit Wrepons Platform"
	desc = "A heavilly modified automated weapons platform of unknown make."
	icon = 'icons/Surge/boss_bot/boss.dmi'
	icon_state = "Boss Walking"
	icon_size = 64
	attack_sound = null
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CATECHOLAMINE)
	tier = 0
	pixel_x = -8
	old_x = -8
	base_pixel_x = 0
	base_pixel_y = 0
	pull_speed = -0.5
	viewsize = 14
	wall_smash = 1
	universal_understand = 1
	universal_speak = 1
	langchat_color = "#ff1313"
	boss_type = 1
	small_explosives_stun = FALSE

	mob_size = MOB_SIZE_IMMOBILE

	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_long_range/boss_bot,
		/datum/action/xeno_action/activable/surge_proj,
		/datum/action/xeno_action/activable/rapid_missles/,
	)
	mutation_type = BOSS_NORMAL
	icon_xeno = 'icons/Surge/boss_bot/boss.dmi'
	icon_xenonid = 'icons/Surge/boss_bot/boss.dmi'
