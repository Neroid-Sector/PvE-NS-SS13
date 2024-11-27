/obj/effect/landmark/pve_mob
	name = "Mob Spawner Landmark"
	icon_state = "drone"
	var/mob/living/pve_boss/missle_bot/spawned_bot

/obj/effect/landmark/pve_mob/Initialize(mapload, ...)
	var/area/landmark_area = get_area(src)
	landmark_area.mob_spawners.Add(src)
	. = ..()

/obj/effect/landmark/pve_mob/Destroy()
	var/area/landmark_area = get_area(src)
	landmark_area.mob_spawners.Remove(src)
	. = ..()

/obj/effect/landmark/pve_mob/proc/MobSpawn()
	if(spawned_bot == null)
		var/area/landmark_turf = get_turf(src)
		var/mob/living/pve_boss_drone/spawned_drone = new(landmark_turf)
		spawned_drone.source_landmark = src

/obj/effect/landmark/pve_boss_navigation
	name = "Boss Navigation Landmark"
	icon_state = "boss"
	var/id_tag = "standard" // This only matters for one waypoint, and that is one tagged as "center" to which the boss retreats during the add phase. More uses to come likely

/obj/effect/landmark/pve_boss_navigation/Initialize(mapload, ...)
	var/area/landmark_area = get_area(src)
	landmark_area.boss_waypoints.Add(src)
	. = ..()

/obj/effect/landmark/pve_boss_navigation/Destroy()
	var/area/landmark_area = get_area(src)
	landmark_area.boss_waypoints.Remove(src)
	. = ..()

/obj/effect/landmark/pve_boss_navigation/center
	id_tag = "center"
