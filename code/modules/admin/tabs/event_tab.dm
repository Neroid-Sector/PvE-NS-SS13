/client/proc/cmd_admin_change_custom_event()
	set name = "Setup Event Info"
	set category = "Admin.Events"

	if(!admin_holder)
		to_chat(usr, "Only administrators may use this command.")
		return

	if(!LAZYLEN(GLOB.custom_event_info_list))
		to_chat(usr, "custom_event_info_list is not initialized, tell a dev.")
		return

	var/list/temp_list = list()

	for(var/T in GLOB.custom_event_info_list)
		var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[T]
		temp_list["[CEI.msg ? "(x) [CEI.faction]" : CEI.faction]"] = CEI.faction

	var/faction = tgui_input_list(usr, "Select faction. Ghosts will see only \"Global\" category message. Factions with event message set are marked with (x).", "Faction Choice", temp_list)
	if(!faction)
		return

	faction = temp_list[faction]

	if(!GLOB.custom_event_info_list[faction])
		to_chat(usr, "Error has occured, [faction] category is not found.")
		return

	var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[faction]

	var/input = input(usr, "Enter the custom event message for \"[faction]\" category. Be descriptive. \nTo remove the event message, remove text and confirm.", "[faction] Event Message", CEI.msg) as message|null
	if(isnull(input))
		return

	if(input == "" || !input)
		CEI.msg = ""
		message_admins("[key_name_admin(usr)] has removed the event message for \"[faction]\" category.")
		return

	CEI.msg = html_encode(input)
	message_admins("[key_name_admin(usr)] has changed the event message for \"[faction]\" category.")

	CEI.handle_event_info_update(faction)

/client/proc/change_security_level()
	if(!check_rights(R_ADMIN))
		return
	var sec_level = input(usr, "It's currently code [get_security_level()].", "Select Security Level")  as null|anything in (list("green","blue","red","delta")-get_security_level())
	if(sec_level && alert("Switch from code [get_security_level()] to code [sec_level]?","Change security level?","Yes","No") == "Yes")
		set_security_level(seclevel2num(sec_level))
		log_admin("[key_name(usr)] changed the security level to code [sec_level].")

/client/proc/toggle_gun_restrictions()
	if(!admin_holder || !config)
		return

	if(CONFIG_GET(flag/remove_gun_restrictions))
		to_chat(src, "<b>Enabled gun restrictions.</b>")
		message_admins("Admin [key_name_admin(usr)] has enabled WY gun restrictions.")
	else
		to_chat(src, "<b>Disabled gun restrictions.</b>")
		message_admins("Admin [key_name_admin(usr)] has disabled WY gun restrictions.")
	CONFIG_SET(flag/remove_gun_restrictions, !CONFIG_GET(flag/remove_gun_restrictions))

/client/proc/togglebuildmodeself()
	set name = "Buildmode"
	set category = "Admin.Events"
	if(!check_rights(R_ADMIN))
		return

	if(src.mob)
		togglebuildmode(src.mob)

/client/proc/drop_bomb()
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."
	set category = "Admin.Fun"

	var/turf/epicenter = mob.loc
	handle_bomb_drop(epicenter)

/client/proc/handle_bomb_drop(atom/epicenter)
	var/custom_limit = 5000
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/list/falloff_shape_choices = list("CANCEL", "Linear", "Exponential")
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Drop Bomb", choices)
	var/datum/cause_data/cause_data = create_cause_data("divine intervention")
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3, , , , cause_data)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4, , , , cause_data)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5, , , , cause_data)
		if("Custom Bomb")
			var/power = tgui_input_number(src, "Power?", "Power?")
			if(!power)
				return

			var/falloff = tgui_input_number(src, "Falloff?", "Falloff?")
			if(!falloff)
				return

			var/shape_choice = tgui_input_list(src, "Select falloff shape?", "Select falloff shape", falloff_shape_choices)
			var/explosion_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
			switch(shape_choice)
				if("CANCEL")
					return 0
				if("Exponential")
					explosion_shape = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL

			if(power > custom_limit)
				return
			cell_explosion(epicenter, power, falloff, explosion_shape, null, cause_data)
			message_admins("[key_name(src, TRUE)] dropped a custom cell bomb with power [power], falloff [falloff] and falloff_shape [shape_choice]!")
	message_admins("[ckey] used 'Drop Bomb' at [epicenter.loc].")


/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set name = "EM Pulse"
	set category = "Admin.Fun"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null)
		return

	if(!heavy && !light)
		return

	empulse(O, heavy, light)
	message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
	return

/datum/admins/proc/admin_force_ERT_shuttle()
	set name = "Force ERT Shuttle"
	set desc = "Force Launch the ERT Shuttle."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return
	if(!check_rights(R_EVENT))
		return

	var/list/shuttle_map = list()
	for(var/obj/docking_port/mobile/emergency_response/ert_shuttles in SSshuttle.mobile)
		shuttle_map[ert_shuttles.name] = ert_shuttles.id
	var/tag = tgui_input_list(usr, "Which ERT shuttle should be force launched?", "Select an ERT Shuttle:", shuttle_map)
	if(!tag)
		return

	var/shuttleId = shuttle_map[tag]
	var/list/docks = SSshuttle.stationary
	var/list/targets = list()
	var/list/target_names = list()
	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)
	for(var/obj/docking_port/stationary/emergency_response/dock in docks)
		var/can_dock = ert.canDock(dock)
		if(can_dock == SHUTTLE_CAN_DOCK)
			targets += list(dock)
			target_names +=  list(dock.name)
	var/dock_name = tgui_input_list(usr, "Where on the [MAIN_SHIP_NAME] should the shuttle dock?", "Select a docking zone:", target_names)
	var/launched = FALSE
	if(!dock_name)
		return
	for(var/obj/docking_port/stationary/emergency_response/dock as anything in targets)
		if(dock.name == dock_name)
			var/obj/docking_port/stationary/target = SSshuttle.getDock(dock.id)
			ert.request(target)
			launched=TRUE
	if(!launched)
		to_chat(usr, SPAN_WARNING("Unable to launch this Distress shuttle at this moment. Aborting."))
		return

	message_admins("[key_name_admin(usr)] force launched a distress shuttle ([tag])")

/datum/admins/proc/admin_force_distress()
	set name = "Distress Beacon"
	set desc = "Call a distress beacon. This should not be done if the shuttle's already been called."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return

	if(!check_rights(R_EVENT)) // Seems more like an event thing than an admin thing
		return

	var/list/list_of_calls = list()
	var/list/assoc_list = list()

	for(var/datum/emergency_call/L in SSticker.mode.all_calls)
		if(L && L.name != "name")
			list_of_calls += L.name
			assoc_list += list(L.name = L)
	list_of_calls = sortList(list_of_calls)

	list_of_calls += "Randomize"

	var/choice = tgui_input_list(usr, "Which distress call?", "Distress Signal", list_of_calls)

	if(!choice)
		return

	var/datum/emergency_call/chosen_ert
	if(choice == "Randomize")
		chosen_ert = SSticker.mode.get_random_call()
	else
		var/datum/emergency_call/em_call = assoc_list[choice]
		chosen_ert = new em_call.type()

	if(!istype(chosen_ert))
		return

	var/launch_broadcast = tgui_alert(usr, "Would you like to broadcast the beacon launch? This will reveal the distress beacon to all players.", "Announce distress beacon?", list("Yes", "No"), 20 SECONDS)
	if(launch_broadcast == "Yes")
		launch_broadcast = TRUE
	else
		launch_broadcast = FALSE

	var/announce_receipt = tgui_alert(usr, "Would you like to announce the beacon received message? This will reveal the distress beacon to all players.", "Announce beacon received?", list("Yes", "No"), 20 SECONDS)
	if(announce_receipt == "Yes")
		announce_receipt = TRUE
	else
		announce_receipt = FALSE

	var/turf/override_spawn_loc
	var/prompt = tgui_alert(usr, "Spawn at their assigned spawn, or at your location?", "Spawnpoint Selection", list("Spawn", "Current Location"), 0)
	if(!prompt)
		qdel(chosen_ert)
		return
	if(prompt == "Current Location")
		override_spawn_loc = get_turf(usr)

	chosen_ert.activate(quiet_launch = !launch_broadcast, announce_incoming = announce_receipt, override_spawn_loc = override_spawn_loc)

	message_admins("[key_name_admin(usr)] admin-called a [choice == "Randomize" ? "randomized ":""]distress beacon: [chosen_ert.name]")

/datum/admins/proc/admin_force_evacuation()
	set name = "Trigger Evacuation"
	set desc = "Triggers emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	set_security_level(SEC_LEVEL_RED)
	SShijack.initiate_evacuation()

	message_admins("[key_name_admin(usr)] forced an emergency evacuation.")

/datum/admins/proc/admin_cancel_evacuation()
	set name = "Cancel Evacuation"
	set desc = "Cancels emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	SShijack.cancel_evacuation()

	message_admins("[key_name_admin(usr)] canceled an emergency evacuation.")

/datum/admins/proc/add_req_points()
	set name = "Add Requisitions Points"
	set desc = "Add points to the ship requisitions department."
	set category = "Admin.Events"
	if(!SSticker.mode || !check_rights(R_ADMIN))
		return

	var/points_to_add = tgui_input_real_number(usr, "Enter the amount of points to give, or a negative number to subtract. 1 point = $100.", "Points", 0)
	if(!points_to_add)
		return
	else if((supply_controller.points + points_to_add) < 0)
		supply_controller.points = 0
	else if((supply_controller.points + points_to_add) > 99999)
		supply_controller.points = 99999
	else
		supply_controller.points += points_to_add


	message_admins("[key_name_admin(usr)] granted requisitions [points_to_add] points.")
	if(points_to_add >= 0)
		shipwide_ai_announcement("Additional Supply Budget has been authorised for this operation.")

/datum/admins/proc/check_req_heat()
	set name = "Check Requisitions Heat"
	set desc = "Check how close the CMB is to arriving to search Requisitions."
	set category = "Admin.Events"
	if(!SSticker.mode || !check_rights(R_ADMIN))
		return

	var/req_heat_change = tgui_input_real_number(usr, "Set the new requisitions black market heat. ERT is called at 100, disabled at -1. Current Heat: [supply_controller.black_market_heat]", "Modify Req Heat", 0, 100, -1)
	if(!req_heat_change)
		return

	supply_controller.black_market_heat = req_heat_change
	message_admins("[key_name_admin(usr)] set requisitions heat to [req_heat_change].")


/datum/admins/proc/admin_force_selfdestruct()
	set name = "Self-Destruct"
	set desc = "Trigger self-destruct countdown. This should not be done if the self-destruct has already been called."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN) || get_security_level() == "delta")
		return

	if(alert(src, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
		return

	set_security_level(SEC_LEVEL_DELTA)

	message_admins("[key_name_admin(usr)] admin-started self-destruct system.")

/client/proc/view_faxes()
	set name = "View Faxes"
	set desc = "View faxes from this round"
	set category = "Admin.Events"

	if(!admin_holder)
		return

	var/list/options = list("Weyland-Yutani", "High Command", "Provost", "Press", "CMB", "Other", "Cancel")
	var/answer = tgui_input_list(src, "Which kind of faxes would you like to see?", "Faxes", options)
	switch(answer)
		if("Weyland-Yutani")
			var/body = "<body>"

			for(var/text in GLOB.WYFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Weyland-Yutani", "wyfaxviewer", "size=300x600")
		if("High Command")
			var/body = "<body>"

			for(var/text in GLOB.USCMFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to High Command", "uscmfaxviewer", "size=300x600")
		if("Provost")
			var/body = "<body>"

			for(var/text in GLOB.ProvostFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Provost Office", "provostfaxviewer", "size=300x600")

		if("Press")
			var/body = "<body>"

			for(var/text in GLOB.PressFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Press organizations", "otherfaxviewer", "size=300x600")

		if("CMB")
			var/body = "<body>"

			for(var/text in GLOB.CMBFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Colonial Marshal Bureau", "cmbfaxviewer", "size=300x600")

		if("Other")
			var/body = "<body>"

			for(var/text in GLOB.GeneralFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Inter-machine Faxes", "otherfaxviewer", "size=300x600")
		if("Cancel")
			return

/client/proc/award_medal()
	if(!check_rights(R_ADMIN))
		return

	give_medal_award(as_admin=TRUE)

/client/proc/award_jelly()
	if(!check_rights(R_ADMIN))
		return

	// Mostly replicated code from observer.dm.hive_status()
	var/list/hives = list()
	var/datum/hive_status/last_hive_checked

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(hive.totalXenos.len > 0 || hive.total_dead_xenos.len > 0)
			hives += list("[hive.name]" = hive.hivenumber)
			last_hive_checked = hive

	if(!length(hives))
		to_chat(src, SPAN_ALERT("There seem to be no hives at the moment."))
		return
	else if(length(hives) > 1) // More than one hive, display an input menu for that
		var/faction = tgui_input_list(src, "Select which hive to award", "Hive Choice", hives, theme="hive_status")
		if(!faction)
			to_chat(src, SPAN_ALERT("Hive choice error. Aborting."))
			return
		last_hive_checked = GLOB.hive_datum[hives[faction]]

	give_jelly_award(last_hive_checked, as_admin=TRUE)

/client/proc/give_nuke()
	if(!check_rights(R_ADMIN))
		return
	var/nuketype = "Decrypted Operational Nuke"
	var/encrypt = tgui_alert(src, "Do you want the nuke to be already decrypted?", "Nuke Type", list("Encrypted", "Decrypted"), 20 SECONDS)
	if(encrypt == "Encrypted")
		nuketype = "Encrypted Operational Nuke"
	var/prompt = tgui_alert(src, "THIS CAN BE USED TO END THE ROUND. Are you sure you want to spawn a nuke? The nuke will be put onto the ASRS Lift.", "DEFCON 1", list("No", "Yes"), 30 SECONDS)
	if(prompt != "Yes")
		return

	var/datum/supply_order/new_order = new()
	new_order.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	new_order.object = supply_controller.supply_packs[nuketype]
	new_order.orderedby = MAIN_AI_SYSTEM
	new_order.approvedby = MAIN_AI_SYSTEM
	supply_controller.shoppinglist += new_order

	marine_announcement("A nuclear device has been supplied and will be delivered to requisitions via ASRS.", "NUCLEAR ARSENAL ACQUIRED", 'sound/misc/notice2.ogg')
	message_admins("[key_name_admin(usr)] admin-spawned a [encrypt] nuke.")
	log_game("[key_name_admin(usr)] admin-spawned a [encrypt] nuke.")

/client/proc/turn_everyone_into_primitives()
	var/random_names = FALSE
	if (alert(src, "Do you want to give everyone random numbered names?", "Confirmation", "Yes", "No") == "Yes")
		random_names = TRUE
	if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") != "Yes")
		return
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(ismonkey(H))
			continue
		H.set_species(pick("Monkey", "Yiren", "Stok", "Farwa", "Neaera"))
		H.is_important = TRUE
		if(random_names)
			var/random_name = "[lowertext(H.species.name)] ([rand(1, 999)])"
			H.change_real_name(H, random_name)
			if(H.wear_id)
				var/obj/item/card/id/card = H.wear_id
				card.registered_name = H.real_name
				card.name = "[card.registered_name]'s ID Card ([card.assignment])"

	message_admins("Admin [key_name(usr)] has turned everyone into a primitive")

/client/proc/force_hijack()
	set name = "Force Hijack"
	set desc = "Force a dropship to be hijacked"
	set category = "Admin.Shuttles"

	var/list/shuttles = list(DROPSHIP_ALAMO, DROPSHIP_NORMANDY)
	var/tag = tgui_input_list(usr, "Which dropship should be force hijacked?", "Select a dropship:", shuttles)
	if(!tag) return

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(tag)

	if(!dropship)
		to_chat(src, SPAN_DANGER("Error: Attempted to force a dropship hijack but the shuttle datum was null. Code: MSD_FSV_DIN"))
		log_admin("Error: Attempted to force a dropship hijack but the shuttle datum was null. Code: MSD_FSV_DIN")
		return

	var/confirm = tgui_alert(usr, "Are you sure you want to hijack [dropship]?", "Force hijack", list("Yes", "No")) == "Yes"
	if(!confirm)
		return

	var/obj/structure/machinery/computer/shuttle/dropship/flight/computer = dropship.getControlConsole()
	computer.hijack(usr, force = TRUE)

/client/proc/cmd_admin_create_centcom_report()
	set name = "Report: Faction"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/faction = tgui_input_list(usr, "Please choose faction your announcement will be shown to.", "Faction Selection", (FACTION_LIST_HUMANOID - list(FACTION_YAUTJA) + list("Everyone (-Yautja)")))
	if(!faction)
		return
	var/input = input(usr, "Please enter announcement text. Be advised, this announcement will be heard both on Almayer and planetside by conscious humans of selected faction.", "What?", "") as message|null
	if(!input)
		return
	var/customname = input(usr, "Pick a title for the announcement. Confirm empty text for \"[faction] Update\" title.", "Title") as text|null
	if(isnull(customname))
		return
	if(!customname)
		customname = "[faction] Update"
	if(faction == FACTION_MARINE)
		for(var/obj/structure/machinery/computer/almayer_control/C in machines)
			if(!(C.inoperable()))
				var/obj/item/paper/P = new /obj/item/paper( C.loc )
				P.name = "'[customname].'"
				P.info = input
				P.update_icon()
				C.messagetitle.Add("[customname]")
				C.messagetext.Add(P.info)

		if(alert("Press \"Yes\" if you want to announce it to ship crew and marines. Press \"No\" to keep it only as printed report on communication console.",,"Yes","No") == "Yes")
			if(alert("Do you want PMCs (not Death Squad) to see this announcement?",,"Yes","No") == "Yes")
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction)
			else
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction, FALSE)
	else
		marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction)

	message_admins("[key_name_admin(src)] has created a [faction] command report")
	log_admin("[key_name_admin(src)] [faction] command report: [input]")

/client/proc/cmd_admin_xeno_report()
	set name = "Report: Queen Mother"
	set desc = "Basically a command announcement, but only for selected Xeno's Hive"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/hives = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		hives += list("[hive.name]" = hive.hivenumber)

	hives += list("All Hives" = "everything")
	var/hive_choice = tgui_input_list(usr, "Please choose the hive you want to see your announcement. Selecting \"All hives\" option will change title to \"Unknown Higher Force\"", "Hive Selection", hives)
	if(!hive_choice)
		return FALSE

	var/hivenumber = hives[hive_choice]


	var/input = input(usr, "This should be a message from the ruler of the Xenomorph race.", "What?", "") as message|null
	if(!input)
		return FALSE

	var/hive_prefix = ""
	if(GLOB.hive_datum[hivenumber])
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		hive_prefix = "[hive.prefix] "

	if(hivenumber == "everything")
		xeno_announcement(input, hivenumber, HIGHER_FORCE_ANNOUNCE)
	else
		xeno_announcement(input, hivenumber, SPAN_ANNOUNCEMENT_HEADER_BLUE("[hive_prefix][QUEEN_MOTHER_ANNOUNCE]"))

	message_admins("[key_name_admin(src)] has created a [hive_choice] Queen Mother report")
	log_admin("[key_name_admin(src)] Queen Mother ([hive_choice]): [input]")

/client/proc/cmd_admin_create_AI_report()
	set name = "Report: ARES Comms"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is a standard message from the ship's AI. It uses Almayer General channel and won't be heard by humans without access to Almayer General channel (headset or intercom). Check with online staff before you send this. Do not use html.", "What?", "") as message|null
	if(!input)
		return FALSE

	if(!ares_can_interface())
		var/prompt = tgui_alert(src, "ARES interface processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt == "No")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's interface processor may be offline or destroyed."))
			return

	ai_announcement(input)
	message_admins("[key_name_admin(src)] has created an AI comms report")
	log_admin("AI comms report: [input]")


/client/proc/cmd_admin_create_AI_apollo_report()
	set name = "Report: ARES Apollo"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = tgui_input_text(usr, "This is a broadcast from the ship AI to Working Joes and Maintenance Drones. Do not use html.", "What?", "")
	if(!input)
		return FALSE

	var/datum/ares_link/link = GLOB.ares_link
	if(link.processor_apollo.inoperable())
		var/prompt = tgui_alert(src, "ARES APOLLO processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt != "Yes")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's APOLLO processor may be offline or destroyed."))
			return FALSE

	ares_apollo_talk(input)
	message_admins("[key_name_admin(src)] has created an AI APOLLO report")
	log_admin("AI APOLLO report: [input]")

/client/proc/cmd_admin_create_AI_shipwide_report()
	set name = "Report: ARES Shipwide"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is an announcement type message from the ship's AI. This will be announced to every conscious human on Almayer z-level. Be aware, this will work even if ARES unpowered/destroyed. Check with online staff before you send this.", "What?", "") as message|null
	if(!input)
		return FALSE
	if(!ares_can_interface())
		var/prompt = tgui_alert(src, "ARES interface processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt == "No")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's interface processor may be offline or destroyed."))
			return

	shipwide_ai_announcement(input)
	message_admins("[key_name_admin(src)] has created an AI shipwide report")
	log_admin("[key_name_admin(src)] AI shipwide report: [input]")

/client/proc/cmd_admin_create_predator_report()
	set name = "Report: Yautja AI"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is a message from the predator ship's AI. Check with online staff before you send this.", "What?", "") as message|null
	if(!input)
		return FALSE
	yautja_announcement(SPAN_YAUTJABOLDBIG(input))
	message_admins("[key_name_admin(src)] has created a predator ship AI report")
	log_admin("[key_name_admin(src)] predator ship AI report: [input]")

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set name = "Narrate to Everyone"
	set category = "Admin.Events"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/narrate_body_text
	var/narrate_header_text
	var/narrate_output

	if(tgui_alert(src, "Do you want your narration to include a header paragraph?", "Global Narrate", list("Yes", "No"), timeout = 0) == "Yes")
		narrate_header_text = tgui_input_text(src, "Please type the header paragraph below. One or two sentences or a title work best. HTML style tags are available. Paragraphs are not recommended.", "Global Narrate Header", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = FALSE, timeout = 0)
		if(!narrate_header_text)
			return
	narrate_body_text = tgui_input_text(src, "Please enter the text for your narration. Paragraphs without line breaks produce the best visual results, but HTML tags in general are respected.", "Global Narrate Text", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = FALSE, timeout = 0)
	if(!narrate_body_text)
		return

	if(!narrate_header_text)
		narrate_output = "[narrate_body("[narrate_body_text]")]"
	else
		narrate_output = "[narrate_head("[narrate_header_text]")]" + "[narrate_body("[narrate_body_text]")]"

	to_chat(world, "[narrate_output]")
	while(narrate_body_text != null)
		narrate_body_text = tgui_input_text(src, "Please enter the text for your narration. Paragraphs without line breaks produce the best visual results, but HTML tags in general are respected.", "Global Narrate Text", max_length = MAX_BOOK_MESSAGE_LEN, multiline = TRUE, encode = FALSE, timeout = 0)
		if(!narrate_body_text)
			return
		to_chat(world, narrate_body("[narrate_body_text]"))


/client/proc/cmd_admin_ground_narrate()
	set name = "Narrate to Ground Levels"
	set category = "Admin.Events"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/msg = tgui_input_text(usr, "Enter the text you wish to appear to everyone", "Message", multiline = TRUE)

	if(!msg)
		return

	var/list/all_clients = GLOB.clients.Copy()

	for(var/client/cycled_client as anything in all_clients)
		if(!(cycled_client.mob?.z in SSmapping.levels_by_trait(ZTRAIT_GROUND)))
			continue

		to_chat_spaced(cycled_client, html = SPAN_ANNOUNCEMENT_HEADER_BLUE(msg))

	message_admins("\bold GroundNarrate: [key_name_admin(usr)] : [msg]")

/client
	var/remote_control = FALSE

/client/proc/toogle_door_control()
	set name = "Toggle Remote Control"
	set category = "Admin.Events"

	if(!check_rights(R_SPAWN))
		return

	remote_control = !remote_control
	message_admins("[key_name_admin(src)] has toggled remote control [remote_control? "on" : "off"] for themselves")

/client/proc/enable_event_mob_verbs()
	set name = "Mob Event Verbs - Show"
	set category = "Admin.Events"

	add_verb(src, admin_mob_event_verbs_hideable)
	remove_verb(src, /client/proc/enable_event_mob_verbs)

/client/proc/hide_event_mob_verbs()
	set name = "Mob Event Verbs - Hide"
	set category = "Admin.Events"

	remove_verb(src, admin_mob_event_verbs_hideable)
	add_verb(src, /client/proc/enable_event_mob_verbs)

// ----------------------------
// PANELS
// ----------------------------

/datum/admins/proc/event_panel()
	if(!check_rights(R_ADMIN,0))
		return

	var/dat = {"
		<B>Ship</B><BR>
		<A href='?src=\ref[src];[HrefToken()];events=securitylevel'>Set Security Level</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=distress'>Send a Distress Beacon</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=selfdestruct'>Activate Self-Destruct</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=evacuation_start'>Trigger Evacuation</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=evacuation_cancel'>Cancel Evacuation</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=disable_shuttle_console'>Disable Shuttle Control</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=add_req_points'>Add Requisitions Points</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=check_req_heat'>Modify Requisitions Heat</A><BR>
		<BR>
		<B>Research</B><BR>
		<A href='?src=\ref[src];[HrefToken()];events=change_clearance'>Change Research Clearance</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=give_research_credits'>Give Research Credits</A><BR>
		<BR>
		<B>Power</B><BR>
		<A href='?src=\ref[src];[HrefToken()];events=unpower'>Unpower ship SMESs and APCs</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=power'>Power ship SMESs and APCs</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=quickpower'>Power ship SMESs</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=powereverything'>Power ALL SMESs and APCs everywhere</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=powershipreactors'>Power all ship reactors</A><BR>
		<BR>
		<B>Events</B><BR>
		<A href='?src=\ref[src];[HrefToken()];events=blackout'>Break all lights</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=whiteout'>Repair all lights</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=comms_blackout'>Trigger a Communication Blackout</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=destructible_terrain'>Toggle destructible terrain</A><BR>
		<BR>
		<B>Misc</B><BR>
		<A href='?src=\ref[src];[HrefToken()];events=medal'>Award a medal</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=jelly'>Award a royal jelly</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=nuke'>Spawn a nuke</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=pmcguns'>Toggle PMC gun restrictions</A><BR>
		<A href='?src=\ref[src];[HrefToken()];events=monkify'>Turn everyone into monkies</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Events Panel", "events")
	return

/client/proc/event_panel()
	set name = "Event Panel"
	set category = "Admin.Panels"
	if (admin_holder)
		admin_holder.event_panel()
	return


/datum/admins/proc/chempanel()
	if(!check_rights(R_MOD)) return

	var/dat
	if(check_rights(R_MOD,0))
		dat += {"<A href='?src=\ref[src];[HrefToken()];chem_panel=view_reagent'>View Reagent</A><br>
				"}
	if(check_rights(R_VAREDIT,0))
		dat += {"<A href='?src=\ref[src];[HrefToken()];chem_panel=view_reaction'>View Reaction</A><br>"}
		dat += {"<A href='?src=\ref[src];[HrefToken()];chem_panel=sync_filter'>Sync Reaction</A><br>
				<br>"}
	if(check_rights(R_SPAWN,0))
		dat += {"<A href='?src=\ref[src];[HrefToken()];chem_panel=spawn_reagent'>Spawn Reagent in Container</A><br>
				<A href='?src=\ref[src];[HrefToken()];chem_panel=make_report'>Make Chem Report</A><br>
				<br>"}
	if(check_rights(R_ADMIN,0))
		dat += {"<A href='?src=\ref[src];[HrefToken()];chem_panel=create_random_reagent'>Generate Reagent</A><br>
				<br>
				<A href='?src=\ref[src];[HrefToken()];chem_panel=create_custom_reagent'>Create Custom Reagent</A><br>
				<A href='?src=\ref[src];[HrefToken()];chem_panel=create_custom_reaction'>Create Custom Reaction</A><br>
				"}

	show_browser(usr, dat, "Chem Panel", "chempanel", "size=210x300")
	return

/client/proc/chem_panel()
	set name = "Chem Panel"
	set category = "Admin.Panels"
	if(admin_holder)
		admin_holder.chempanel()
	return

/datum/admins/var/create_humans_html = null
/datum/admins/proc/create_humans(mob/user)
	if(!GLOB.gear_name_presets_list)
		return

	if(!create_humans_html)
		var/equipment_presets = jointext(GLOB.gear_name_presets_list, ";")
		create_humans_html = file2text('html/create_humans.html')
		create_humans_html = replacetext(create_humans_html, "null /* object types */", "\"[equipment_presets]\"")
		create_humans_html = replacetext(create_humans_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_humans_html, "/* ref src */", "\ref[src]"), "Create Humans", "create_humans", "size=450x720")

/client/proc/create_humans()
	set name = "Create Humans"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_humans(usr)

/datum/admins/var/create_xenos_html = null
/datum/admins/proc/create_xenos(mob/user)
	if(!create_xenos_html)
		var/hive_types = jointext(ALL_XENO_HIVES, ";")
		var/xeno_types = jointext(ALL_XENO_CASTES, ";")
		create_xenos_html = file2text('html/create_xenos.html')
		create_xenos_html = replacetext(create_xenos_html, "null /* hive paths */", "\"[hive_types]\"")
		create_xenos_html = replacetext(create_xenos_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_xenos_html = replacetext(create_xenos_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_xenos_html, "/* ref src */", "\ref[src]"), "Create Xenos", "create_xenos", "size=450x800")

/client/proc/create_xenos()
	set name = "Create Xenos"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_xenos(usr)

/client/proc/clear_mutineers()
	set name = "Clear All Mutineers"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.clear_mutineers()
	return

/datum/admins/proc/clear_mutineers()
	if(!check_rights(R_MOD))
		return

	if(alert(usr, "Are you sure you want to change all mutineers back to normal?", "Confirmation", "Yes", "No") != "Yes")
		return

	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.mob_flags & MUTINEER)
			H.mob_flags &= ~MUTINEER
			H.hud_set_squad()

			for(var/datum/action/human_action/activable/mutineer/A in H.actions)
				A.remove_from(H)

/client/proc/cmd_fun_fire_ob()
	set category = "Admin.Fun"
	set desc = "Fire an OB warhead at your current location."
	set name = "Fire OB"

	if(!check_rights(R_ADMIN))
		return

	var/list/firemodes = list("Standard Warhead", "Custom HE", "Custom Cluster", "Custom Incendiary")
	var/mode = tgui_input_list(usr, "Select fire mode:", "Fire mode", firemodes)
	// Select the warhead.
	var/obj/structure/ob_ammo/warhead/warhead
	var/statsmessage
	var/custom = TRUE
	switch(mode)
		if("Standard Warhead")
			custom = FALSE
			var/list/warheads = subtypesof(/obj/structure/ob_ammo/warhead/)
			var/choice = tgui_input_list(usr, "Select the warhead:", "Warhead to use", warheads)
			warhead = new choice
		if("Custom HE")
			var/obj/structure/ob_ammo/warhead/explosive/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "HE orbital warhead")
			if(!OBShell.name) return//null check to cancel
			OBShell.clear_power = tgui_input_number(src, "How much explosive power should the wall clear blast have?", "Set clear power", 1200, 3000)
			if(isnull(OBShell.clear_power)) return
			OBShell.clear_falloff = tgui_input_number(src, "How much falloff should the wall clear blast have?", "Set clear falloff", 400)
			if(isnull(OBShell.clear_falloff)) return
			OBShell.standard_power = tgui_input_number(src, "How much explosive power should the main blasts have?", "Set blast power", 600, 3000)
			if(isnull(OBShell.standard_power)) return
			OBShell.standard_falloff = tgui_input_number(src, "How much falloff should the main blasts have?", "Set blast falloff", 30)
			if(isnull(OBShell.standard_falloff)) return
			OBShell.clear_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 3)
			if(isnull(OBShell.clear_delay)) return
			OBShell.double_explosion_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 6)
			if(isnull(OBShell.double_explosion_delay)) return
			statsmessage = "Custom HE OB ([OBShell.name]) Stats from [key_name(usr)]: Clear Power: [OBShell.clear_power], Clear Falloff: [OBShell.clear_falloff], Clear Delay: [OBShell.clear_delay], Blast Power: [OBShell.standard_power], Blast Falloff: [OBShell.standard_falloff], Blast Delay: [OBShell.double_explosion_delay]."
			warhead = OBShell
		if("Custom Cluster")
			var/obj/structure/ob_ammo/warhead/cluster/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "Cluster orbital warhead")
			if(!OBShell.name) return//null check to cancel
			OBShell.total_amount = tgui_input_number(src, "How many salvos should be fired?", "Set cluster number", 60)
			if(isnull(OBShell.total_amount)) return
			OBShell.instant_amount = tgui_input_number(src, "How many shots per salvo? (Max 10)", "Set shot count", 3)
			if(isnull(OBShell.instant_amount)) return
			if(OBShell.instant_amount > 10)
				OBShell.instant_amount = 10
			OBShell.explosion_power = tgui_input_number(src, "How much explosive power should the blasts have?", "Set blast power", 300, 1500)
			if(isnull(OBShell.explosion_power)) return
			OBShell.explosion_falloff = tgui_input_number(src, "How much falloff should the blasts have?", "Set blast falloff", 150)
			if(isnull(OBShell.explosion_falloff)) return
			statsmessage = "Custom Cluster OB ([OBShell.name]) Stats from [key_name(usr)]: Salvos: [OBShell.total_amount], Shot per Salvo: [OBShell.instant_amount], Explosion Power: [OBShell.explosion_power], Explosion Falloff: [OBShell.explosion_falloff]."
			warhead = OBShell
		if("Custom Incendiary")
			var/obj/structure/ob_ammo/warhead/incendiary/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "Incendiary orbital warhead")
			if(!OBShell.name) return//null check to cancel
			OBShell.clear_power = tgui_input_number(src, "How much explosive power should the wall clear blast have?", "Set clear power", 1200, 3000)
			if(isnull(OBShell.clear_power)) return
			OBShell.clear_falloff = tgui_input_number(src, "How much falloff should the wall clear blast have?", "Set clear falloff", 400)
			if(isnull(OBShell.clear_falloff)) return
			OBShell.clear_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 3)
			if(isnull(OBShell.clear_delay)) return
			OBShell.distance = tgui_input_number(src, "How many tiles radius should the fire be? (Max 30)", "Set fire radius", 18, 30)
			if(isnull(OBShell.distance)) return
			if(OBShell.distance > 30)
				OBShell.distance = 30
			OBShell.fire_level = tgui_input_number(src, "How long should the fire last?", "Set fire duration", 70)
			if(isnull(OBShell.fire_level)) return
			OBShell.burn_level = tgui_input_number(src, "How damaging should the fire be?", "Set fire strength", 80)
			if(isnull(OBShell.burn_level)) return
			var/list/firetypes = list("white","blue","red","green","custom")
			OBShell.fire_type = tgui_input_list(usr, "Select the fire color:", "Fire color", firetypes)
			if(isnull(OBShell.fire_type)) return
			OBShell.fire_color = null
			if(OBShell.fire_type == "custom")
				OBShell.fire_type = "dynamic"
				OBShell.fire_color = input(src, "Please select Fire color.", "Fire color") as color|null
				if(isnull(OBShell.fire_color)) return
			statsmessage = "Custom Incendiary OB ([OBShell.name]) Stats from [key_name(usr)]: Clear Power: [OBShell.clear_power], Clear Falloff: [OBShell.clear_falloff], Clear Delay: [OBShell.clear_delay], Fire Distance: [OBShell.distance], Fire Duration: [OBShell.fire_level], Fire Strength: [OBShell.burn_level]."
			warhead = OBShell

	if(custom)
		if(alert(usr, statsmessage, "Confirm Stats", "Yes", "No") != "Yes")
			qdel(warhead)
			return
		message_admins(statsmessage)

	var/turf/target = get_turf(usr.loc)

	if(alert(usr, "Fire or Spawn Warhead?", "Mode", "Fire", "Spawn") == "Fire")
		if(alert("Are you SURE you want to do this? It will create an OB explosion!",, "Yes", "No") != "Yes")
			qdel(warhead)
			return

		message_admins("[key_name(usr)] has fired \an [warhead.name] at ([target.x],[target.y],[target.z]).")
		warhead.warhead_impact(target)

	else
		warhead.forceMove(target)

/client/proc/change_taskbar_icon()
	set name = "Set Taskbar Icon"
	set desc = "Change the taskbar icon to a preset list of selectable icons."
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN))
		return

	var/taskbar_icon = tgui_input_list(usr, "Select an icon you want to appear on the player's taskbar.", "Taskbar Icon", GLOB.available_taskbar_icons)
	if(!taskbar_icon)
		return

	SSticker.mode.taskbar_icon = taskbar_icon
	SSticker.set_clients_taskbar_icon(taskbar_icon)
	message_admins("[key_name_admin(usr)] has changed the taskbar icon to [taskbar_icon].")

/client/proc/change_weather()
	set name = "Change Weather"
	set category = "Admin.Events"

	if(!check_rights(R_EVENT))
		return

	if(!SSweather.map_holder)
		to_chat(src, SPAN_WARNING("This map has no weather data."))
		return

	if(SSweather.is_weather_event_starting)
		to_chat(src, SPAN_WARNING("A weather event is already starting. Please wait."))
		return

	if(SSweather.is_weather_event)
		if(tgui_alert(src, "A weather event is already in progress! End it?", "Confirm", list("End", "Continue"), 10 SECONDS) == "Continue")
			return
		if(SSweather.is_weather_event)
			SSweather.end_weather_event()

	var/list/mappings = list()
	for(var/datum/weather_event/typepath as anything in subtypesof(/datum/weather_event))
		mappings[initial(typepath.name)] = typepath
	var/chosen_name = tgui_input_list(src, "Select a weather event to start", "Weather Selector", mappings)
	var/chosen_typepath = mappings[chosen_name]
	if(!chosen_typepath)
		return

	var/retval = SSweather.setup_weather_event(chosen_typepath)
	if(!retval)
		to_chat(src, SPAN_WARNING("Could not start the weather event at present!"))
		return
	to_chat(src, SPAN_BOLDNOTICE("Success! The weather event should start shortly."))


/client/proc/cmd_admin_create_bioscan()
	set name = "Report: Bioscan"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/choice = tgui_alert(usr, "Are you sure you want to trigger a bioscan?", "Bioscan?", list("Yes", "No"))
	if(choice != "Yes")
		return
	else
		var/faction = tgui_input_list(usr, "What faction do you wish to provide a bioscan for?", "Bioscan Faction", list("Xeno","Marine","Yautja"), 20 SECONDS)
		var/variance = tgui_input_number(usr, "How variable do you want the scan to be? (+ or - an amount from truth)", "Variance", 2, 10, 0, 20 SECONDS)
		message_admins("BIOSCAN: [key_name(usr)] admin-triggered a bioscan for [faction].")
		GLOB.bioscan_data.get_scan_data()
		switch(faction)
			if("Xeno")
				GLOB.bioscan_data.qm_bioscan(variance)
			if("Marine")
				var/force_check = tgui_alert(usr, "Do you wish to force ARES to display the bioscan?", "Display force", list("Yes", "No"), 20 SECONDS)
				var/force_status = FALSE
				if(force_check == "Yes")
					force_status = TRUE
				GLOB.bioscan_data.ares_bioscan(force_status, variance)
			if("Yautja")
				GLOB.bioscan_data.yautja_bioscan()

/client/proc/admin_blurb()
	set name = "Global Blurb Message"
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN|R_DEBUG))
		return FALSE
	var/duration = 5 SECONDS
	var/message = "ADMIN TEST"
	var/text_input = tgui_input_text(usr, "Announcement message", "Message Contents", message, timeout = 5 MINUTES)
	message = text_input
	duration = tgui_input_number(usr, "Set the duration of the alert in deci-seconds.", "Duration", 5 SECONDS, 5 MINUTES, 5 SECONDS, 20 SECONDS)
	var/confirm = tgui_alert(usr, "Are you sure you wish to send '[message]' to all players for [(duration / 10)] seconds?", "Confirm", list("Yes", "No"), 20 SECONDS)
	if(confirm != "Yes")
		return FALSE
	show_blurb(GLOB.player_list, duration, message, TRUE, "center", "center", "#bd2020", "ADMIN")
	message_admins("[key_name(usr)] sent an admin blurb alert to all players. Alert reads: '[message]' and lasts [(duration / 10)] seconds.")

/client/proc/set_narration_preset()
	set name = "Speak as NPC over comms - setup NPC"
	set category = "DM.Narration"
	if(!check_rights(R_ADMIN)) return

	var/list/comms_presets = list("Mission Control","Custom")
	switch(tgui_input_list(usr,"Select a Comms Preset","PRESET",comms_presets,timeout = 0))
		if(null)
			return
		if("Mission Control")
			usr.narration_settings["Name"] = "Mission Control"
			usr.narration_settings["Location"] = "Arrowhead Command"
			usr.narration_settings["Position"] = "SO"
		if("Custom")
			usr.narration_settings["Name"] = tgui_input_text(usr, "Enter the name, complete with a rank prefix.", "NAME entry", usr.narration_settings["Name"], timeout = 0)
			usr.narration_settings["Location"] = tgui_input_text(usr, "Enter assignment or location, when in doubt, OV-PST works.", "LOCATION entry", usr.narration_settings["Location"], timeout = 0)
			usr.narration_settings["Position"] = tgui_input_text(usr, "Enter held position like CE, CO, RFN or whatnot. Prefaced with some specialty acronym also can work.", "POSITION entry", usr.narration_settings["Position"], timeout = 0)
	return

/client/proc/speak_to_comms()
	set name = "Speak as NPC over comms"
	set category = "DM.Narration"
	if(!check_rights(R_ADMIN)) return

	if(usr.narration_settings["Name"] == null || usr.narration_settings["Location"] == null || usr.narration_settings["Position"] == null) set_narration_preset()
	var/text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")

	while(text_to_comm != null)
		to_chat(world, "<span class='big'><span class='radio'><span class='name'>[usr.narration_settings["Name"]]<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[usr.narration_settings["Location"]] \u0028[usr.narration_settings["Position"]]\u0029\u005D </b></span><span class='message'>, says \"[text_to_comm]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
		text_to_comm = tgui_input_text(usr, "Enter what to say as [usr.narration_settings["Name"]],[usr.narration_settings["Location"]],[usr.narration_settings["Position"]] or cancel to exit.")
	return

/proc/show_blurb_song(title = "Song Name",additional = "Song Artist - Song Album",)//Shows song blurb, a two line blurb. The first line passes
	var/message_to_display = "<b>[title]</b>\n[additional]"
	show_blurb(GLOB.player_list, 10 SECONDS, "[message_to_display]", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "song[title]", ignore_key = TRUE, speed = 1)

/client/proc/call_tgui_play_directly()
	set category = "DM.Music"
	set name = "Play Music From Direct Link"
	set desc = "Plays a music file from a https:// link through tguis music player, bypassing the filtering done by the other admin command. This will play as an admin atmospheric and will be muted by clinets who have that setting turned on as expected. A blurb displaying song info can also be displayed as an extra option."

	if(!check_rights(R_ADMIN))
		return

	var/targets = GLOB.mob_list
	var/list/music_extra_data = list()
	var/web_sound_url = tgui_input_text(usr, "Enter link to sound file. Must use https://","LINK to play", timeout = 0)
	music_extra_data["title"] = tgui_input_text(usr, "Enter song Title, leaving this blank/null will use its url instead.","Title input", timeout = 0)
	music_extra_data["artist"] = tgui_input_text(usr, "Enter song Artist, or leave blank to not display.", "Artist input", timeout = 0)
	music_extra_data["album"] = tgui_input_text(usr, "Enter song Album, or leave blank to not display.","Album input", timeout = 0)
	if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
	if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
	if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
	music_extra_data["link"] = "Song Link Hidden"
	music_extra_data["duration"] = "None"
	for(var/mob/mob as anything in targets)
		var/client/client = mob?.client
		if((client?.prefs?.toggles_sound & SOUND_MIDI) && (client?.prefs?.toggles_sound & SOUND_ADMIN_ATMOSPHERIC))
			if(tgui_alert(usr, "Show title blurb?", "Blurb", list("No","Yes"), timeout = 0) == "Yes") show_blurb_song(title = music_extra_data["title"], additional = "[music_extra_data["artist"]] - [music_extra_data["album"]]")
			client?.tgui_panel?.play_music(web_sound_url, music_extra_data)
		else
			client?.tgui_panel?.stop_music()

/client/proc/opener_blurb()
	show_blurb(GLOB.player_list, duration = 15 SECONDS, message = "<b>The year is 2224.</b>\n\nLocated on the edge of the <b>Neroid Sector</b>\n<b>LV-624</b> grew from an insignificant prison\nplanet with a minor corporate interest\nto an <b>important way-station</b>, with all\nthree major factions maintaining\ninstallations on the planet.\n\n<b>On February 11th, 2224</b>, an <b>unidentified\nflying object</b> enters the solar system\nand impacts the planets communications\narray.\n<b>All contact</b> with the planet and its\nsurrounding infrastructure <b>is lost.</b>",scroll_down = TRUE, screen_position = "CENTER,BOTTOM+4.5:16", text_alignment = "center", text_color = "#ffaef2", blurb_key = "introduction", ignore_key = TRUE, speed = 1)
	sleep(600)
	show_blurb(GLOB.player_list, duration = 15 SECONDS, message = "Due to the politics involved, <b>it takes\nmonths</b> to organize a rescue. Now, thanks\nto an one-of-a-kind agreement\nthe <b>1st United Expeditionary Response</b>\nconsisting of elements coming from all\nthree of the major political players\nback on Earth is finally close to\narriving in the system.\n\nYou are part of the <b>United Americas\nColonial Marines</b> element of the <b>UER</b>.\nYou have been hand picked from a narrow\nfield of qualified volunteers to take\npart in this operation and have been\nassigned to the <b>UAS Arrowhead</b>.\nYou are the first organized military\nresponse in the system since it lost\ncontact.\n\n<b>Your mission begins now.</b>",scroll_down = TRUE, screen_position = "CENTER,BOTTOM+3.5:16", text_alignment = "center", text_color = "#ffaef2", blurb_key = "introduction", ignore_key = TRUE, speed = 1)

/client/proc/npc_interaction()
	set category = "DM.Narration"
	set name = "Speak as in world NPC"
	set desc = "Speaks as NPC from spawners or otherwise with the talking_npc var turned on."

	if(!check_rights(R_ADMIN))
		return

	var/list/speaker_list = list()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.talking_npc == 1)
			speaker_list.Add(H)
	if(speaker_list.len == 0)
		to_chat(usr, SPAN_WARNING("Error: No talking NPCs available."))
		return
	var/target_mob = tgui_input_list(src, "Select a NPC to talk as:", "NPC", speaker_list, timeout = 0)
	if(target_mob == null) return
	var/mob/living/carbon/human/mob_to_talk_as = target_mob
	var/use_radio = 0
	if(tgui_alert(usr, "Broadcast over radio?", "NPC", list("No", "Yes"), timeout = 0) == "Yes") use_radio = 1
	var/speaking_mode = tgui_alert(usr, "Emote or Speak?", "NPC", list("Emote", "Speak"), timeout = 0)
	if(speaking_mode == null) return
	var/text_to_say = tgui_input_text(usr, "[speaking_mode] as [target_mob]","[uppertext(speaking_mode)]-[uppertext(target_mob)]", timeout = 0)
	while(text_to_say != null)
		switch(speaking_mode)
			if("Emote")
				INVOKE_ASYNC(mob_to_talk_as, TYPE_PROC_REF(/mob/living/carbon/human, emoteas), text_to_say, 0, use_radio)
				text_to_say = tgui_input_text(usr, "[speaking_mode] as [target_mob]","[uppertext(speaking_mode)]-[uppertext(target_mob)]",timeout = 0)
			if("Speak")
				INVOKE_ASYNC(mob_to_talk_as, TYPE_PROC_REF(/mob/living/carbon/human, talkas), text_to_say, 0, use_radio)
				text_to_say = tgui_input_text(usr, "[speaking_mode] as [target_mob]","[uppertext(speaking_mode)]-[uppertext(target_mob)]",timeout = 0)
	return

/client/proc/change_objective()
	set category = "DM.Narration"
	set name = "Objectives"
	set desc = "Speaks as NPC from spawners or otherwise with the talking_npc var turned on."

	if(!check_rights(R_ADMIN))
		return
	var/new_objective
	var/type_to_change = tgui_alert(usr, "Chnage which Objective?", "Objective", list("Primary","Secondary"), timeout = 0)
	if(type_to_change == null) return
	if(type_to_change == "Primary")
		new_objective = tgui_input_text(usr, "Enter new objective", "Objective", default = GLOB.primary_objective, timeout = 0)
	else
		new_objective = tgui_input_text(usr, "Enter new objective", "Objective", default = GLOB.secondary_objective, timeout = 0)
	if(new_objective == null) return
	switch(tgui_alert(usr, "Pick Outcome for previous objective", "Objective", list("Success", "Failure", "None"), timeout = 0))
		if(null)
			return
		if("Success")
			if(type_to_change == "Primary")
				show_blurb(GLOB.player_list, 10 SECONDS, "Primary Objective\nAccomplished!", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)
				GLOB.primary_objective = "Recieving new orders..."
			else
				show_blurb(GLOB.player_list, 10 SECONDS, "Secondary Objective\nAccomplished!", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)
				GLOB.secondary_objective = "Recieving new orders..."
			sleep(150)
		if("Failure")
			if(type_to_change == "Primary")
				show_blurb(GLOB.player_list, 10 SECONDS, "Primary Objective\nFailed!", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)
			else
				show_blurb(GLOB.player_list, 10 SECONDS, "Secondary Objective\nFailed!", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)
				GLOB.secondary_objective = "Recieving new orders..."
			sleep(150)
		if("None")
			if(type_to_change == "Primary")
				GLOB.primary_objective = "Recieving new orders..."
			else
				GLOB.secondary_objective = "Recieving new orders..."
			sleep(50)
	if(type_to_change == "Primary")
		GLOB.primary_objective = new_objective
		show_blurb(GLOB.player_list, 10 SECONDS, "New Primary Objective:\n[GLOB.primary_objective]", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)

	else
		GLOB.secondary_objective = new_objective
		show_blurb(GLOB.player_list, 10 SECONDS, "New Secondary Objective:\n[GLOB.secondary_objective]", screen_position = "LEFT+0:16,BOTTOM+1:16", text_alignment = "left", text_color = "#FFFFFF", blurb_key = "objective", ignore_key = TRUE, speed = 1)

/client/proc/enable_full_restock()
	set category = "DM.Narration"
	set name = "Enable/Disable Full Restock"
	set desc = "Makes the next ressuply drop a big one (or not)."

	if(!check_rights(R_ADMIN))
		return
	if(GLOB.ammo_restock_full == 0)
		GLOB.ammo_restock_full = 1
		to_chat(usr, SPAN_INFO("Full restock ENABLED."))
		return
	if(GLOB.ammo_restock_full == 1)
		GLOB.ammo_restock_full = 0
		to_chat(usr, SPAN_INFO("Full restock DISABLED."))
		return
