GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)

/// Global performance feature toggle flags
GLOBAL_VAR_INIT(perf_flags, NO_FLAGS)

GLOBAL_LIST_INIT(bitflags, list((1<<0), (1<<1), (1<<2), (1<<3), (1<<4), (1<<5), (1<<6), (1<<7), (1<<8), (1<<9), (1<<10), (1<<11), (1<<12), (1<<13), (1<<14), (1<<15), (1<<16), (1<<17), (1<<18), (1<<19), (1<<20), (1<<21), (1<<22), (1<<23)))

GLOBAL_VAR_INIT(master_mode, "Xenosurge")

GLOBAL_VAR_INIT(timezoneOffset, 0)

GLOBAL_LIST_INIT(pill_icon_mappings, map_pill_icons())

/// In-round override to default OOC color
GLOBAL_VAR(ooc_color_override)

// tacmap cooldown for xenos and marines
GLOBAL_VAR_INIT(uscm_canvas_cooldown, 0)
GLOBAL_VAR_INIT(xeno_canvas_cooldown, 0)

// getFlatIcon cooldown for xenos and marines
GLOBAL_VAR_INIT(uscm_flatten_map_icon_cooldown, 0)
GLOBAL_VAR_INIT(xeno_flatten_map_icon_cooldown, 0)

// latest unannounced flat tacmap for xenos and marines
GLOBAL_VAR(uscm_unannounced_map)
GLOBAL_VAR(xeno_unannounced_map)

//global tacmaps for action button access
GLOBAL_DATUM_INIT(uscm_tacmap_status, /datum/tacmap/drawing/status_tab_view, new)
GLOBAL_DATUM_INIT(xeno_tacmap_status, /datum/tacmap/drawing/status_tab_view/xeno, new)

/// List of roles that can be setup for each gamemode
GLOBAL_LIST_INIT(gamemode_roles, list())

GLOBAL_VAR_INIT(minimum_exterior_lighting_alpha, 255)

GLOBAL_DATUM_INIT(item_to_box_mapping, /datum/item_to_box_mapping, init_item_to_box_mapping())

/// Offset for the Operation time
GLOBAL_VAR_INIT(time_offset, setup_offset())

/// Sets the offset 2 lines above.
/proc/setup_offset()
	return rand(10 MINUTES, 24 HOURS)

/// The last count of possible candidates in the xeno larva queue (updated via get_alien_candidates)
GLOBAL_VAR(xeno_queue_candidate_count)

//Coordinate obsfucator
//Used by the rangefinders and linked systems to prevent coords collection/prefiring
/// A number between -500 and 500.
GLOBAL_VAR(obfs_x)
/// A number between -500 and 500.
GLOBAL_VAR(obfs_y)

GLOBAL_VAR_INIT(ai_xeno_weeding, FALSE)

GLOBAL_VAR_INIT(xenosurge_spawner_limit, 30)

GLOBAL_VAR_INIT(xenosurge_surge_started, 0)
GLOBAL_VAR_INIT(xenosurge_wave_xenos_max, 100)
GLOBAL_VAR_INIT(xenosurge_wave_xenos_current, 0)
GLOBAL_VAR_INIT(xenosurge_wave_veteran_xenos_current, 0)
GLOBAL_VAR_INIT(xenosurge_veteran_xenos_max, 6)


GLOBAL_VAR_INIT(xenosurge_wave_xenos_hp, 50)
GLOBAL_VAR_INIT(xenosurge_wave_xenos_armor, 0)
GLOBAL_VAR_INIT(xenosurge_wave_xenos_dam_min, 5)
GLOBAL_VAR_INIT(xenosurge_wave_xenos_dam_max, 7)

GLOBAL_VAR_INIT(xenosurge_spawner_xenos, 5)
GLOBAL_VAR_INIT(xenosurge_spawner_delay, 100)
GLOBAL_VAR_INIT(xenosurge_spawner_variance, 10)

GLOBAL_VAR_INIT(xenosurge_veteran_spawner_xenos_max, 2)
GLOBAL_VAR_INIT(xenosurge_veteran_spawner_delay, 100)
GLOBAL_VAR_INIT(xenosurge_veteran_spawner_variance, 50)

GLOBAL_VAR_INIT(xenosurge_veteran_type, 4)

GLOBAL_LIST_EMPTY(xenosurge_configured_spawners)

GLOBAL_VAR_INIT(spawner_number, 1)

GLOBAL_VAR_INIT(quest_items_number, 0)
GLOBAL_VAR_INIT(quest_items_found, 0)

GLOBAL_VAR_INIT(ammo_restock_next, 0)
GLOBAL_VAR_INIT(ammo_restock_full, 0)
GLOBAL_VAR_INIT(ammo_restock_delay, 6000)

GLOBAL_VAR_INIT(primary_objective, "Awaiting Orders")
GLOBAL_VAR_INIT(secondary_objective, "Awaiting Orders")

GLOBAL_VAR_INIT(boss_stage, 1)
GLOBAL_VAR_INIT(boss_stage_max, 4)
GLOBAL_VAR_INIT(boss_drones, 0)
GLOBAL_LIST_EMPTY(boss_loose_drones)
GLOBAL_VAR_INIT(boss_loose_drones_max, 30)
GLOBAL_VAR_INIT(stats_boss_total_damage, 0)
GLOBAL_VAR_INIT(stats_boss_hits, 0)
