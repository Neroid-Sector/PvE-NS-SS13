GLOBAL_VAR_INIT(CutsceneUrlIntro, "none")
GLOBAL_VAR_INIT(CutsceneUrlDeployment, "none")
GLOBAL_VAR_INIT(CutsceneUrlStage1, "none")
GLOBAL_VAR_INIT(CutsceneUrlStage2, "none")
GLOBAL_VAR_INIT(CutsceneUrlStage3, "none")
GLOBAL_VAR_INIT(CutsceneUrlStage4, "none")
GLOBAL_VAR_INIT(CutsceneUrlEvac, "none")
GLOBAL_VAR_INIT(CutsceneUrlOutro, "none")

/client/proc/setup_cutscenes()
	set category = "DM.Cutscenes"
	set name = "Cutscenes - Setup Music Vars"
	set desc = "Part of round setup for DMs, sets music vars for cutscenes."

	if(!check_rights(R_ADMIN))
		return

	var/list/option_picks = list()

	if(GLOB.CutsceneUrlIntro == "none")
		option_picks.Add("Intro - EMPTY")
	else
		option_picks.Add("Intro")
	if(GLOB.CutsceneUrlDeployment == "none")
		option_picks.Add("Deployment - EMPTY")
	else
		option_picks.Add("Deployment")
	if(GLOB.CutsceneUrlStage1 == "none")
		option_picks.Add("Boss Stage 1 - EMPTY")
	else
		option_picks.Add("Boss Stage 1")
	if(GLOB.CutsceneUrlStage2 == "none")
		option_picks.Add("Boss Stage 2 - EMPTY")
	else
		option_picks.Add("Boss Stage 2")
	if(GLOB.CutsceneUrlStage3 == "none")
		option_picks.Add("Boss Stage 3 - EMPTY")
	else
		option_picks.Add("Boss Stage 3")
	if(GLOB.CutsceneUrlStage4 == "none")
		option_picks.Add("Boss Stage 4 - EMPTY")
	else
		option_picks.Add("Boss Stage 4")
	if(GLOB.CutsceneUrlEvac == "none")
		option_picks.Add("Post Evac - EMPTY")
	else
		option_picks.Add("Post Evac")
	if(GLOB.CutsceneUrlOutro == "none")
		option_picks.Add("Outro - EMPTY")
	else
		option_picks.Add("Outro")

	var/picked_option = tgui_input_list(usr, "Select an entry to edit:", "Message entry", option_picks, timeout = 0)
	if(picked_option == null) return

	var/url_to_enter
	switch(picked_option)
		if("Intro - EMPTY","Intro")
			url_to_enter = tgui_input_text(usr, "Enter Intro URL:", "Intro URL", default = GLOB.CutsceneUrlIntro, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlIntro = url_to_enter
		if("Deployment - EMPTY","Deployment")
			url_to_enter = tgui_input_text(usr, "Enter Deployment URL:", "Deployment URL", default = GLOB.CutsceneUrlDeployment, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlDeployment = url_to_enter
		if("Boss Stage 1 - EMPTY","Boss Stage 1")
			url_to_enter = tgui_input_text(usr, "Enter Boss Stage 1 URL:", "Boss Stage 1 URL", default = GLOB.CutsceneUrlStage1, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlStage1 = url_to_enter
		if("Boss Stage 2 - EMPTY","Boss Stage 2")
			url_to_enter = tgui_input_text(usr, "Enter Boss Stage 2 URL:", "Boss Stage 2 URL", default = GLOB.CutsceneUrlStage2, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlStage2 = url_to_enter
		if("Boss Stage 3 - EMPTY","Boss Stage 3")
			url_to_enter = tgui_input_text(usr, "Enter Boss Stage 3 URL:", "Boss Stage 3 URL", default = GLOB.CutsceneUrlStage3, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlStage3 = url_to_enter
		if("Boss Stage 4 - EMPTY","Boss Stage 4")
			url_to_enter = tgui_input_text(usr, "Enter Boss Stage 4 URL:", "Boss Stage 4 URL", default = GLOB.CutsceneUrlStage4, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlStage4 = url_to_enter
		if("Post Evac - EMPTY","Post Evac")
			url_to_enter = tgui_input_text(usr, "Enter Post Evac URL:", "Post Evac URL", default = GLOB.CutsceneUrlEvac, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlEvac = url_to_enter
		if("Outro - EMPTY","Outro")
			url_to_enter = tgui_input_text(usr, "Enter Outro URL:", "Outro URL", default = GLOB.CutsceneUrlOutro, timeout = 0)
			if(url_to_enter == null) return
			GLOB.CutsceneUrlOutro = url_to_enter

	to_chat(usr, SPAN_INFO("[url_to_enter] set for [picked_option]"))
	return

/datum/proc/SendMessageAsRadio(speaker_preset = 0, message = null)
	if(speaker_preset == 0 || message == null) return
	var/text_to_comm = message
	var/list/narration_setup = list("Name" = null,
		"Location" = null,
		"Position" = null,
		)
	switch(speaker_preset)
		if(1)
			narration_setup["Name"] = "LT. Ruslana 'Rusalka' Soroka"
			narration_setup["Location"] = "Arrowhead"
			narration_setup["Position"] = "MC"
		if(2)
			narration_setup["Name"] = "LT. David Grant"
			narration_setup["Location"] = "Arrowhead"
			narration_setup["Position"] = "ScO"
		if(3)
			narration_setup["Name"] = "CDR. Gabriel Powell"
			narration_setup["Location"] = "Arrowhead"
			narration_setup["Position"] = "XO"
		if(4)
			narration_setup["Name"] = "CASSANDRA"
			narration_setup["Location"] = "CORSAT"
			narration_setup["Position"] = "AI"
		if(5)
			narration_setup["Name"] = "HELM"
			narration_setup["Location"] = "ARROWHEAD"
			narration_setup["Position"] = "BRIDGE"
		if(6)
			narration_setup["Name"] = "HELM"
			narration_setup["Location"] = "AEGIS"
			narration_setup["Position"] = "BRIDGE"
		if(7)
			narration_setup["Name"] = "HELM"
			narration_setup["Location"] = "SEVASTOPOL"
			narration_setup["Position"] = "BRIDGE"
		if(8)
			narration_setup["Name"] = "COMMAND"
			narration_setup["Location"] = "PHOENIX"
			narration_setup["Position"] = "CIC"
		if(9)
			narration_setup["Name"] = "LT. Isabel 'Shrike' Vasquez"
			narration_setup["Location"] = "Arrowhead"
			narration_setup["Position"] = "PO"
		if(10)
			narration_setup["Name"] = "LT. James 'Jim' Biggs"
			narration_setup["Location"] = "Arrowhead"
			narration_setup["Position"] = "PO"

	to_chat(world, "<span class='big'><span class='radio'><span class='name'>[narration_setup["Name"]]<b>[icon2html('icons/obj/items/radio.dmi', usr, "beacon")] \u005B[narration_setup["Location"]] \u0028[narration_setup["Position"]]\u0029\u005D </b></span><span class='message'>, says \"[text_to_comm]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)

/datum/proc/SendNarrationMessage(message_type = null, message_text = null)
	if(message_type == null || message_text == null) return
	var/text_to_send = message_text
	switch(message_type)
		if(1)
			to_chat(world, narrate_head(text_to_send))
		if(2)
			to_chat(world, narrate_body(text_to_send))


/datum/proc/SendStoryBlurb(message = null, color = null, delay = null, speed = null)
	if(message == null) return
	var/blurb_text_to_send = message
	var/blurb_color
	if(color == null)
		blurb_color = "#FFFFFF"
	else
		blurb_color = color
	var/blurb_delay
	if(delay == null)
		blurb_delay = 10 SECONDS
	else
		blurb_delay = delay
	var/blurb_speed
	if(speed == null)
		blurb_speed = 1
	else
		blurb_speed = speed

	show_blurb(GLOB.player_list, duration = blurb_delay, message = blurb_text_to_send ,scroll_down = TRUE, screen_position = "CENTER,BOTTOM+3:16", text_alignment = "center", text_color = blurb_color, blurb_key = "cutscene_blurb", ignore_key = TRUE, speed = blurb_speed)

/datum/proc/PlayMusicFromPreset(preset_id)
	if(preset_id == null) return
	var/web_sound_url
	switch(preset_id)
		if(1)
			web_sound_url = GLOB.CutsceneUrlIntro
		if(2)
			web_sound_url = GLOB.CutsceneUrlDeployment
		if(3)
			web_sound_url = GLOB.CutsceneUrlStage1
		if(4)
			web_sound_url = GLOB.CutsceneUrlStage2
		if(5)
			web_sound_url = GLOB.CutsceneUrlStage3
		if(6)
			web_sound_url = GLOB.CutsceneUrlStage4
		if(7)
			web_sound_url = GLOB.CutsceneUrlEvac
		if(8)
			web_sound_url = GLOB.CutsceneUrlOutro
	if(web_sound_url == "none") return

	var/list/music_extra_data = list()
	music_extra_data["link"] = "Song Link Hidden"
	music_extra_data["duration"] = "None"
	switch(preset_id)
		if(1)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Supernatural"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Tribal Blood"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Tribal Blood"
		if(2)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(3)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(4)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(5)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(6)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(7)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"
		if(8)
			if(music_extra_data["title"] == null) music_extra_data["title"] = web_sound_url
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Unknown Artist"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Unknown Album"

	var/targets = GLOB.mob_list
	for(var/mob/mob as anything in targets)
		var/client/client = mob?.client
		if((client?.prefs?.toggles_sound & SOUND_MIDI) && (client?.prefs?.toggles_sound & SOUND_ADMIN_ATMOSPHERIC))
			client?.tgui_panel?.play_music(web_sound_url, music_extra_data)
		else
			client?.tgui_panel?.stop_music()

/datum/proc/PlayCutscene(cutscene_id = null)
	if(cutscene_id == null) return
	switch(cutscene_id)
		if(1)
			INVOKE_ASYNC(src, PROC_REF(PlayMusicFromPreset),1)
			sleep(50)
			INVOKE_ASYNC(src, PROC_REF(SendMessageAsRadio),1,"Good morning, UER Force Recon teams. Your briefing will commence in about 10 minutes on the top deck of the ship. The briefing room is located in the back.")
			INVOKE_ASYNC(src, PROC_REF(SendStoryBlurb),"December 1st, 2224\nUAS Arrowhead")
			sleep(180)
			INVOKE_ASYNC(src, PROC_REF(SendStoryBlurb),"XENOSURGE")
			sleep(100)
			INVOKE_ASYNC(src, PROC_REF(SendStoryBlurb),"Months ago, the human colony known as\n<b>LV-624</b> went dark. Due to the presence of\ncitizens from all three of the major\nEarth based superpowers, <b>a joint effort</b>\nwas established to respond to the\nemergency.")
			sleep(400)
			INVOKE_ASYNC(src, PROC_REF(SendStoryBlurb),"Now, the <b>United Expeditionary Response</b>\nis preparing for its first major\noperation - the liberation of <b>LV-624</b>\nfrom the hostile force known only as\n<b>The Surge</b>.")
			sleep(400)
			INVOKE_ASYNC(src, PROC_REF(SendStoryBlurb),"As part of this operation, Marines from\nthe <b>UER Force Recon</b> will deploy onto\nthe <b>Weyland-Yutani</b> installation known as\n<b>CORSAT</b> in order to secure the AI\ncalled <b>CASSANDRA</b> and disable the\nstation's planetary defenses.")
			return
