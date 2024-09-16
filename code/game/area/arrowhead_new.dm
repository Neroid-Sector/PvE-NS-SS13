

//Initial

// Fore = West  | Aft = East //
// Port = South | Starboard = North //
// Bow = Ship Front | Stern = Ship Rear //

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


/area/arrowhead_new/upper/cic
	name = "UAS Arrowhead - Combat Information Center "
	icon_state = "cic"
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 50


/area/arrowhead_new/upper/briefing
	name = "UAS Arrowhead - Briefing Hall"
	icon_state = "briefing"


/*=================================================
		  Middle Deck | set fake_zlevel = 2
=================================================*/
/area/arrowhead_new/middle
	fake_zlevel = 2


/area/arrowhead_new/middle/engineering
	name = "UAS Arrowhead - Comms Closet"
	icon_state = "upperengineering"


/area/arrowhead_new/middle/hangar
	name = "UAS Arrowhead - Force Recon Squads Alpha and Delta - Dropship Launch Pad"
	icon_state = "hangar"
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50


/area/arrowhead_new/middle/squad_prep
	name = "UAS Arrowhead - Squad Preperation"
	icon_state = "alpha"


/area/arrowhead_new/middle/port_bunks
	name = "UAS Arrowhead - Port Bunks"
	icon_state = "livingspace"


/area/arrowhead_new/middle/star_bunks
	name = "UAS Arrowhead - Starboard Bunks"
	icon_state = "livingspace"


/*=================================================
		  Lower Deck | set fake_zlevel = 3
=================================================*/
/area/arrowhead_new/lower
	fake_zlevel = 3


/area/arrowhead_new/lower/port_bunks
	name = "UAS Arrowhead - Lower Port Bunks"
	icon_state = "livingspace"


/area/arrowhead_new/lower/star_bunks
	name = "UAS Arrowhead - Lower Starboard Bunks"
	icon_state = "livingspace"

/area/arrowhead_new/lower/airoom
	name = "UAS Arrowhead - AI Core"
	icon_state = "airoom"
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 120
