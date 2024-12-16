/obj/effect/landmark/pve_mob
	name = "Mob Spawner Landmark"
	icon_state = "drone"
	var/area/landmark_area
	var/mob/living/pve_boss_drone/spawned_bot
	var/mob_spawned = 0
	var/mob_destroyed = 0

/obj/effect/landmark/pve_mob/Initialize(mapload, ...)
	landmark_area = get_area(src)
	if(landmark_area.mob_spawners.Find(src) == 0)
		landmark_area.mob_spawners.Add(src)
	. = ..()

/obj/effect/landmark/pve_mob/Destroy()
	if(landmark_area)
		landmark_area.mob_spawners.Remove(src)
	. = ..()

/obj/effect/landmark/pve_mob/proc/MobSpawn()
	if(mob_spawned == 1 || mob_destroyed == 1) return
	if(spawned_bot == null)
		var/area/landmark_turf = get_turf(src)
		var/mob/living/pve_boss_drone/spawned_drone = new(landmark_turf)
		spawned_bot = spawned_drone
		spawned_drone.source_landmark = src
		mob_spawned = 1

/obj/effect/landmark/pve_mob/proc/MobDeSpawn()
	if(spawned_bot != null)
		mob_spawned = 0
		spawned_bot.AnimateExit()
		qdel(spawned_bot)
	return

/obj/effect/landmark/pve_mob/boss_mobs
	name = "Boss Mob Spawner Landmark"
	icon_state = "boss_drone"
	mob_spawned = 1

/obj/effect/landmark/pve_mob/boss_mobs/MobSpawn()
	return

/obj/effect/landmark/pve_mob/boss_mobs/MobDeSpawn()
	return

/obj/effect/landmark/pve_boss_navigation
	name = "Boss Navigation Landmark"
	icon_state = "boss"
	var/id_tag = "standard" // This only matters for one waypoint, and that is one tagged as "center" to which the boss retreats during the add phase. More uses to come likely
	var/area/landmark_area

/obj/effect/landmark/pve_boss_navigation/Initialize(mapload, ...)
	landmark_area = get_area(src)
	if(landmark_area.boss_waypoints.Find(src) == 0)
		landmark_area.boss_waypoints.Add(src)
	. = ..()

/obj/effect/landmark/pve_boss_navigation/Destroy()
	if(landmark_area)
		landmark_area.boss_waypoints.Remove(src)
	. = ..()

/obj/effect/landmark/pve_boss_navigation/center
	id_tag = "center"
