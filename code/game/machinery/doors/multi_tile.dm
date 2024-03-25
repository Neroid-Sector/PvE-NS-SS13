//Terribly sorry for the code doubling, but things go derpy otherwise.
//Refactored multi_tile/almayer into multi_tile parent, as we did not use the flat doors any more.

/obj/structure/machinery/door/airlock/multi_tile
	width = 2
	damage_cap = HEALTH_DOUBLE_DOOR
	assembly_type = /obj/structure/airlock_assembly/multi_tile
	tiles_with = list(
		/obj/structure/window/framed/almayer, //Tiles with is here FOR SAFETY PURPOSES
		/obj/structure/machinery/door/airlock,
	)
	openspeed = 4 //shorter open animation.

/obj/structure/machinery/door/airlock/multi_tile/close() //Nasty as hell O(n^2) code but unfortunately necessary
	for(var/turf/turf_tile in locs)
		for(var/obj/vehicle/multitile/vehicle_tile in turf_tile)
			if(vehicle_tile) return 0

	return ..()

/obj/structure/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	update_icon()

/obj/structure/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/multi_tile/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/multi_tile/take_damage(taken_damage, mob/damaging_mob)
	var/damage_check = max(0, damage + taken_damage)
	if(damage_check >= damage_cap && damaging_mob && is_mainship_level(z))
		SSclues.create_print(get_turf(damaging_mob), damaging_mob, "The fingerprint contains bits of wire and metal specks.")
	..()


// ALMAYER

/obj/structure/machinery/door/airlock/multi_tile/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic/solid
	icon = 'icons/obj/structures/doors/2x1generic_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/2x1medidoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid
	icon = 'icons/obj/structures/doors/2x1medidoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research
	name = "\improper Research Airlock"
	req_one_access = list(ACCESS_MARINE_RESEARCH, ACCESS_WY_RESEARCH, ACCESS_WY_EXEC)
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/2x1comdoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced
	name = "\improper Reinforced Command Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid
	icon = 'icons/obj/structures/doors/2x1comdoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced
	name = "\improper Reinforced Command Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

//------Dropship Cargo Doors -----//

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear
	opacity = TRUE
	width = 3
	unslashable = TRUE
	unacidable = TRUE
	no_panel = 1
	not_weldable = 1
	var/queen_pryable = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ex_act(severity)
	return


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/unlock()
	if(is_reserved_level(z))
		return // in orbit
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(!queen_pryable)
		return ..()

	if(!locked)
		return ..()

	to_chat(xeno, SPAN_NOTICE("You try and force the doors open"))
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		unlock(TRUE)
		open(1)
		lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1
	name = "\improper Alamo cargo door"
	icon = 'icons/obj/structures/doors/dropship1_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2
	name = "\improper Normandy cargo door"
	icon = 'icons/obj/structures/doors/dropship2_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/upp
	name = "\improper Akademia Nauk cargo door"
	icon = 'icons/obj/structures/doors/dropshipupp_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor
	name = "bulkhead blast door"
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	desc = "A heavyset bulkhead door. Built to withstand explosions, gunshots, and extreme pressure. Chances are you're not getting through this."

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat
	name = "lifeboat docking hatch"
	icon = 'icons/obj/structures/doors/lifeboatdoors.dmi'
	desc = "A heavyset bulkhead for a lifeboat."
	safe = FALSE
	autoclose = FALSE
	locked = TRUE
	opacity = FALSE
	glass = TRUE
	queen_pryable = FALSE
	var/throw_dir = EAST

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/bumpopen(mob/user as mob)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/close_and_lock()
	unlock(TRUE)
	close(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/unlock_and_open()
	unlock(TRUE)
	open(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/close()
	. = ..()
	for(var/turf/self_turf as anything in locs)
		var/turf/projected = get_ranged_target_turf(self_turf, throw_dir, 1)
		for(var/atom/movable/atom_movable in self_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(5, WEAKEN)
				to_chat(mob, SPAN_HIGHDANGER("\The [src] shoves you out!"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 1, SPEED_FAST, null, FALSE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	. = ..()
	if(istype(port, /obj/docking_port/mobile/crashable/lifeboat))
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = port
		lifeboat.doors += src

/// External airlock that is part of the lifeboat dock
/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor
	name = "bulkhead blast door"
	desc = "A heavyset bulkhead door. Built to withstand explosions, gunshots, and extreme pressure. Chances are you're not getting through this."
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	safe = FALSE
	/// ID of the related stationary docking port operating this
	var/linked_dock

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Initialize(mapload, ...)
	GLOB.lifeboat_doors += src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Destroy()
	GLOB.lifeboat_doors -= src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/vacate_premises()
	for(var/turf/self_turf as anything in locs)
		var/turf/near_turf = get_step(self_turf, throw_dir)
		var/turf/space_turf = get_step(near_turf, throw_dir)
		var/turf/projected = get_ranged_target_turf(space_turf, EAST, 50)
		for(var/atom/movable/atom_movable in near_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(10, STUN)
				to_chat(mob, SPAN_HIGHDANGER("You get sucked into space!"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			atom_movable.forceMove(space_turf)
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE, HIGH_LAUNCH)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), atom_movable), 3 SECONDS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/bolt_explosion()
	var/turf/turf = get_step(src, throw_dir|dir)
	cell_explosion(turf, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("lifeboat explosive bolt"))

// Elevator door
/obj/structure/machinery/door/airlock/multi_tile/elevator
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 22

/obj/structure/machinery/door/airlock/multi_tile/elevator/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/freight
	name = "\improper Freight Elevator Hatch"


/obj/structure/machinery/door/airlock/multi_tile/elevator/access
	icon = 'icons/obj/structures/doors/4x1_elevator_access.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/freight
	name = "\improper Freight Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/2x1secdoor.dmi'
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass
	icon = 'icons/obj/structures/doors/2x1secdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE
/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/2x1engidoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_ENGINEERING)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass
	icon = 'icons/obj/structures/doors/2x1engidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine
	icon = 'icons/obj/structures/doors/2x1prepdoor.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/alpha
	name = "\improper Alpha Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/bravo
	name = "\improper Bravo Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/charlie
	name = "\improper Charlie Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/delta
	name = "\improper Delta Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared
	name = "\improper Squads Preparations"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo
	name = "\improper Alpha-Bravo Squads Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo/yellow
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta
	name = "\improper Charlie-Delta Squads Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta/blue
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'


/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1personaldoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1almayerdoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer/glass
	icon = 'icons/obj/structures/doors/2x1almayerdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

//USCM GROUND OUTPOST

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground
	icon = 'icons/obj/structures/doors/2x1prepdoor.dmi'
	dir = EAST
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/general
	req_one_access = list(ACCESS_USCM_GROUND_GENERAL, ACCESS_USCM_GROUND_GUEST)
	glass = TRUE
	opacity = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/general/cafeteria
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	dir = NORTH
	glass = TRUE
	opacity = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/armory
	icon = 'icons/obj/structures/doors/2x1almayerdoor.dmi'
	dir = NORTH
	req_access = list(ACCESS_USCM_GROUND_GENERAL)

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/armory/weapons
	name = "\improper Weapon Storage"
	autoname = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/armory/prep
	name = "\improper Specialized Prep"
	autoname = FALSE
	req_access = null
	req_one_access = list(ACCESS_USCM_GROUND_SMARTPREP, ACCESS_USCM_GROUND_MEDPREP, ACCESS_USCM_GROUND_SPECPREP, ACCESS_USCM_GROUND_TLPREP, ACCESS_USCM_GROUND_ARMORY) //Don't need to be in here if you're not getting prepped.

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/medical
	icon = 'icons/obj/structures/doors/2x1medidoor.dmi'
	dir = NORTH
	req_access = list(ACCESS_USCM_GROUND_MEDICAL)
	glass = TRUE
	opacity = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/warehouse
	dir = NORTH
	icon = 'icons/obj/structures/doors/2x1engidoor.dmi'
	req_access = list(ACCESS_USCM_GROUND_WAREHOUSE)

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/warehouse/glass
	icon = 'icons/obj/structures/doors/2x1engidoor_glass.dmi'
	glass = TRUE
	opacity = FALSE

/obj/structure/machinery/door/airlock/multi_tile/uscm_ground/civilian
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	glass = TRUE
	opacity = FALSE
	req_access = list(ACCESS_USCM_GROUND_GUEST)