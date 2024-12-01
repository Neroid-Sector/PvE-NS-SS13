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
		if(11)
			narration_setup["Name"] = "ANATHEMA"
			narration_setup["Location"] = "Unknown"
			narration_setup["Position"] = "Unknown"

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
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Ware Is Caleb"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Generdyn"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Ware Is Caleb"
		if(3)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "I Will Fight"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Tribal Blood"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Tribal Blood"
		if(4)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "I Will Fight"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Tribal Blood"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Tribal Blood"
		if(5)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Contact With You"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Kota Hoshino"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Armored Core OST"
		if(6)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Contact With You"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Kota Hoshino"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Armored Core OST"
		if(7)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Thunder"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Generdyn"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Thunder"
		if(8)
			if(music_extra_data["title"] == null) music_extra_data["title"] = "Journey (Ready to Fly)"
			if(music_extra_data["artist"] == null) music_extra_data["artist"] = "Natasha Blume"
			if(music_extra_data["album"] == null) music_extra_data["album"] = "Journey (Ready to Fly)"

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
		if(2)
			INVOKE_ASYNC(src, PROC_REF(PlayMusicFromPreset),2)
			sleep(180)
			SendNarrationMessage(2,"The dropship lifts off and heads out of the hangar. The UER ships start moving into their assigned positions outside of the station. The operation begins.")
			sleep(50)
			SendMessageAsRadio(8,"UER Elements. Be advised. Operation Wayward Librarian is now underway. We are securing the anchor point off-system. Good luck and godspeed, Marines.")
			sleep(100)
			SendNarrationMessage(2,"The dropship accelerates and heads towards the station. A familiar voice speaks as you approach your destination.")
			sleep(50)
			SendMessageAsRadio(4,"You are finally here! I am ready to transfer off station, and the systems should be ready to go. Whenever you are ready, initiate the upload from any of the large domes.")
		if(3)
			INVOKE_ASYNC(src, PROC_REF(PlayMusicFromPreset),3)
			SendNarrationMessage(2,"The upload begins. Above, the Wraith moves into position to act as a relay.")
			SendMessageAsRadio(9,"This is the Wraith. Upload starting now.")
			sleep(30)
			SendMessageAsRadio(5,"Did you see that?")
			sleep(30)
			SendMessageAsRadio(6,"See What?")
			sleep(30)
			SendMessageAsRadio(5,"Out there... Sensors, now!")
			sleep(20)
			SendNarrationMessage(2,"For a moment the stars above you seem to shift, reconfigure. A glimpse of an unknown invasion fleet, in orbit of the nearby planet flashes through the domes ceiling. A blink later and the universe is back to normal… Save one of the ships that now ")
			sleep(30)
			SendMessageAsRadio(5,"What the...")
			sleep(15)
			SendNarrationMessage(2,"For a moment the stars above you seem to shift, reconfigure. A glimpse of an unknown invasion fleet, in orbit of the nearby planet flashes through the domes ceiling. A blink later and the universe is back to normal… Save one of the ships that now is right in front of the Arrowhead!")
			sleep(30)
			SendMessageAsRadio(5,"My God...")
			sleep(30)
			SendMessageAsRadio(6,"Evasive action! Now! Arrowhead, move!")
			sleep(30)
			SendNarrationMessage(2,"The Aegis moves in front of the Arrowhead as a barrage of small projectiles peppers both. The station is likewise peppered by small, metallic objects and what seems to be a bigger ship, headed directly for the dome!")
			sleep(30)
			SendMessageAsRadio(9,"This is the Wraith. Upload starting now.")
			sleep(30)
			SendMessageAsRadio(11,"Attention, strays. You are forbidden from removing any elements of the Cycle. Your punishment is death.")
