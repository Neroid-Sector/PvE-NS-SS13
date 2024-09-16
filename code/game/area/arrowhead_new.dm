//Initial


// Fore = West  | Aft = East //
// Port = South | Starboard = North //


/area/arrowhead_new
	name = "UAS Arrowhead"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "Arrowhead"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE


/*=================================================
		  Upper Deck | set fake_zlevel = 1
=================================================*/
/area/arrowhead_new/upper
	fake_zlevel = 1


// Stairs
/area/arrowhead_new/upper/stairs
	name = "UAS Arrowhead - Upper Deck Stairs"
	icon_state = "stairs_upperdeck"
	resin_construction_allowed = FALSE


// Hallways
/area/arrowhead_new/upper/hallways
	icon_state = "port"


/area/arrowhead_new/upper/hallways/port
	name = "UAS Arrowhead - Upper Port Hallway"


/area/arrowhead_new/upper/hallways/star
	name = "UAS Arrowhead - Upper Starboard Hallway"


/area/arrowhead_new/upper/hallways/fore
	name = "UAS Arrowhead - Upper Fore Hallway"


/area/arrowhead_new/upper/hallways/aft
	name = "UAS Arrowhead - Upper Aft Hallway"


// Maint
/area/arrowhead_new/upper/maint
	name = "UAS Arrowhead - Upper Fore Hull"
	icon_state = "upperhull"


// Upper Bunks
/area/arrowhead_new/upper/bunks
	icon_state = "livingspace"
	minimap_color = MINIMAP_AREA_COLONY


/area/arrowhead_new/upper/bunks/co
	name = "UAS Arrowhead - Commanding Officer's Bunk"


/area/arrowhead_new/upper/bunks/xo
	name = "UAS Arrowhead - Executive Officer's Bunk"


/area/arrowhead_new/upper/bunks/vip
	name = "UAS Arrowhead - Visitor's Bunk"


// CIC
/area/arrowhead_new/upper/cic
	name = "UAS Arrowhead - Combat Information Center"
	icon_state = "cic"
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 50
	minimap_color = MINIMAP_AREA_COMMAND


// IO Lab
/area/arrowhead_new/upper/computerlab
	name = "UAS Arrowhead - Computer Lab"
	icon_state = "ceroom"


// Conference Office
/area/arrowhead_new/upper/meeting
	name = "UAS Arrowhead - Conference Office"
	icon_state = "airoom"
	minimap_color = MINIMAP_AREA_COMMAND


// Kitchen
/area/arrowhead_new/upper/kitchen
	name = "UAS Arrowhead - Kitchen"
	icon_state = "gruntrnr"
	minimap_color = MINIMAP_AREA_COLONY


// Briefing Hall
/area/arrowhead_new/upper/briefing
	name = "UAS Arrowhead - Briefing Hall"
	icon_state = "briefing"
	minimap_color = MINIMAP_AREA_COLONY


// Brig
/area/arrowhead_new/upper/brig
	name = "UAS Arrowhead - Brig"
	icon_state = "brig"
	minimap_color = MINIMAP_AREA_SEC


/area/arrowhead_new/upper/brig/cells
	name = "UAS Arrowhead - Brig Cells"
	icon_state = "brigcells"


// Containment
/area/arrowhead_new/upper/containment
	name = "UAS Arrowhead - Containment Cell"
	icon_state = "science"
	minimap_color = MINIMAP_AREA_RESEARCH


/*=================================================
		  Middle Deck | set fake_zlevel = 2
=================================================*/
/area/arrowhead_new/middle
	fake_zlevel = 2


// Stairs
/area/arrowhead_new/middle/stairs
	name = "UAS Arrowhead - Middle Deck Stairs"
	icon_state = "stairs_lowerdeck"
	resin_construction_allowed = FALSE


// Hallways
/area/arrowhead_new/middle/hallways
	icon_state = "port"


/area/arrowhead_new/middle/hallways/port
	name = "UAS Arrowhead - Middle Port Hallway"


/area/arrowhead_new/middle/hallways/star
	name = "UAS Arrowhead - Middle Starboard Hallway"


/area/arrowhead_new/middle/hallways/fore
	name = "UAS Arrowhead - Middle Fore Hallway"


/area/arrowhead_new/middle/hallways/aft
	name = "UAS Arrowhead - Middle Aft Hallway"


// Maint
/area/arrowhead_new/middle/maint
	icon_state = "lowerhull"


/area/arrowhead_new/middle/maint/port
	name = "UAS Arrowhead - Lower Port Hull"


/area/arrowhead_new/middle/maint/star
	name = "UAS Arrowhead - Lower Starboard Hull"


/area/arrowhead_new/middle/maint/fore
	name = "UAS Arrowhead - Lower Fore Hull"


/area/arrowhead_new/middle/maint/aft
	name = "UAS Arrowhead - Lower Aft Hull"


// Cryo
/area/arrowhead_new/middle/cryo_cells
	name = "UAS Arrowhead - Cryo Bay"
	icon_state = "cryo"
	minimap_color = MINIMAP_AREA_COLONY


// SEA Office
/area/arrowhead_new/middle/sea
	name = "UAS Arrowhead - Advisor's Office"
	icon_state = "chiefmpoffice"
	minimap_color = MINIMAP_AREA_COLONY


// Engineering
/area/arrowhead_new/middle/engineering
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15
	minimap_color = MINIMAP_AREA_ENGI


/area/arrowhead_new/middle/engineering/reactor
	name = "UAS Arrowhead - Reactor Core"
	icon_state = "coreroom"
	flags_area = AREA_NOTUNNEL


/area/arrowhead_new/middle/engineering/main
	name = "UAS Arrowhead - Engineering Workshop"
	icon_state = "workshop"


/area/arrowhead_new/middle/engineering/tcomms
	name = "UAS Arrowhead - Telecommunications"
	icon_state = "ceroom"
	flags_area = AREA_NOTUNNEL


/area/arrowhead_new/middle/engineering/storage
	name = "UAS Arrowhead - Engineering Storage"
	icon_state = "ceroom"


// Hanger
/area/arrowhead_new/middle/hangar
	name = "UAS Arrowhead - Force Recon Squads Alpha and Delta - Dropship Launch Pad"
	icon_state = "hangar"
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

// Req
/area/arrowhead_new/middle/requisitions
	name = "UAS Arrowhead - Cargo Bay"
	icon_state = "req"
	minimap_color = MINIMAP_AREA_COLONY


// Prep
/area/arrowhead_new/middle/prep
	icon_state = "alpha"
	minimap_color = MINIMAP_AREA_COLONY


/area/arrowhead_new/middle/prep/squad
	name = "UAS Arrowhead - Squad Preperation"


/area/arrowhead_new/middle/prep/point
	name = "UAS Arrowhead - Pointman Preperation"


/area/arrowhead_new/middle/prep/lead
	name = "UAS Arrowhead - Team Lead Preperation"


// Mid Bunks
/area/arrowhead_new/middle/port_bunks
	name = "UAS Arrowhead - Port Bunks"
	icon_state = "livingspace"
	minimap_color = MINIMAP_AREA_COLONY


/area/arrowhead_new/middle/star_bunks
	name = "UAS Arrowhead - Starboard Bunks"
	icon_state = "livingspace"
	minimap_color = MINIMAP_AREA_COLONY


// Astro-Nav
/area/arrowhead_new/middle/weapon_room
	name = "UAS Arrowhead - Weapon Control"
	icon_state = "weaponroom"
	minimap_color = MINIMAP_AREA_SEC


/area/arrowhead_new/middle/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL


// Medical
/area/arrowhead_new/middle/medical
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120
	minimap_color = MINIMAP_AREA_MEDBAY


/area/arrowhead_new/middle/medical/medbay
	name = "UAS Arrowhead - Medbay"
	icon_state = "medical"


/area/arrowhead_new/middle/medical/morgue
	name = "UAS Arrowhead - Morgue"
	icon_state = "operating"


/area/arrowhead_new/middle/medical/or1
	name = "UAS Arrowhead - Operating Room 1"
	icon_state = "operating"


/area/arrowhead_new/middle/medical/or2
	name = "UAS Arrowhead - Operating Room 2"
	icon_state = "operating"


/area/arrowhead_new/middle/medical/or3
	name = "UAS Arrowhead - Operating Room 3"
	icon_state = "operating"


/area/arrowhead_new/middle/medical/or4
	name = "UAS Arrowhead - Operating Room 4"
	icon_state = "operating"


/*=================================================
		  Lower Deck | set fake_zlevel = 3
=================================================*/
/area/arrowhead_new/lower
	fake_zlevel = 3


// Stairs
/area/arrowhead_new/lower/stairs
	name = "UAS Arrowhead - Lower Deck Stairs"
	icon_state = "stairs_lowerdeck"
	resin_construction_allowed = FALSE


// Maint
/area/arrowhead_new/lower/maint
	icon_state = "lowerhull"


/area/arrowhead_new/lower/maint/port
	name = "UAS Arrowhead - Lower Port Hull"


/area/arrowhead_new/lower/maint/star
	name = "UAS Arrowhead - Lower Starboard Hull"


/area/arrowhead_new/lower/maint/fore
	name = "UAS Arrowhead - Lower Fore Hull"


/area/arrowhead_new/lower/maint/aft
	name = "UAS Arrowhead - Lower Aft Hull"

// Special
/area/arrowhead_new/lower/powered
	icon_state = "selfdestruct"
	requires_power = 0


/area/arrowhead_new/lower/powered/ert
	name = "UAS Arrowhead - Auxillary Docking Bay"
	minimap_color = MINIMAP_AREA_SEC


/area/arrowhead_new/lower/powered/evac
	name = "UAS Arrowhead - Departure Lounge"
	minimap_color = MINIMAP_AREA_SEC


// OT Lab
/area/arrowhead_new/lower/ot
	name = "UAS Arrowhead - Ordnance workshop"
	icon_state = "workshop"
	minimap_color = MINIMAP_AREA_ENGI


// AI Core
/area/arrowhead_new/lower/airoom
	name = "UAS Arrowhead - AI Core"
	icon_state = "airoom"
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 120
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_COMMAND


// Firing Range
/area/arrowhead_new/lower/firing_range
	name = "UAS Arrowhead - Firing Range"
	icon_state = "firingrange"
	minimap_color = MINIMAP_AREA_COLONY


// Crew Bunks
/area/arrowhead_new/lower/bunks
	icon_state = "livingspace"
	minimap_color = MINIMAP_AREA_COLONY


/area/arrowhead_new/lower/bunks/port_bunks
	name = "UAS Arrowhead - Lower Port Bunks"


/area/arrowhead_new/lower/bunks/star_bunks
	name = "UAS Arrowhead - Lower Starboard Bunks"


/area/arrowhead_new/lower/bunks/vc_bunk
	name = "UAS Arrowhead - Vehicle Crew Bunks"


/area/arrowhead_new/lower/bunks/pilot_bunk
	name = "UAS Arrowhead - Pilot Bunks"
