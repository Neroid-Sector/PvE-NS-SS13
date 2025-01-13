/datum/npc

	var/mob/living/carbon/human/owner

/datum/npc/New(mob/human)
	owner = human
	. = ..()
