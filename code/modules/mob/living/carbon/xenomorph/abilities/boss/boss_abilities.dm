/datum/action/xeno_action/activable/surge_proj
	name = "Living Target Sweep"
	action_icon_state = "runner_bonespur"
	ability_name = "Living Target Sweep"
	macro_path = /datum/action/xeno_action/verb/surge_proj
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 60
	plasma_cost = 0

	var/ammo_type = /datum/ammo/xeno/surge_proj


/datum/action/xeno_action/activable/rapid_missles
	name = "Missile Barrage"
	action_icon_state = "runner_bonespur"
	ability_name = "missile barrage"
	macro_path = /datum/action/xeno_action/verb/rapid_missles
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 60
	plasma_cost = 0

/datum/action/xeno_action/activable/relocate

	name = "Rapid Relocation"
	action_icon_state = "runner_bonespur"
	ability_name = "Relocation"
	macro_path = /datum/action/xeno_action/verb/relocate
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 60
	plasma_cost = 0

/datum/action/xeno_action/activable/fire_cannon

	name = "Fire Cannon"
	action_icon_state = "runner_bonespur"
	ability_name = "Cannon"
	macro_path = /datum/action/xeno_action/verb/fire_cannon
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 35
	plasma_cost = 0

	var/ammo_type = /datum/ammo/xeno/dbl_laser
