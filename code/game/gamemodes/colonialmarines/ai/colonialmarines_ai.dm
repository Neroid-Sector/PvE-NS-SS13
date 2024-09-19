/datum/game_mode/colonialmarines/ai
	name = "Xenosurge"
	config_tag = "Xenosurge"
	required_players = 0
	votable = TRUE

	flags_round_type = MODE_INFESTATION|MODE_NEW_SPAWN|MODE_NO_XENO_EVOLVE

	var/list/squad_limit = list(
		/datum/squad/marine/alpha,
		/datum/squad/marine/delta,
	)

	var/list/objectives = list()
	var/initial_objectives = 0

	var/game_started = FALSE

	static_comms_amount = 0
	requires_comms = FALSE
	toggleable_flags = MODE_NO_JOIN_AS_XENO

/datum/game_mode/colonialmarines/ai/can_start()
	return ..()

/datum/game_mode/colonialmarines/ai/pre_setup()
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(handle_xeno_spawn))

	for(var/datum/squad/squad in RoleAuthority.squads)
		if(squad.type in squad_limit)
			continue
		RoleAuthority.squads -= squad
		RoleAuthority.squads_by_type -= squad.type


	. = ..()

/datum/game_mode/colonialmarines/ai/post_setup()
	set_lz_resin_allowed(TRUE)
	return ..()

/datum/game_mode/colonialmarines/ai/announce_bioscans()
	return

/datum/game_mode/colonialmarines/ai/end_round_message()
	return ..()

/datum/game_mode/colonialmarines/ai/proc/handle_xeno_spawn(datum/source, mob/living/carbon/xenomorph/spawning_xeno, ai_hard_off = FALSE)
	SIGNAL_HANDLER
	if(ai_hard_off)
		return

	spawning_xeno.make_ai()

/datum/game_mode/colonialmarines/ai/check_win()
	if(!game_started || round_finished || SSticker.current_state != GAME_STATE_PLAYING)
		return

/datum/game_mode/colonialmarines/ai/get_roles_list()
	return ROLES_PVE

/datum/game_mode/colonialmarines/ai/check_queen_status()
	return
