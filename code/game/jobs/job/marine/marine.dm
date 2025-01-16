/datum/job/marine
	supervisors = "the acting platoon leader"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1

/datum/job/marine/generate_entry_message(mob/living/carbon/human/current_human)
	. = ..()
	if(current_human.assigned_squad)
		to_chat(current_human, narrate_body("You have been assigned to <b><color=[current_human.assigned_squad.equipment_color]>[current_human.assigned_squad.name]!</font></b>"))

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/current_human)
	..()
	if(!Check_WO())
		current_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST
