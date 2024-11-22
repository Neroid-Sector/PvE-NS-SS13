/obj/effect/landmark/pve_mob
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
