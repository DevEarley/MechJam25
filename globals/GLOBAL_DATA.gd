extends Node

func _input(event:InputEvent):
	if(event.is_action_released("refresh")):
		load_or_create_everything()

func load_data() -> void:
	await load_or_create_user_user_options()
	update_ui_after_USER_OPTIONS_are_loaded();
	STATE.MAIN_MENU_CANVAS.show();

func save_everything(bypass_autosave_settings_and_save_anyways=false):
	await save_game_state_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_mechs_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_missions_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_parts_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_pilots_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_voicemails_to_user_data(bypass_autosave_settings_and_save_anyways)
	await save_user_options_to_user_data(bypass_autosave_settings_and_save_anyways)

func load_or_create_everything():
	await load_or_create_user_user_options()
	update_ui_after_USER_OPTIONS_are_loaded();
	load_or_create_user_locations()
	load_or_create_user_missions()
	load_or_create_user_parts()
	load_or_create_user_mechs()
	load_or_create_user_pilots()
	STATE.PILOTS.sort_custom(func(pilot:Pilot,pilot_b:Pilot):return pilot.ID<pilot_b.ID)

	load_or_create_user_voicemails()
	load_or_create_user_game_state()
	STATUS_BAR.update_status()

func soft_reset_data():
	reset_missions();
	reset_pilots()
	reset_parts()
	reset_mechs()
	reset_voicemails()
	STATE.BENEFACTOR_IS_GIVING_YOU_MONEY = true
	STATE.DT_ROSE_IS_GIVING_YOU_MONEY = false
	STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL = false
	STATE.CREDITS = 0
	STATE.RECYCLE_POINTS = 0
	STATUS_BAR.update_status()
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	QS.run_script_from_file(preload("res://quest_scripts/intro.qs.tres"))
	STATE.ON_QUEST_SCRIPT_DONE = on_initial_script_done

func hard_reset_data():
	reset_mission_data();
	reset_pilot_data()

	STATE.PILOTS.sort_custom(func(pilot:Pilot,pilot_b:Pilot):return pilot.ID<pilot_b.ID)
	reset_part_data()
	reset_location_data()
	reset_mech_data()
	reset_voicemail_data()
	STATE.BENEFACTOR_IS_GIVING_YOU_MONEY = true
	STATE.DT_ROSE_IS_GIVING_YOU_MONEY = false
	STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL = false
	STATE.CREDITS = 0
	STATE.RECYCLE_POINTS = 0

	save_everything(true);
	STATUS_BAR.update_status()
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	QS.run_script_from_file(preload("res://quest_scripts/intro.qs.tres"))
	STATE.ON_QUEST_SCRIPT_DONE = on_initial_script_done


func reset_missions():
	for mission:Mission in STATE.MISSIONS:
		mission.status = ENUMS.MISSION_STATUS.LOCKED;
		mission.time_started = 0

func reset_parts():
	for part:Part in STATE.PARTS:
		part.attached_to_mech_id = -1;
		part.status = ENUMS.PART_STATUS.FOR_SALE

func reset_voicemails():
	for voicemail:Voicemail in STATE.VOICEMAILS:
		voicemail.status = ENUMS.VOICEMAIL_STATUS.LOCKED
	STATE.VOICEMAILS[0].status = ENUMS.VOICEMAIL_STATUS.UNHEARD

func reset_pilots():
	for pilot:Pilot in STATE.PILOTS:
		pilot.mech_id = -1;
		pilot.status = ENUMS.PILOT_STATUS.NOT_AVAILABLE_YET

func reset_mechs():
	for mech:Mech in STATE.MECHS:
		mech.mission_id = -1;
		mech.status = ENUMS.MECH_STATUS.FOR_SALE

func reset_mission_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_MISSIONS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.MISSIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
	STATE.MISSIONS = []
	for mission_index in number_of_missions:
		create_and_push_mission_to_STATE("DEFAULT",mission_index,resource_data)

func reset_location_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_LOCATIONS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.LOCATIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
	STATE.LOCATIONS = []
	for location_index in number_of_locations:
		create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)

func reset_part_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_PARTS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.PARTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
	STATE.PARTS = []
	for part_index in number_of_parts:
		create_and_push_part_to_STATE("DEFAULT",part_index,resource_data)

func reset_voicemail_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_VOICEMAILS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.VOICEMAILS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
	STATE.VOICEMAILS = []
	for voicemail_index in number_of_voicemails:
		create_and_push_voicemail_to_STATE("DEFAULT",voicemail_index,resource_data)


func reset_pilot_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_PILOTS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.PILOTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
	STATE.PILOTS = []
	for pilot_index in number_of_pilots:
		create_and_push_pilot_to_STATE("DEFAULT",pilot_index,resource_data)



func reset_mech_data():
	var resource_data:ConfigFile = ConfigFile.new()
	var static_data = preload("res://data/DATA_MECHS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.MECHS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
	STATE.MECHS = []
	for mech_index in number_of_mechs:
		create_and_push_mech_to_STATE("DEFAULT",mech_index,resource_data)



func show_difficulty_select_or_main_menu():
	STATE.CURRENT_MISSION = LINQ.First(STATE.MISSIONS,func (mission:Mission):return mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS)
	STATE.HAS_MISSION_IN_PROGRESS = STATE.CURRENT_MISSION !=null;
	STATUS_BAR.update_status()
	STATE.MAIN_MENU_CANVAS.hide()

	if STATE.DIFFICULTY_ALREADY_CHOSEN == true:
		MUSIC.play_music_for_start_menu()
		SFX.play_click_sound()
		STATUS_BAR.update_status()
		MAP.ANIMATOR.play("idle")
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
		CONVERSATION_UI.hide_ui()
		START_MENU.show_start_menu()

	elif STATE.DIFFICULTY_ALREADY_CHOSEN == false:
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
		QS.run_script_from_file(preload("res://quest_scripts/intro.qs.tres"))
		STATE.ON_QUEST_SCRIPT_DONE = on_initial_script_done

func on_initial_script_done():
		CONVERSATION_UI.hide_ui()
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.show()

func load_or_create_user_missions():
	STATE.MISSIONS = []
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data:ConfigFile = ConfigFile.new()
	var user_data_err = user_data.load("user://missions.cfg")
	var static_data = preload("res://data/DATA_MISSIONS.tres").CONFIG_FILE
	var resource_data_error = resource_data.parse(static_data)
	STATE.MISSIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
		for mission_index in number_of_missions:
			create_and_push_mission_to_STATE("DEFAULT",mission_index,resource_data)
		save_missions_to_user_data()
	elif(user_data_err != 7):
		if(user_data.has_section_key(section,"VERSION")==false):
			print("creating backup of mission data")
			await user_data.save("user://missions_backup__no_version.cfg")
			var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE_try_from_user(section,mission_index,resource_data,user_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.MISSIONS_VERSION):
			var number_of_missions:int = user_data.get_value(section,"NUMBER_OF_MISSIONS")
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE(section,mission_index,user_data)
		elif(user_version<STATE.MISSIONS_VERSION):
			print("creating backup of mission data")
			await user_data.save("user://missions_backup_%s.cfg"%user_version)
			var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE_try_from_user(section,mission_index,resource_data,user_data)
			save_missions_to_user_data()
		elif(user_version>STATE.MISSIONS_VERSION):
			print("creating backup of mission data")
			var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
			await user_data.save("user://missions_backup_%s.cfg"%user_version)
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE("DEFAULT",mission_index,resource_data)

func create_and_push_mission_to_STATE(section,mission_index,user_data):
			var mission = Mission.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			mission.ID = user_data.get_value(section,"MISSION_%s_ID"%mission_index)
			mission.name = user_data.get_value(section,"MISSION_%s_NAME"%mission_index)
			mission.flavor = user_data.get_value(section,"MISSION_%s_FLAVOR"%mission_index)
			mission.type = user_data.get_value(section,"MISSION_%s_TYPE"%mission_index)
			mission.one_over_odds_for_mission = user_data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)
			mission.one_over_odds_for_returning= user_data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)
			mission.allowed_mech_types = user_data.get_value(section,"MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)
			mission.location_id = user_data.get_value(section,"MISSION_%s_LOCATION_ID"%mission_index)
			mission.start_script = user_data.get_value(section,"MISSION_%s_START_SCRIPT"%mission_index)
			mission.success_script = user_data.get_value(section,"MISSION_%s_SUCCESS_SCRIPT"%mission_index)
			mission.fail_script = user_data.get_value(section,"MISSION_%s_FAIL_SCRIPT"%mission_index)
			mission.status = user_data.get_value(section,"MISSION_%s_STATUS"%mission_index)
			mission.time_started = int(user_data.get_value(section,"MISSION_%s_TIME_STARTED"%mission_index))

			STATE.MISSIONS.push_back(mission);

func create_and_push_mission_to_STATE_try_from_user(section,mission_index,data,user_data:ConfigFile):
			var mission = Mission.new();

			if(user_data.has_section_key(section,"MISSION_%s_ID"%mission_index)):
				mission.ID = data.get_value("DEFAULT","MISSION_%s_ID"%mission_index)
			else:
				mission.ID = data.get_value("DEFAULT","MISSION_%s_ID"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_NAME"%mission_index)):
				mission.name = data.get_value("DEFAULT","MISSION_%s_NAME"%mission_index)
			else:
				mission.name = data.get_value("DEFAULT","MISSION_%s_NAME"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_FLAVOR"%mission_index)):
				mission.flavor = data.get_value("DEFAULT","MISSION_%s_FLAVOR"%mission_index)
			else:
				mission.flavor = data.get_value("DEFAULT","MISSION_%s_FLAVOR"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_TYPE"%mission_index)):
				mission.type = data.get_value("DEFAULT","MISSION_%s_TYPE"%mission_index)
			else:
				mission.type = data.get_value("DEFAULT","MISSION_%s_TYPE"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)):
				mission.one_over_odds_for_mission = data.get_value("DEFAULT","MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)
			else:
				mission.one_over_odds_for_mission = data.get_value("DEFAULT","MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)):
				mission.one_over_odds_for_returning= data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)
			else:
				mission.one_over_odds_for_returning = data.get_value("DEFAULT","MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)):
				mission.allowed_mech_types = data.get_value("DEFAULT","MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)
			else:
				mission.allowed_mech_types = data.get_value("DEFAULT","MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_LOCATION_ID"%mission_index)):
				mission.location_id = data.get_value(section,"MISSION_%s_LOCATION_ID"%mission_index)
			else:
				mission.location_id = data.get_value("DEFAULT","MISSION_%s_LOCATION_ID"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_START_SCRIPT"%mission_index)):
				mission.start_script = data.get_value(section,"MISSION_%s_START_SCRIPT"%mission_index)
			else:
				mission.start_script = data.get_value("DEFAULT","MISSION_%s_START_SCRIPT"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_SUCCESS_SCRIPT"%mission_index)):
				mission.success_script = data.get_value(section,"MISSION_%s_SUCCESS_SCRIPT"%mission_index)
			else:
				mission.success_script = data.get_value("DEFAULT","MISSION_%s_SUCCESS_SCRIPT"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_FAIL_SCRIPT"%mission_index)):
				mission.fail_script = data.get_value(section,"MISSION_%s_FAIL_SCRIPT"%mission_index)
			else:
				mission.fail_script = data.get_value("DEFAULT","MISSION_%s_FAIL_SCRIPT"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_STATUS"%mission_index)):
				mission.status = user_data.get_value(section,"MISSION_%s_STATUS"%mission_index)
			else:
				mission.status = data.get_value("DEFAULT","MISSION_%s_STATUS"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_TIME_STARTED"%mission_index)):
				mission.time_started = int(user_data.get_value(section,"MISSION_%s_TIME_STARTED"%mission_index))
			else:
				mission.time_started = int(data.get_value("DEFAULT","MISSION_%s_TIME_STARTED"%mission_index))
			STATE.MISSIONS.push_back(mission);

func save_missions_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return

	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.MISSIONS_VERSION)
	user_data.set_value(section,"NUMBER_OF_MISSIONS",STATE.MISSIONS.size())
	for mission:Mission in STATE.MISSIONS:
		user_data.set_value(section,"MISSION_%s_ID"%index,mission.ID)
		user_data.set_value(section,"MISSION_%s_NAME"%index,mission.name)
		user_data.set_value(section,"MISSION_%s_FLAVOR"%index,mission.flavor)
		user_data.set_value(section,"MISSION_%s_TYPE"%index,mission.type)
		user_data.set_value(section,"MISSION_%s_ALLOWED_MECH_TYPES"%index,mission.allowed_mech_types)
		user_data.set_value(section,"MISSION_%s_LOCATION_ID"%index,mission.location_id)
		user_data.set_value(section,"MISSION_%s_STATUS"%index,mission.status)
		user_data.set_value(section,"MISSION_%s_TIME_STARTED"%index,"%s"%mission.time_started)
		user_data.set_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%index,mission.one_over_odds_for_mission)
		user_data.set_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%index,mission.one_over_odds_for_returning)
		user_data.set_value(section,"MISSION_%s_SUCCESS_SCRIPT"%index,mission.success_script)
		user_data.set_value(section,"MISSION_%s_START_SCRIPT"%index,mission.start_script)
		user_data.set_value(section,"MISSION_%s_FAIL_SCRIPT"%index,mission.fail_script)

		index+=1;
	var err = await user_data.save("user://missions.cfg")
	if err != OK:
		print(err)

func load_or_create_user_parts():
	STATE.PARTS=[]
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://parts.cfg")
	#var resource_data_err = resource_data.load("res://data/data_parts.cfg")
	var static_data = preload("res://data/DATA_PARTS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)


	STATE.PARTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
		for part_index in number_of_parts:
			create_and_push_part_to_STATE("DEFAULT",part_index,resource_data)
		save_parts_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			print("creating backup of part data")
			await user_data.save("user://parts_backup__no_version.cfg")
			var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
			for part_index in number_of_parts:
				create_and_push_part_to_STATE_try_from_user(section,part_index,resource_data,user_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.PARTS_VERSION):
			var number_of_parts:int = user_data.get_value(section,"NUMBER_OF_PARTS")
			for part_index in number_of_parts:
				create_and_push_part_to_STATE(section,part_index,user_data)
		elif(user_version<STATE.PARTS_VERSION):
			print("creating backup of part data")
			await user_data.save("user://parts_backup_%s.cfg"%user_version)
			var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
			for part_index in number_of_parts:
				create_and_push_part_to_STATE_try_from_user(section,part_index,resource_data,user_data)
			save_parts_to_user_data()
		elif(user_version>STATE.PARTS_VERSION):
			print("creating backup of part data")
			var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
			await user_data.save("user://parts_backup_%s.cfg"%user_version)
			for part_index in number_of_parts:
				create_and_push_part_to_STATE("DEFAULT",part_index,resource_data)

func create_and_push_part_to_STATE(section,part_index,user_data):
			var part = Part.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			part.ID = "%s"%user_data.get_value(section,"PART_%s_ID"%part_index)
			part.name = user_data.get_value(section,"PART_%s_NAME"%part_index)
			part.flavor = user_data.get_value(section,"PART_%s_FLAVOR"%part_index)
			part.cost = user_data.get_value(section,"PART_%s_COST"%part_index)
			part.theme = user_data.get_value(section,"PART_%s_THEME"%part_index)
			part.recycle_points = user_data.get_value(section,"PART_%s_RECYCLE_POINTS"%part_index)
			part.selling_price = user_data.get_value(section,"PART_%s_SELLING_PRICE"%part_index)
			part.mission_odds = user_data.get_value(section,"PART_%s_MISSION_ODDS"%part_index)
			part.criteria_for_mission_odds = user_data.get_value(section,"PART_%s_CRITERIA_FOR_MISSION_ODDS"%part_index)
			part.returning_odds = user_data.get_value(section,"PART_%s_RETURNING_ODDS"%part_index)
			part.criteria_for_returning_odds = user_data.get_value(section,"PART_%s_CRITERIA_FOR_RETURNING_ODDS"%part_index)
			part.type = user_data.get_value(section,"PART_%s_TYPE"%part_index)
			part.status = user_data.get_value(section,"PART_%s_STATUS"%part_index)
			part.attached_to_mech_id = user_data.get_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)
			STATE.PARTS.push_back(part);

func create_and_push_part_to_STATE_try_from_user(section,part_index,data,user_data:ConfigFile):
			var part = Part.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			if(user_data.has_section_key(section,"PART_%s_ID"%part_index)):
				part.ID = "%s"%data.get_value("DEFAULT","PART_%s_ID"%part_index)
			else:
				part.ID =data.get_value("DEFAULT","PART_%s_ID"%part_index)

			if(user_data.has_section_key(section,"PART_%s_NAME"%part_index)):
				part.name = data.get_value("DEFAULT","PART_%s_NAME"%part_index)
			else:
				part.name = data.get_value("DEFAULT","PART_%s_NAME"%part_index)

			if(user_data.has_section_key(section,"PART_%s_FLAVOR"%part_index)):
				part.flavor = data.get_value("DEFAULT","PART_%s_FLAVOR"%part_index)
			else:
				part.flavor =data.get_value("DEFAULT","PART_%s_FLAVOR"%part_index)

			if(user_data.has_section_key(section,"PART_%s_COST"%part_index)):
				part.cost = data.get_value("DEFAULT","PART_%s_COST"%part_index)
			else:
				part.cost = data.get_value("DEFAULT","PART_%s_COST"%part_index)

			if(user_data.has_section_key(section,"PART_%s_THEME"%part_index)):
				part.theme = data.get_value("DEFAULT","PART_%s_THEME"%part_index)
			else:
				part.theme = data.get_value("DEFAULT","PART_%s_THEME"%part_index)

			if(user_data.has_section_key(section,"PART_%s_RECYCLE_POINTS"%part_index)):
				part.recycle_points = data.get_value("DEFAULT","PART_%s_RECYCLE_POINTS"%part_index)
			else:
				part.recycle_points =data.get_value("DEFAULT","PART_%s_RECYCLE_POINTS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_SELLING_PRICE"%part_index)):
				part.selling_price = data.get_value("DEFAULT","PART_%s_SELLING_PRICE"%part_index)
			else:
				part.selling_price = data.get_value("DEFAULT","PART_%s_SELLING_PRICE"%part_index)

			if(user_data.has_section_key(section,"PART_%s_MISSION_ODDS"%part_index)):
				part.mission_odds = data.get_value("DEFAULT","PART_%s_MISSION_ODDS"%part_index)
			else:
				part.mission_odds =data.get_value("DEFAULT","PART_%s_MISSION_ODDS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_CRITERIA_FOR_MISSION_ODDS"%part_index)):
				part.criteria_for_mission_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_MISSION_ODDS"%part_index)
			else:
				part.criteria_for_mission_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_MISSION_ODDS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_RETURNING_ODDS"%part_index)):
				part.returning_odds = data.get_value("DEFAULT","PART_%s_RETURNING_ODDS"%part_index)
			else:
				part.returning_odds = data.get_value("DEFAULT","PART_%s_RETURNING_ODDS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_CRITERIA_FOR_RETURNING_ODDS"%part_index)):
				part.criteria_for_returning_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_RETURNING_ODDS"%part_index)
			else:
				part.criteria_for_returning_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_RETURNING_ODDS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_TYPE"%part_index)):
				part.type = data.get_value("DEFAULT","PART_%s_TYPE"%part_index)
			else:
				part.type = data.get_value("DEFAULT","PART_%s_TYPE"%part_index)

			if(user_data.has_section_key(section,"PART_%s_STATUS"%part_index)):
				part.status = user_data.get_value(section,"PART_%s_STATUS"%part_index)
			else:
				part.status = data.get_value("DEFAULT","PART_%s_STATUS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)):
				part.attached_to_mech_id = user_data.get_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)
			else:
				part.attached_to_mech_id = data.get_value("DEFAULT","PART_%s_ATTACHED_TO_MECH_ID"%part_index)

			STATE.PARTS.push_back(part);

func save_parts_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return

	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.PARTS_VERSION)
	user_data.set_value(section,"NUMBER_OF_PARTS",STATE.PARTS.size())
	for part:Part in STATE.PARTS:
		user_data.set_value(section,"PART_%s_ID"%index,part.ID)
		user_data.set_value(section,"PART_%s_NAME"%index,part.name)
		user_data.set_value(section,"PART_%s_FLAVOR"%index,part.flavor)
		user_data.set_value(section,"PART_%s_COST"%index,part.cost)
		user_data.set_value(section,"PART_%s_THEME"%index,part.theme)
		user_data.set_value(section,"PART_%s_RECYCLE_POINTS"%index,part.recycle_points)
		user_data.set_value(section,"PART_%s_SELLING_PRICE"%index,part.selling_price)
		user_data.set_value(section,"PART_%s_MISSION_ODDS"%index,part.mission_odds)
		user_data.set_value(section,"PART_%s_CRITERIA_FOR_MISSION_ODDS"%index,part.criteria_for_mission_odds)
		user_data.set_value(section,"PART_%s_RETURNING_ODDS"%index,part.returning_odds)
		user_data.set_value(section,"PART_%s_CRITERIA_FOR_RETURNING_ODDS"%index,part.criteria_for_returning_odds)
		user_data.set_value(section,"PART_%s_TYPE"%index,part.type)

		user_data.set_value(section,"PART_%s_STATUS"%index,part.status)
		user_data.set_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%index,part.attached_to_mech_id)
		index+=1;
	var err = await user_data.save("user://parts.cfg")
	if err != OK:
		print(err)

func load_or_create_user_pilots():
	STATE.PILOTS=[]
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://pilots.cfg")
	#var resource_data_err = resource_data.load("res://data/data_pilots.cfg")

	var static_data = preload("res://data/DATA_PILOTS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.PILOTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
		for pilot_index in number_of_pilots:
			create_and_push_pilot_to_STATE("DEFAULT",pilot_index,resource_data)
		save_pilots_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			await user_data.save("user://pilots_backup__no_version.cfg")
			var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
			for pilot_index in number_of_pilots:
				create_and_push_pilot_to_STATE_try_from_user(section,pilot_index,resource_data,user_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.PILOTS_VERSION):
			var number_of_pilots:int = user_data.get_value(section,"NUMBER_OF_PILOTS")
			for pilot_index in number_of_pilots:
				create_and_push_pilot_to_STATE(section,pilot_index,user_data)
		elif(user_version<STATE.PILOTS_VERSION):
			await user_data.save("user://pilots_backup_%s.cfg"%user_version)
			var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
			for pilot_index in number_of_pilots:
				create_and_push_pilot_to_STATE_try_from_user(section,pilot_index,resource_data,user_data)
			save_pilots_to_user_data()
		elif(user_version>STATE.PILOTS_VERSION):
			var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
			await user_data.save("user://pilots_backup_%s.cfg"%user_version)
			for pilot_index in number_of_pilots:
				create_and_push_pilot_to_STATE("DEFAULT",pilot_index,resource_data)

func create_and_push_pilot_to_STATE(section,pilot_index,user_data):
			var pilot = Pilot.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			pilot.ID = user_data.get_value(section,"PILOT_%s_ID"%pilot_index)
			pilot.mech_id = user_data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)
			pilot.name = user_data.get_value(section,"PILOT_%s_NAME"%pilot_index)
			pilot.cost = user_data.get_value(section,"PILOT_%s_COST"%pilot_index)
			pilot.flavor = user_data.get_value(section,"PILOT_%s_FLAVOR"%pilot_index)
			pilot.theme = user_data.get_value(section,"PILOT_%s_THEME"%pilot_index)
			pilot.status = user_data.get_value(section,"PILOT_%s_STATUS"%pilot_index)
			pilot.mission_odds = user_data.get_value(section,"PILOT_%s_MISSION_ODDS"%pilot_index)
			pilot.criteria_for_mission_odds = user_data.get_value(section,"PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%pilot_index)
			pilot.returning_odds = user_data.get_value(section,"PILOT_%s_RETURNING_ODDS"%pilot_index)
			pilot.criteria_for_returning_odds = user_data.get_value(section,"PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%pilot_index)
			STATE.PILOTS.push_back(pilot);

func create_and_push_pilot_to_STATE_try_from_user(section,pilot_index,data,user_data:ConfigFile):
			var pilot = Pilot.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			if(user_data.get_value(section,"PILOT_%s_ID"%pilot_index)):
				pilot.ID = data.get_value("DEFAULT","PILOT_%s_ID"%pilot_index)
			else:
				pilot.ID = data.get_value("DEFAULT","PILOT_%s_ID"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_NAME"%pilot_index)):
				pilot.name = data.get_value("DEFAULT","PILOT_%s_NAME"%pilot_index)
			else:
				pilot.name = data.get_value("DEFAULT","PILOT_%s_NAME"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_COST"%pilot_index)):
				pilot.cost = data.get_value("DEFAULT","PILOT_%s_COST"%pilot_index)
			else:
				pilot.cost = data.get_value("DEFAULT","PILOT_%s_COST"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_FLAVOR"%pilot_index)):
				pilot.flavor = data.get_value("DEFAULT","PILOT_%s_FLAVOR"%pilot_index)
			else:
				pilot.flavor = data.get_value("DEFAULT","PILOT_%s_FLAVOR"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_THEME"%pilot_index)):
				pilot.theme = data.get_value("DEFAULT","PILOT_%s_THEME"%pilot_index)
			else:
				pilot.theme = data.get_value("DEFAULT","PILOT_%s_THEME"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_MISSION_ODDS"%pilot_index)):
				pilot.mission_odds = data.get_value("DEFAULT","PILOT_%s_MISSION_ODDS"%pilot_index)
			else:
				pilot.mission_odds = data.get_value("DEFAULT","PILOT_%s_MISSION_ODDS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%pilot_index)):
				pilot.criteria_for_mission_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%pilot_index)
			else:
				pilot.criteria_for_mission_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_RETURNING_ODDS"%pilot_index)):
				pilot.returning_odds = data.get_value("DEFAULT","PILOT_%s_RETURNING_ODDS"%pilot_index)
			else:
				pilot.returning_odds = data.get_value("DEFAULT","PILOT_%s_RETURNING_ODDS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%pilot_index)):
				pilot.criteria_for_returning_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%pilot_index)
			else:
				pilot.criteria_for_returning_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_STATUS"%pilot_index)):
				pilot.status = user_data.get_value(section,"PILOT_%s_STATUS"%pilot_index)
			else:
				pilot.status = data.get_value("DEFAULT","PILOT_%s_STATUS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)):
				pilot.mech_id = user_data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)
			else:
				pilot.mech_id = data.get_value("DEFAULT","PILOT_%s_MECH_ID"%pilot_index)


			STATE.PILOTS.push_back(pilot);

func save_pilots_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.PILOTS_VERSION)
	user_data.set_value(section,"NUMBER_OF_PILOTS",STATE.PILOTS.size())
	for pilot:Pilot in STATE.PILOTS:
		user_data.set_value(section,"PILOT_%s_ID"%index,pilot.ID)
		user_data.set_value(section,"PILOT_%s_MECH_ID"%index,pilot.mech_id)
		user_data.set_value(section,"PILOT_%s_NAME"%index,pilot.name)
		user_data.set_value(section,"PILOT_%s_COST"%index,pilot.cost)
		user_data.set_value(section,"PILOT_%s_FLAVOR"%index,pilot.flavor)
		user_data.set_value(section,"PILOT_%s_THEME"%index,pilot.theme)
		user_data.set_value(section,"PILOT_%s_STATUS"%index,pilot.status)
		user_data.set_value(section,"PILOT_%s_MISSION_ODDS"%index,pilot.mission_odds)
		user_data.set_value(section,"PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%index,pilot.criteria_for_mission_odds)
		user_data.set_value(section,"PILOT_%s_RETURNING_ODDS"%index,pilot.returning_odds)
		user_data.set_value(section,"PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%index,pilot.criteria_for_returning_odds)

		index+=1;
	var err = await user_data.save("user://pilots.cfg")
	if err != OK:
		print(err)

func load_or_create_user_locations():

	STATE.LOCATIONS = []
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://locations.cfg")
	#var resource_data_err = resource_data.load("res://data/data_locations.cfg")

	var static_data = preload("res://data/DATA_LOCATIONS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.LOCATIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0):
		var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
		for location_index in number_of_locations:
			create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)
		save_locations_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			print("creating backup of location data")
			await user_data.save("user://locations_backup__no_version.cfg")
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.LOCATIONS_VERSION):
			var number_of_locations:int = user_data.get_value(section,"NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE(section,location_index,user_data)
		elif(user_version<STATE.LOCATIONS_VERSION):
			await user_data.save("user://locations_backup_%s.cfg"%user_version)
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)
			save_locations_to_user_data()
		elif(user_version>STATE.LOCATIONS_VERSION):
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			await user_data.save("user://locations_backup_%s.cfg"%user_version)
			for location_index in number_of_locations:
				create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)

func create_and_push_location_to_STATE(section,location_index,user_data):
			var location = Location.new();
			location.ID = user_data.get_value(section,"LOCATION_%s_ID"%location_index)
			location.flavor = user_data.get_value(section,"LOCATION_%s_FLAVOR"%location_index)
			location.name = user_data.get_value(section,"LOCATION_%s_NAME"%location_index)
			location.environment = user_data.get_value(section,"LOCATION_%s_ENVIRONMENT"%location_index)
			location.map_position = user_data.get_value(section,"LOCATION_%s_POSITION"%location_index)
			STATE.LOCATIONS.push_back(location);

func save_locations_to_user_data():
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.LOCATIONS_VERSION)
	user_data.set_value(section,"NUMBER_OF_LOCATIONS",STATE.LOCATIONS.size())
	for location:Location in STATE.LOCATIONS:
		user_data.set_value(section,"LOCATION_%s_ID"%index,location.ID)
		user_data.set_value(section,"LOCATION_%s_FLAVOR"%index,location.flavor)
		user_data.set_value(section,"LOCATION_%s_NAME"%index,location.name)
		user_data.set_value(section,"LOCATION_%s_ENVIRONMENT"%index,location.environment)
		user_data.set_value(section,"LOCATION_%s_POSITION"%index,location.map_position)

		index+=1;
	var err = await user_data.save("user://locations.cfg")
	if err != OK:
		print(err)

func load_or_create_user_mechs():
	STATE.MECHS = []
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://mechs.cfg")
	#var resource_data_err = resource_data.load("res://data/data_mechs.cfg")


	var static_data = preload("res://data/DATA_MECHS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.MECHS_VERSION= resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0):
		var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
		for mech_index in number_of_mechs:
			create_and_push_mech_to_STATE("DEFAULT",mech_index,resource_data)
		save_mechs_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			print("creating backup of mech data")
			await user_data.save("user://mechs_backup__no_version.cfg")
			var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
			for mech_index in number_of_mechs:
				create_and_push_mech_to_STATE_try_from_user(section,mech_index,resource_data,user_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.MECHS_VERSION):
			var number_of_mechs:int = user_data.get_value(section,"NUMBER_OF_MECHS")
			for mech_index in number_of_mechs:
				create_and_push_mech_to_STATE(section,mech_index,user_data)
		elif(user_version<STATE.MECHS_VERSION):
			print("creating backup of mech data")
			await user_data.save("user://mechs_backup_%s.cfg"%user_version)
			var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
			for mech_index in number_of_mechs:
				create_and_push_mech_to_STATE_try_from_user(section,mech_index,resource_data,user_data)
			save_mechs_to_user_data()
		elif(user_version>STATE.MECHS_VERSION):
			var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
			await user_data.save("user://mechs_backup_%s.cfg"%user_version)
			for mech_index in number_of_mechs:
				create_and_push_mech_to_STATE("DEFAULT",mech_index,resource_data)

func create_and_push_mech_to_STATE(section,mech_index,user_data):
			var mech = Mech.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			mech.ID = user_data.get_value(section,"MECH_%s_ID"%mech_index)
			mech.name = user_data.get_value(section,"MECH_%s_NAME"%mech_index)
			mech.flavor = user_data.get_value(section,"MECH_%s_FLAVOR"%mech_index)
			mech.cost = user_data.get_value(section,"MECH_%s_COST"%mech_index)
			mech.selling_price = user_data.get_value(section,"MECH_%s_SELLING_PRICE"%mech_index)
			mech.theme = user_data.get_value(section,"MECH_%s_THEME"%mech_index)
			mech.base_health = user_data.get_value(section,"MECH_%s_BASE_HEALTH"%mech_index)
			mech.mission_id = user_data.get_value(section,"MECH_%s_MISSION_ID"%mech_index)
			mech.compatible_environments = user_data.get_value(section,"MECH_%s_COMPATIBLE_ENVIRONMENTS"%mech_index)
			mech.type = user_data.get_value(section,"MECH_%s_TYPE"%mech_index)
			mech.status = user_data.get_value(section,"MECH_%s_STATUS"%mech_index)
			mech.current_health = user_data.get_value(section,"MECH_%s_CURRENT_HEALTH"%mech_index)
			STATE.MECHS.push_back(mech);

func create_and_push_mech_to_STATE_try_from_user(section,mech_index,data,user_data:ConfigFile):
			var mech = Mech.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			if(user_data.has_section_key(section,"MECH_%s_ID"%mech_index)):
				mech.ID = data.get_value("DEFAULT","MECH_%s_ID"%mech_index)
			else:
				mech.ID = data.get_value("DEFAULT","MECH_%s_ID"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_NAME"%mech_index)):
				mech.name = data.get_value("DEFAULT","MECH_%s_NAME"%mech_index)
			else:
				mech.name = data.get_value("DEFAULT","MECH_%s_NAME"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_FLAVOR"%mech_index)):
				mech.flavor = data.get_value("DEFAULT","MECH_%s_FLAVOR"%mech_index)
			else:
				mech.flavor = data.get_value("DEFAULT","MECH_%s_FLAVOR"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_COST"%mech_index)):
				mech.cost = data.get_value("DEFAULT","MECH_%s_COST"%mech_index)
			else:
				mech.cost = data.get_value("DEFAULT","MECH_%s_COST"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_SELLING_PRICE"%mech_index)):
				mech.selling_price = user_data.get_value(section,"MECH_%s_SELLING_PRICE"%mech_index)
			else:
				mech.selling_price = data.get_value("DEFAULT","MECH_%s_SELLING_PRICE"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_THEME"%mech_index)):
				mech.theme = data.get_value("DEFAULT","MECH_%s_THEME"%mech_index)
			else:
				mech.theme = data.get_value("DEFAULT","MECH_%s_THEME"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_BASE_HEALTH"%mech_index)):
				mech.base_health = data.get_value("DEFAULT","MECH_%s_BASE_HEALTH"%mech_index)
			else:
				mech.base_health = data.get_value("DEFAULT","MECH_%s_BASE_HEALTH"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_MISSION_ID"%mech_index)):
				mech.mission_id = data.get_value("DEFAULT","MECH_%s_MISSION_ID"%mech_index)
			else:
				mech.mission_id = data.get_value("DEFAULT","MECH_%s_MISSION_ID"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_COMPATIBLE_ENVIRONMENTS"%mech_index)):
				mech.compatible_environments = data.get_value("DEFAULT","MECH_%s_COMPATIBLE_ENVIRONMENTS"%mech_index)
			else:
				mech.compatible_environments = data.get_value("DEFAULT","MECH_%s_COMPATIBLE_ENVIRONMENTS"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_TYPE"%mech_index)):
				mech.type = data.get_value("DEFAULT","MECH_%s_TYPE"%mech_index)
			else:
				mech.type = data.get_value("DEFAULT","MECH_%s_TYPE"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_STATUS"%mech_index)):
				mech.status = user_data.get_value(section,"MECH_%s_STATUS"%mech_index)
			else:
				mech.status = data.get_value("DEFAULT","MECH_%s_STATUS"%mech_index)

			if(user_data.has_section_key(section,"MECH_%s_CURRENT_HEALTH"%mech_index)):
				mech.current_health = user_data.get_value(section,"MECH_%s_CURRENT_HEALTH"%mech_index)
			else:
				mech.current_health = data.get_value("DEFAULT","MECH_%s_CURRENT_HEALTH"%mech_index)

			STATE.MECHS.push_back(mech);

func save_mechs_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.MECHS_VERSION)
	user_data.set_value(section,"NUMBER_OF_MECHS",STATE.MECHS.size())
	for mech:Mech in STATE.MECHS:
		user_data.set_value(section,"MECH_%s_ID"%index,mech.ID)
		user_data.set_value(section,"MECH_%s_NAME"%index,mech.name)
		user_data.set_value(section,"MECH_%s_THEME"%index,mech.theme)
		user_data.set_value(section,"MECH_%s_COST"%index,mech.cost)
		user_data.set_value(section,"MECH_%s_SELLING_PRICE"%index,mech.selling_price)
		user_data.set_value(section,"MECH_%s_BASE_HEALTH"%index,mech.base_health)
		user_data.set_value(section,"MECH_%s_CURRENT_HEALTH"%index,mech.current_health)
		user_data.set_value(section,"MECH_%s_MISSION_ID"%index,mech.mission_id)
		user_data.set_value(section,"MECH_%s_FLAVOR"%index,mech.flavor)
		user_data.set_value(section,"MECH_%s_STATUS"%index,mech.status)
		user_data.set_value(section,"MECH_%s_COMPATIBLE_ENVIRONMENTS"%index,mech.compatible_environments)
		user_data.set_value(section,"MECH_%s_TYPE"%index,mech.type)

		index+=1;
	var err = await user_data.save("user://mechs.cfg")
	if err != OK:
		print(err)

func load_or_create_user_user_options():

	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://user_options.cfg")
	var static_data = preload("res://data/DATA_USER_OPTIONS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.USER_OPTIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		await create_and_push_user_option_to_STATE("DEFAULT",resource_data)
		await save_user_options_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key("DEFAULT","VERSION")==false):
			await create_and_push_user_option_to_STATE("DEFAULT",resource_data)
			return
		var user_version:float = user_data.get_value("DEFAULT","VERSION")
		if(user_version==STATE.USER_OPTIONS_VERSION):
			await create_and_push_user_option_to_STATE("DEFAULT",user_data)
		else:
			await create_and_push_user_option_to_STATE("DEFAULT",resource_data)
			await save_user_options_to_user_data()


func update_ui_after_USER_OPTIONS_are_loaded():
	var options:OptionsMenu = STATE.OPTIONS_MENU_CANVAS.get_node("options_menu_buttons")
	var options_start:OptionsStartMenu = STATE.OPTIONS_START_MENU_CANVAS.get_node("Control/ScrollContainer/VBoxContainer/options_menu_buttons")
	options.on_music_slider_changed(STATE.MUSIC_VOLUME)
	options.on_SFX_slider_changed(STATE.SFX_VOLUME)
	options_start.on_music_slider_changed(STATE.MUSIC_VOLUME)
	options_start.on_SFX_slider_changed(STATE.SFX_VOLUME)
	var music_slider:HSlider = options.get_node("MUSIC_SLIDER")
	var sfx_slider:HSlider = options.get_node("SFX_SLIDER")
	music_slider.value = STATE.MUSIC_VOLUME
	sfx_slider.value = STATE.SFX_VOLUME
	var music_slider_start:HSlider = options_start.get_node("MUSIC_SLIDER")
	var sfx_slider_start:HSlider = options_start.get_node("SFX_SLIDER")
	music_slider_start.value = STATE.MUSIC_VOLUME
	sfx_slider_start.value = STATE.SFX_VOLUME
	var file_1_button = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/START1")
	var file_2_button = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/START2")
	var file_3_button = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/START3")
	var file_1_label = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/FILE_1_LAST_PLAYED")
	var file_2_label = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/FILE_2_LAST_PLAYED")
	var file_3_label = STATE.MAIN_MENU_CANVAS.get_node("Main_Menu_Buttons/FILE_3_LAST_PLAYED")
	if(STATE.SAVE_SLOT_1_IS_FRESH == true):
		file_1_label.text =  "LAST PLAYED: --/--/--"
		file_1_button.text = "NEW GAME"
	else:
		file_1_label.text =  "LAST PLAYED: %s"%STATE.LAST_TIME_PLAYED_SLOT_1
		file_1_button.text = "CONTINUE GAME"

	if(STATE.SAVE_SLOT_2_IS_FRESH == true):
		file_2_label.text =  "LAST PLAYED: --/--/--"
		file_2_button.text = "NEW GAME"
	else:
		file_2_label.text = "LAST PLAYED: %s"%STATE.LAST_TIME_PLAYED_SLOT_2
		file_2_button.text = "CONTINUE GAME"

	if(STATE.SAVE_SLOT_3_IS_FRESH == true):
		file_3_label.text =  "LAST PLAYED: --/--/--"
		file_3_button.text = "NEW GAME"
	else:
		file_3_label.text =  "LAST PLAYED: %s"%STATE.LAST_TIME_PLAYED_SLOT_3
		file_3_button.text = "CONTINUE GAME"

func create_and_push_user_option_to_STATE(section,data):
	STATE.SFX_VOLUME = data.get_value(section,"SFX_VOLUME")
	STATE.MUSIC_VOLUME  = data.get_value(section,"MUSIC_VOLUME")
	STATE.SAVE_SLOT_1_IS_FRESH  = data.get_value(section,"SAVE_SLOT_1_IS_FRESH")
	STATE.SAVE_SLOT_2_IS_FRESH  = data.get_value(section,"SAVE_SLOT_2_IS_FRESH")
	STATE.SAVE_SLOT_3_IS_FRESH  = data.get_value(section,"SAVE_SLOT_3_IS_FRESH")
	STATE.LAST_TIME_PLAYED_SLOT_1  = data.get_value(section,"LAST_TIME_PLAYED_SLOT_1")
	STATE.LAST_TIME_PLAYED_SLOT_2  = data.get_value(section,"LAST_TIME_PLAYED_SLOT_2")
	STATE.LAST_TIME_PLAYED_SLOT_3  = data.get_value(section,"LAST_TIME_PLAYED_SLOT_3")

func save_user_options_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return
	var section = "DEFAULT"
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.USER_OPTIONS_VERSION)
	user_data.set_value(section,"SFX_VOLUME",STATE.SFX_VOLUME )
	user_data.set_value(section,"MUSIC_VOLUME",STATE.MUSIC_VOLUME )
	user_data.set_value(section,"SAVE_SLOT_1_IS_FRESH",STATE.SAVE_SLOT_1_IS_FRESH )
	user_data.set_value(section,"SAVE_SLOT_2_IS_FRESH",STATE.SAVE_SLOT_2_IS_FRESH )
	user_data.set_value(section,"SAVE_SLOT_3_IS_FRESH",STATE.SAVE_SLOT_3_IS_FRESH )
	var date = Time.get_datetime_dict_from_system()
	var today = "%02d/%02d/%02d" % [date.get("month"),date.get("day"),date.get("year")]
	if(STATE.SAVE_SLOT=="SAVESLOT_1"):
		user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_1",today)
		if(STATE.SAVE_SLOT_2_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_2",STATE.LAST_TIME_PLAYED_SLOT_2)
		if(STATE.SAVE_SLOT_3_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_3",STATE.LAST_TIME_PLAYED_SLOT_3)
	if(STATE.SAVE_SLOT=="SAVESLOT_2"):
		if(STATE.SAVE_SLOT_1_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_1",STATE.LAST_TIME_PLAYED_SLOT_1)
		user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_2",today)
		if(STATE.SAVE_SLOT_3_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_3",STATE.LAST_TIME_PLAYED_SLOT_3)
	if(STATE.SAVE_SLOT=="SAVESLOT_3"):
		if(STATE.SAVE_SLOT_1_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_1",STATE.LAST_TIME_PLAYED_SLOT_1)
		if(STATE.SAVE_SLOT_2_IS_FRESH == false):
			user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_2",STATE.LAST_TIME_PLAYED_SLOT_2)
		user_data.set_value(section,"LAST_TIME_PLAYED_SLOT_3",today)
	var err = await user_data.save("user://user_options.cfg")
	if err != OK:
		print(err)

func load_or_create_user_game_state():
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://game_state.cfg")
	#var resource_data_err = resource_data.load("res://data/data_game_state.cfg")

	var static_data = preload("res://data/DATA_GAME_STATE.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.GAME_STATE_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		create_and_push_game_state_data_to_STATE("DEFAULT",resource_data)
		save_game_state_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):

			print("creating backup of game state data")
			await user_data.save("user://game_state_backup__no_version.cfg")
			create_and_push_game_state_data_to_STATE_try_from_user(section,resource_data,user_data)
			return

		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.GAME_STATE_VERSION):
			create_and_push_game_state_data_to_STATE(section,user_data)
		elif(user_version<STATE.GAME_STATE_VERSION):
			print("creating backup of game state data")
			await user_data.save("user://game_state_backup_%s.cfg"%user_version)
			create_and_push_game_state_data_to_STATE_try_from_user(section,resource_data,user_data)
			save_game_state_to_user_data()
		elif(user_version>STATE.GAME_STATE_VERSION):
			print("creating backup of game state data")
			await user_data.save("user://game_state_backup_%s.cfg"%user_version)
			create_and_push_game_state_data_to_STATE("DEFAULT",resource_data)

func create_and_push_game_state_data_to_STATE(section,user_data):

			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			STATE.USE_REAL_TIME = user_data.get_value(section,"USE_REAL_TIME")
			STATE.CREDITS = user_data.get_value(section,"CREDITS")
			STATE.RECYCLE_POINTS= user_data.get_value(section,"RECYCLE_POINTS")
			STATE.DIFFICULTY_ALREADY_CHOSEN  = user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")
			STATE.BENEFACTOR_IS_GIVING_YOU_MONEY  = user_data.get_value(section,"BENEFACTOR_IS_GIVING_YOU_MONEY")
			STATE.DT_ROSE_IS_GIVING_YOU_MONEY  = user_data.get_value(section,"DT_ROSE_IS_GIVING_YOU_MONEY")
			STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL  = user_data.get_value(section,"YOU_ARE_RACING_WITH_JACK_AND_JILL")
			RNG.RNG_INDEX  = user_data.get_value(section,"RNG_INDEX")

func create_and_push_game_state_data_to_STATE_try_from_user(section,data,user_data:ConfigFile):

			#todo - add checks to this- so the game doesn't crash if the user messes something up.

			if(user_data.get_value(section,"USE_REAL_TIME")):
				STATE.USE_REAL_TIME= user_data.get_value(section,"USE_REAL_TIME")
			else:
				STATE.USE_REAL_TIME= data.get_value("DEFAULT","USE_REAL_TIME")

			if(user_data.get_value(section,"CREDITS")):
				STATE.CREDITS= user_data.get_value(section,"CREDITS")
			else:
				STATE.CREDITS = data.get_value("DEFAULT","CREDITS")

			if(user_data.get_value(section,"RECYCLE_POINTS")):
				STATE.RECYCLE_POINTS = user_data.get_value(section,"RECYCLE_POINTS")
			else:
				STATE.RECYCLE_POINTS = data.get_value("DEFAULT","RECYCLE_POINTS")

			if(user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")):
				STATE.DIFFICULTY_ALREADY_CHOSEN = user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")
			else:
				STATE.DIFFICULTY_ALREADY_CHOSEN = data.get_value("DEFAULT","DIFFICULTY_ALREADY_CHOSEN")

			if(user_data.get_value(section,"BENEFACTOR_IS_GIVING_YOU_MONEY")):
				STATE.BENEFACTOR_IS_GIVING_YOU_MONEY = user_data.get_value(section,"BENEFACTOR_IS_GIVING_YOU_MONEY")
			else:
				STATE.BENEFACTOR_IS_GIVING_YOU_MONEY = data.get_value("DEFAULT","BENEFACTOR_IS_GIVING_YOU_MONEY")

			if(user_data.get_value(section,"DT_ROSE_IS_GIVING_YOU_MONEY")):
				STATE.DT_ROSE_IS_GIVING_YOU_MONEY = user_data.get_value(section,"DT_ROSE_IS_GIVING_YOU_MONEY")
			else:
				STATE.DT_ROSE_IS_GIVING_YOU_MONEY = data.get_value("DEFAULT","DT_ROSE_IS_GIVING_YOU_MONEY")

			if(user_data.get_value(section,"YOU_ARE_RACING_WITH_JACK_AND_JILL")):
				STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL = user_data.get_value(section,"YOU_ARE_RACING_WITH_JACK_AND_JILL")
			else:
				STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL = data.get_value("DEFAULT","YOU_ARE_RACING_WITH_JACK_AND_JILL")

			if(user_data.get_value(section,"RNG_INDEX")):
				RNG.RNG_INDEX = user_data.get_value(section,"RNG_INDEX")
			else:
				RNG.RNG_INDEX = data.get_value("DEFAULT","RNG_INDEX")


func save_game_state_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return

	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	user_data.set_value(section,"VERSION",STATE.GAME_STATE_VERSION)
	user_data.set_value(section,"CREDITS",STATE.CREDITS)
	user_data.set_value(section,"RECYCLE_POINTS",STATE.RECYCLE_POINTS)
	user_data.set_value(section,"USE_REAL_TIME",STATE.USE_REAL_TIME)
	user_data.set_value(section,"DIFFICULTY_ALREADY_CHOSEN",STATE.DIFFICULTY_ALREADY_CHOSEN)
	user_data.set_value(section,"BENEFACTOR_IS_GIVING_YOU_MONEY",STATE.BENEFACTOR_IS_GIVING_YOU_MONEY)
	user_data.set_value(section,"DT_ROSE_IS_GIVING_YOU_MONEY",STATE.DT_ROSE_IS_GIVING_YOU_MONEY)
	user_data.set_value(section,"YOU_ARE_RACING_WITH_JACK_AND_JILL",STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL)
	user_data.set_value(section,"RNG_INDEX",RNG.RNG_INDEX)

	var err = await user_data.save("user://game_state.cfg")
	if err != OK:
		print(err)


func load_or_create_user_voicemails():
	STATE.VOICEMAILS = []
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://voicemails.cfg")
	#var resource_data_err = resource_data.load("res://data/data_voicemails.cfg")

	var static_data = preload("res://data/DATA_VOICEMAILS.tres").CONFIG_FILE
	var resource_data_err = resource_data.parse(static_data)
	STATE.VOICEMAILS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err != 0 ):
		var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
		for voicemail_index in number_of_voicemails:
			create_and_push_voicemail_to_STATE("DEFAULT",voicemail_index,resource_data)
		save_voicemails_to_user_data()
	elif(user_data_err != 7):
		if(user_data.has_section_key(section,"VERSION")==false):
			print("creating backup of voicemail data")
			await user_data.save("user://voicemails_backup__no_version.cfg")
			var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
			for voicemail_index in number_of_voicemails:
				create_and_push_voicemail_to_STATE_try_from_user(section,voicemail_index,resource_data,user_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.VOICEMAILS_VERSION):
			var number_of_voicemails:int = user_data.get_value(section,"NUMBER_OF_VOICEMAILS")
			for voicemail_index in number_of_voicemails:
				create_and_push_voicemail_to_STATE(section,voicemail_index,user_data)
		elif(user_version<STATE.VOICEMAILS_VERSION):
			print("creating backup of voicemail data")
			await user_data.save("user://voicemails_backup_%s.cfg"%user_version)
			var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
			for voicemail_index in number_of_voicemails:
				create_and_push_voicemail_to_STATE_try_from_user(section,voicemail_index,resource_data,user_data)
			save_voicemails_to_user_data()
		elif(user_version>STATE.VOICEMAILS_VERSION):
			print("creating backup of voicemail data")
			var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
			await user_data.save("user://voicemails_backup_%s.cfg"%user_version)
			for voicemail_index in number_of_voicemails:
				create_and_push_voicemail_to_STATE("DEFAULT",voicemail_index,resource_data)

func create_and_push_voicemail_to_STATE(section,voicemail_index,user_data):
			var voicemail = Voicemail.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.

			voicemail.ID = user_data.get_value(section,"VOICEMAIL_%s_ID"%voicemail_index)
			voicemail.from = user_data.get_value(section,"VOICEMAIL_%s_FROM"%voicemail_index)
			voicemail.voicemail_script = user_data.get_value(section,"VOICEMAIL_%s_SCRIPT"%voicemail_index)
			voicemail.callback_script = user_data.get_value(section,"VOICEMAIL_%s_CALLBACK"%voicemail_index)
			voicemail.status = user_data.get_value(section,"VOICEMAIL_%s_STATUS"%voicemail_index)



			STATE.VOICEMAILS.push_back(voicemail);

func create_and_push_voicemail_to_STATE_try_from_user(section,voicemail_index,data,user_data:ConfigFile):
			var voicemail = Voicemail.new();

			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			if(user_data.has_section_key(section,"VOICEMAIL_%s_ID"%voicemail_index)):
				voicemail.ID = data.get_value("DEFAULT","VOICEMAIL_%s_ID"%voicemail_index)
			else:
				voicemail.ID = data.get_value("DEFAULT","VOICEMAIL_%s_ID"%voicemail_index)
			if(user_data.has_section_key(section,"VOICEMAIL_%s_FROM"%voicemail_index)):
				voicemail.from = data.get_value("DEFAULT","VOICEMAIL_%s_FROM"%voicemail_index)
			else:
				voicemail.from = data.get_value("DEFAULT","VOICEMAIL_%s_FROM"%voicemail_index)

			if(user_data.has_section_key(section,"VOICEMAIL_%s_SCRIPT"%voicemail_index)):
				voicemail.voicemail_script = user_data.get_value(section,"VOICEMAIL_%s_SCRIPT"%voicemail_index)
			else:
				voicemail.voicemail_script = data.get_value("DEFAULT","VOICEMAIL_%s_SCRIPT"%voicemail_index)
			if(user_data.has_section_key(section,"VOICEMAIL_%s_CALLBACK"%voicemail_index)):
				voicemail.callback_script = user_data.get_value(section,"VOICEMAIL_%s_CALLBACK"%voicemail_index)
			else:
				voicemail.callback_script = data.get_value("DEFAULT","VOICEMAIL_%s_CALLBACK"%voicemail_index)

			if(user_data.has_section_key(section,"VOICEMAIL_%s_STATUS"%voicemail_index)):
				voicemail.status = user_data.get_value(section,"VOICEMAIL_%s_STATUS"%voicemail_index)
			else:
				voicemail.status = data.get_value("DEFAULT","VOICEMAIL_%s_STATUS"%voicemail_index)


			STATE.VOICEMAILS.push_back(voicemail);

func save_voicemails_to_user_data(bypass_autosave_settings_and_save_anyways=false):
	if(	STATE.AUTOSAVE == false && bypass_autosave_settings_and_save_anyways == false):return
	var section = STATE.SAVE_SLOT
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.VOICEMAILS_VERSION)
	user_data.set_value(section,"NUMBER_OF_VOICEMAILS",STATE.VOICEMAILS.size())
	for voicemail:Voicemail in STATE.VOICEMAILS:
		user_data.set_value(section,"VOICEMAIL_%s_ID"%index,voicemail.ID)
		user_data.set_value(section,"VOICEMAIL_%s_FROM"%index,voicemail.from)
		user_data.set_value(section,"VOICEMAIL_%s_STATUS"%index,voicemail.status)
		user_data.set_value(section,"VOICEMAIL_%s_SCRIPT"%index,voicemail.voicemail_script)
		user_data.set_value(section,"VOICEMAIL_%s_CALLBACK"%index,voicemail.callback_script)

		index+=1;
	var err = await user_data.save("user://voicemails.cfg")
	if err != OK:
		print(err)
