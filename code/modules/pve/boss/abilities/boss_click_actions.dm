/datum/bossclicking/

	var/mob/living/pve_boss/attached_mob

/datum/bossclicking/proc/AssignMob(mob/owner_mob)
	attached_mob = owner_mob

/datum/bossclicking/proc/InterceptClickOn(mob/user, params, atom/object)

	var/list/modifiers = params2list(params)

	if(modifiers[LEFT_CLICK])
		attached_mob.boss_ability.fire_cannon(object)
