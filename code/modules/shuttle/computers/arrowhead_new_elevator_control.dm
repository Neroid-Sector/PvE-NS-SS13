/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call
	name = "\improper Elevator Call"
	desc = "Control panel for the elevator"
	shuttleId = MOBILE_ARROW_ELEVATOR
	is_call = TRUE
	var/dockId
	var/datum/elevator/destination/site


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/get_landing_zones()
	return list(SSshuttle.getDock(dockId))


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/occupied
	dockId = STAT_ARROW_OCCUPIED


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/empty
	dockId = STAT_ARROW_EMPTY


// Port
/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/upper_port
	dockId = STAT_ARROW_UPPER_PORT


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/mid_port
	dockId = STAT_ARROW_MID_PORT


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/lower_port
	dockId = STAT_ARROW_LOWER_PORT


// Starboard
/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/upper_star
	dockId = STAT_ARROW_UPPER_STAR


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/mid_star
	dockId = STAT_ARROW_MID_STAR


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/elevator_call/lower_star
	dockId = STAT_ARROW_LOWER_STAR


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller
	name = "\improper Elevator Panel"
	desc = "Control panel for the elevator"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "elevator_screen"

	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = FALSE
	req_access = null
	needs_power = TRUE
	var/is_call = FALSE


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/proc/get_landing_zones()
	. = list()
	var/obj/docking_port/mobile/arrow_elevator/shuttle = SSshuttle.getShuttle(shuttleId)

	for(var/obj/docking_port/stationary/arrow_elevator/elev in SSshuttle.stationary)
		if(!shuttle.elevator_network)
			. += list(elev)
			continue
		if(shuttle.elevator_network == elev.elevator_network)
			. += list(elev)
			continue


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ElevatorControl", "Elevator Panel")
		ui.open()


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		to_chat(user, SPAN_WARNING("The panel is inoperable."))
		return UI_CLOSE


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/ui_data(mob/user)
	. = ..()
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	var/obj/docking_port/stationary/dockedAt = shuttle.get_docked()
	.["docked_at"] = list("id"= dockedAt.id, "name" = dockedAt.name)
	.["destination"] = shuttle.destination
	.["mode"] = shuttle.mode
	.["eta"] = shuttle.timeLeft(0)


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/ui_static_data(mob/user)
	. = ..()
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	var/list/stops = get_landing_zones()
	.["destinations"] = list()
	for(var/obj/docking_port/stationary/dock as anything in stops)
		var/list/dockinfo = list(
			"id" = dock.id,
			"name" = dock.name,
		)
		.["destinations"] += list(dockinfo)
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_pre_arrival_duration"] = shuttle.prearrivalTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10
	.["is_call_button"] = is_call


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE

	tgui_interact(user)


/obj/structure/machinery/computer/shuttle/arrowhead/elevator_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	switch(action)
		if("move")
			if(shuttle.mode != SHUTTLE_IDLE)
				return
			var/dockId = params["target"]
			if(!dockId)
				return
			var/obj/docking_port/stationary/dockedAt = shuttle.get_docked()
			if(dockedAt.id == dockId)
				return
			SSshuttle.moveShuttle(shuttle.id, dockId, TRUE)
			return TRUE
		if("button-push")
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME * 2, 1)
			return FALSE
