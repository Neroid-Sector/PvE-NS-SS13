/datum/npc

	var/mob/living/carbon/human/owner
	var/current_waypoint_group
	var/current_direction
	var/obj/effect/landmark/npc_nav_waypoint/current_nav_point

/datum/npc/New(mob/human)
	owner = human
	. = ..()

/datum/npc/proc/ChairBuckle()
	var/current_turf = get_turf(owner)
	for(var/obj/structure/bed/chair/chair in current_turf)
		if(chair != null)
			chair.do_buckle(owner, owner)
			break

/datum/npc/proc/ChairUnBuckle()
	var/current_turf = get_turf(owner)
	for(var/obj/structure/bed/chair/chair in current_turf)
		if(chair != null)
			chair.manual_unbuckle(owner)

/datum/npc/proc/WalkMove()
	if(!current_nav_point) return
	var/turf/target_turf = get_turf(current_nav_point)
	step_towards(owner,target_turf)
	sleep(2)
	var/current_turf = get_turf(owner)
	if(current_turf == target_turf)
		var/next_nav_point
		if(current_direction == 1)
			if(current_nav_point.waypoint_id == "end")
				current_waypoint_group = null
				current_direction = null
				current_nav_point = null
				ChairBuckle()
				return
			next_nav_point = current_nav_point.waypoint_next
		if(current_direction == 2)
			if(current_nav_point.waypoint_id == "start")
				current_waypoint_group = null
				current_direction = null
				current_nav_point = null
				ChairBuckle()
				return
			next_nav_point = current_nav_point.waypoint_previous
		current_nav_point = next_nav_point
	INVOKE_ASYNC(src, PROC_REF(WalkMove))
	return

/datum/npc/proc/WalkDesignate(target_waypoint_group,target_direction)
	if(!target_waypoint_group) return
	current_waypoint_group = target_waypoint_group
	if(!target_direction) current_direction = 1
	if(target_direction) current_direction = target_direction
	for(var/obj/effect/landmark/npc_nav_waypoint/waypoint in GLOB.navigation_waypoints)
		if(waypoint.waypoint_group == current_waypoint_group)
			if(current_direction == 1)
				if(waypoint.waypoint_id == "start")
					current_nav_point = waypoint
					break
			if(current_direction == 2)
				if(waypoint.waypoint_id == "end")
					current_nav_point = waypoint
					break
	if(!current_nav_point)
		message_admins("Error: [owner] failed to find initial waypoint in waypoint group [current_waypoint_group]. Movement not possible.")
		return
	ChairUnBuckle()
	WalkMove()
	return
