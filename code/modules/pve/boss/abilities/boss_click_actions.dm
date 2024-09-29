/datum/bossclicking/

	var/mob/living/pve_boss/attached_mob

/datum/bossclicking/New()
	. = ..()
	attached_mob = src

/datum/bossclicking/proc/InterceptClickOn(mob/user, params, atom/object)

	var/list/modifiers = params2list(params)

	if(modifiers[LEFT_CLICK])
		attached_mob.boss_ability.fire_cannon(object)
