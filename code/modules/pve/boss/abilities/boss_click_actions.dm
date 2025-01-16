/datum/bossclicking/

	var/mob/living/pve_boss/attached_mob

/datum/bossclicking/New(mob/boss)
	. = ..()
	attached_mob = boss

/datum/bossclicking/proc/InterceptClickOn(mob/user, params, atom/object)

	var/list/modifiers = params2list(params)

	if(modifiers[LEFT_CLICK] && !modifiers[SHIFT_CLICK] && !modifiers[ALT_CLICK])
		attached_mob.boss_ability.move_destination(object)

	if(modifiers[MIDDLE_CLICK] && !modifiers[SHIFT_CLICK] && !modifiers[ALT_CLICK])
		attached_mob.boss_ability.fire_cannon(object)

	if(modifiers[LEFT_CLICK] && modifiers[SHIFT_CLICK] && !modifiers[ALT_CLICK])
		attached_mob.boss_ability.relocate(object)

	if(modifiers[MIDDLE_CLICK] && modifiers[SHIFT_CLICK] && !modifiers[ALT_CLICK])
		attached_mob.boss_ability.surge_proj(object)

	if(modifiers[LEFT_CLICK] && !modifiers[SHIFT_CLICK] && modifiers[ALT_CLICK])
		attached_mob.boss_ability.rapid_missles(object)

//Debug unimmobilizer. Remove after testing.

	if(modifiers[MIDDLE_CLICK] && !modifiers[SHIFT_CLICK] && modifiers[ALT_CLICK])
		attached_mob.boss_immobilized = 0
