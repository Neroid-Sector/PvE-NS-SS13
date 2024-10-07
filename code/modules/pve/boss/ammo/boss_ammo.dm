/datum/ammo/boss/surge_proj

	name = "laser beam"
	icon = 'icons/Surge/boss_bot/boss_proj.dmi'
	icon_state = "laser"
	ping = null
	flags_ammo_behavior = AMMO_XENO|AMMO_SKIPS_ALIENS|AMMO_IGNORE_ARMOR|AMMO_IGNORE_COVER|AMMO_IGNORE_RESIST
	damage_type = BURN
	damage = 40
	max_range = 20
	accuracy = 100
	shell_speed = 0.4

/datum/ammo/boss/dbl_laser
	icon = 'icons/Surge/boss_bot/boss_proj.dmi'
	icon_state = "twin_laser"
	name = "double laser beam"
	ping = null
	flags_ammo_behavior = AMMO_XENO|AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR|AMMO_IGNORE_RESIST
	damage_type = BURN
	damage = 5
	penetration = 0
	max_range = 10
	accuracy = 70
	shell_speed = 0.8
