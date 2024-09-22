/obj/docking_port/mobile/arrow_elevator
	name="Elevator"
	id=MOBILE_ARROW_ELEVATOR

	// Map information
	height= 5
	width= 5
	preferred_direction = NORTH
	port_direction = SOUTH

	area_type = /area/shuttle/arrowhead_new/elevator

	// Shuttle timings
	callTime = 4 SECONDS
	rechargeTime = 3 SECONDS
	ignitionTime = 3 SECONDS
	ambience_flight = 'sound/vehicles/tank_driving.ogg'
	ignition_sound = 'sound/mecha/powerup.ogg'

	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	var/datum/door_controller/aggregate/door_control
	var/elevator_network

/obj/docking_port/mobile/arrow_elevator/Initialize(mapload, ...)
	. = ..()
	door_control = new()
	door_control.label = "elevator"
	for(var/area/shuttle_area in shuttle_areas)
		for(var/obj/structure/machinery/door/door in shuttle_area)
			if(istype(door, /obj/structure/machinery/door/poddoor/filler_object)) //poddoor filler was sneaking in
				continue
			door_control.add_door(door, door.id)

/obj/docking_port/mobile/arrow_elevator/Destroy(force, ...)
	. = ..()
	QDEL_NULL(door_control)

/obj/docking_port/mobile/arrow_elevator/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	door_control.control_doors("force-lock-launch", "all", force=TRUE)

/obj/docking_port/stationary/arrow_elevator
	dir=NORTH
	width= 5
	height= 5
	// shutters to clear the area
	var/airlock_area
	var/airlock_exit
	var/elevator_network

/obj/docking_port/stationary/arrow_elevator/proc/get_doors()
	. = list()
	for(var/area/target_area in world)
		if(istype(target_area, airlock_area))
			for(var/obj/structure/machinery/door/door in target_area)
				. += list(door)

/obj/docking_port/stationary/arrow_elevator/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	// open elevator doors
	if(istype(arriving_shuttle, /obj/docking_port/mobile/arrow_elevator))
		var/obj/docking_port/mobile/arrow_elevator/elevator = arriving_shuttle
		elevator.door_control.control_doors("open", airlock_exit)

	// open dock doors
	var/datum/door_controller/single/door_control = new()
	door_control.doors = get_doors()
	door_control.control_doors("open", FALSE, FALSE)
	qdel(door_control)

	playsound(src, 'sound/machines/ping.ogg', 25, 1)
	playsound(arriving_shuttle, 'sound/machines/ping.ogg', 25, 1)

/obj/docking_port/stationary/arrow_elevator/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	var/datum/door_controller/single/door_control = new()
	door_control.doors = get_doors()
	door_control.control_doors("force-lock-launch")
	qdel(door_control)


/obj/docking_port/stationary/arrow_elevator/occupied
	name = "occupied"
	id = STAT_ARROW_OCCUPIED
	airlock_exit = "east"


/obj/docking_port/stationary/arrow_elevator/empty
	name = "empty"
	id = STAT_ARROW_EMPTY
	airlock_exit = "east"


// Port
/obj/docking_port/stationary/arrow_elevator/port
	airlock_exit="east"
	elevator_network = "Arrow"

/obj/docking_port/stationary/arrow_elevator/port/upper
	name="Upper Port"
	id=STAT_ARROW_UPPER_PORT
	airlock_area=/area/shuttle/arrowhead_new/upper_port


/obj/docking_port/stationary/arrow_elevator/port/mid
	name="Mid Port"
	id=STAT_ARROW_MID_PORT
	airlock_area=/area/shuttle/arrowhead_new/mid_port


/obj/docking_port/stationary/arrow_elevator/port/lower
	name="Lower Port"
	id=STAT_ARROW_LOWER_PORT
	airlock_area=/area/shuttle/arrowhead_new/lower_port
	roundstart_template = /datum/map_template/shuttle/arrow_elevator


// Starboard
/obj/docking_port/stationary/arrow_elevator/star
	airlock_exit="east"
	elevator_network = "Arrow"

/obj/docking_port/stationary/arrow_elevator/star/upper
	name="Upper Starboard"
	id=STAT_ARROW_UPPER_STAR
	airlock_area=/area/shuttle/arrowhead_new/upper_star


/obj/docking_port/stationary/arrow_elevator/star/mid
	name="Mid Starboard"
	id=STAT_ARROW_MID_STAR
	airlock_area=/area/shuttle/arrowhead_new/mid_star


/obj/docking_port/stationary/arrow_elevator/star/lower
	name="Lower Starboard"
	id=STAT_ARROW_LOWER_STAR
	airlock_area=/area/shuttle/arrowhead_new/lower_star
