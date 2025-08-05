extends Node

func _input(event:InputEvent):
	if(event.is_action_released("refresh")):
		load_or_create_everything()

func save_everything():
	save_game_state_to_user_data()
	save_mechs_to_user_data()
	save_missions_to_user_data()
	save_parts_to_user_data()
	save_pilots_to_user_data()
	save_voicemails_to_user_data()

func load_or_create_everything():

	load_or_create_user_user_options()
	load_or_create_user_locations()
	load_or_create_user_missions()
	load_or_create_user_parts()
	load_or_create_user_mechs()
	load_or_create_user_pilots()
	load_or_create_user_voicemails()
	load_or_create_user_game_state()
	STATUS_BAR.update_status()

func load_data() -> void:
	load_or_create_everything()
	STATE.CURRENT_MISSION = LINQ.First(STATE.MISSIONS,func (mission:Mission):return mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS)
	STATE.HAS_MISSION_IN_PROGRESS = STATE.CURRENT_MISSION !=null;
	STATUS_BAR.update_status()
	await WAIT.for_seconds(1.0) #waiting for the view to resize.
	show_difficulty_select_or_main_menu()

func show_difficulty_select_or_main_menu():

	if STATE.DIFFICULTY_ALREADY_CHOSEN == true:
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
		CONVERSATION_UI.hide_ui()
		STATE.MAIN_MENU_CANVAS.show()

	elif STATE.DIFFICULTY_ALREADY_CHOSEN == false:
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
		QS.run_script_from_file("intro")
		STATE.ON_QUEST_SCRIPT_DONE = on_initial_script_done

func on_initial_script_done():
		CONVERSATION_UI.hide_ui()
		STATE.DIFFICULTY_SETTTING_MENU_CANVAS.show()



func load_or_create_user_missions():

	STATE.MISSIONS = []
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://missions.cfg")
	var resource_data_err = resource_data.load("res://data/data_missions.cfg")
	STATE.MISSIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
		for mission_index in number_of_missions:
			create_and_push_mission_to_STATE("DEFAULT",mission_index,resource_data)
		save_missions_to_user_data()
	elif(user_data_err != 7):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://missions_backup__no_version.cfg")
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
			user_data.save("user://missions_backup_%s.cfg"%user_version)
			var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE_try_from_user(section,mission_index,resource_data,user_data)
			save_missions_to_user_data()
		elif(user_version>STATE.MISSIONS_VERSION):
			var number_of_missions:int = resource_data.get_value("DEFAULT","NUMBER_OF_MISSIONS")
			user_data.save("user://missions_backup_%s.cfg"%user_version)
			for mission_index in number_of_missions:
				create_and_push_mission_to_STATE("DEFAULT",mission_index,resource_data)

func create_and_push_mission_to_STATE(section,mission_index,user_data):
			var mission = Mission.new();
			#todo - add checks to this- so the game doesn't crash if the user messes something up.

			mission.ID = user_data.get_value(section,"MISSION_%s_ID"%mission_index)
			mission.name = user_data.get_value(section,"MISSION_%s_NAME"%mission_index)
			mission.flavor = user_data.get_value(section,"MISSION_%s_FLAVOR"%mission_index)
			mission.flavor_icon = user_data.get_value(section,"MISSION_%s_FLAVOR_ICON"%mission_index)
			mission.one_over_odds_for_mission = user_data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)
			mission.one_over_odds_for_returning= user_data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)

			mission.allowed_mech_types = user_data.get_value(section,"MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)

			mission.location_id = user_data.get_value(section,"MISSION_%s_LOCATION_ID"%mission_index)
			mission.start_script = user_data.get_value(section,"MISSION_%s_START_SCRIPT"%mission_index)
			mission.success_script = user_data.get_value(section,"MISSION_%s_SUCCESS_SCRIPT"%mission_index)
			mission.fail_script = user_data.get_value(section,"MISSION_%s_FAIL_SCRIPT"%mission_index)
			mission.status = user_data.get_value(section,"MISSION_%s_STATUS"%mission_index)
			mission.time_started = int(user_data.get_value(section,"MISSION_%s_TIME_STARTED"%mission_index))
#
#MISSION_0_ID=0
#MISSION_0_NAME="MISSION-000"
#MISSION_0_FLAVOR="Help Jack find Jill"
#MISSION_0_FLAVOR_ICON=0
#MISSION_0_ONE_OVER_ODDS_FOR_MISSION=1
#MISSION_0_ONE_OVER_ODDS_FOR_RETURNING=1
#MISSION_0_ALLOWED_MECH_TYPES=Array[int]([0, 1, 2])
#MISSION_0_LOCATION_ID=0
#MISSION_0_STATUS=1
#MISSION_0_TIME_STARTED=""



			STATE.MISSIONS.push_back(mission);

func create_and_push_mission_to_STATE_try_from_user(section,mission_index,data,user_data:ConfigFile):
			var mission = Mission.new();

			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			mission.ID = data.get_value("DEFAULT","MISSION_%s_ID"%mission_index)
			mission.name = data.get_value("DEFAULT","MISSION_%s_NAME"%mission_index)
			mission.flavor = data.get_value("DEFAULT","MISSION_%s_FLAVOR"%mission_index)
			mission.flavor_icon = data.get_value("DEFAULT","MISSION_%s_FLAVOR_ICON"%mission_index)
			mission.one_over_odds_for_mission = data.get_value("DEFAULT","MISSION_%s_ONE_OVER_ODDS_FOR_MISSION"%mission_index)
			mission.one_over_odds_for_returning= user_data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_FOR_RETURNING"%mission_index)
			mission.allowed_mech_types = data.get_value("DEFAULT","MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)
			mission.location_id = user_data.get_value(section,"MISSION_%s_LOCATION_ID"%mission_index)

			mission.start_script = user_data.get_value(section,"MISSION_%s_START_SCRIPT"%mission_index)
			mission.success_script = user_data.get_value(section,"MISSION_%s_SUCCESS_SCRIPT"%mission_index)
			mission.fail_script = user_data.get_value(section,"MISSION_%s_FAIL_SCRIPT"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_STATUS"%mission_index)):
				mission.status = user_data.get_value(section,"MISSION_%s_STATUS"%mission_index)
			else:
				mission.status = data.get_value("DEFAULT","MISSION_%s_STATUS"%mission_index)

			if(user_data.has_section_key(section,"MISSION_%s_TIME_STARTED"%mission_index)):
				mission.time_started = int(user_data.get_value(section,"MISSION_%s_TIME_STARTED"%mission_index))
			else:
				mission.time_started = int(data.get_value("DEFAULT","MISSION_%s_TIME_STARTED"%mission_index))
			STATE.MISSIONS.push_back(mission);

func save_missions_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.MISSIONS_VERSION)
	user_data.set_value(section,"NUMBER_OF_MISSIONS",STATE.MISSIONS.size())
	for mission:Mission in STATE.MISSIONS:
		user_data.set_value(section,"MISSION_%s_ID"%index,mission.ID)
		user_data.set_value(section,"MISSION_%s_NAME"%index,mission.name)
		user_data.set_value(section,"MISSION_%s_FLAVOR"%index,mission.flavor)
		user_data.set_value(section,"MISSION_%s_FLAVOR_ICON"%index,mission.flavor_icon)

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
	var err = user_data.save("user://missions.cfg")
	if err != OK:
		print(err)

func load_or_create_user_parts():
	STATE.PARTS=[]
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://parts.cfg")
	var resource_data_err = resource_data.load("res://data/data_parts.cfg")
	STATE.PARTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
		for part_index in number_of_parts:
			create_and_push_part_to_STATE("DEFAULT",part_index,resource_data)
		save_parts_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://parts_backup__no_version.cfg")
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
			user_data.save("user://parts_backup_%s.cfg"%user_version)
			var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
			for part_index in number_of_parts:
				create_and_push_part_to_STATE_try_from_user(section,part_index,resource_data,user_data)
			save_parts_to_user_data()
		elif(user_version>STATE.PARTS_VERSION):
			var number_of_parts:int = resource_data.get_value("DEFAULT","NUMBER_OF_PARTS")
			user_data.save("user://parts_backup_%s.cfg"%user_version)
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
			part.ID = "%s"%data.get_value("DEFAULT","PART_%s_ID"%part_index)
			part.name = data.get_value("DEFAULT","PART_%s_NAME"%part_index)
			part.flavor = data.get_value("DEFAULT","PART_%s_FLAVOR"%part_index)
			part.cost = data.get_value("DEFAULT","PART_%s_COST"%part_index)
			part.theme = data.get_value("DEFAULT","PART_%s_THEME"%part_index)
			part.recycle_points = data.get_value("DEFAULT","PART_%s_RECYCLE_POINTS"%part_index)
			part.selling_price = data.get_value("DEFAULT","PART_%s_SELLING_PRICE"%part_index)
			part.mission_odds = data.get_value("DEFAULT","PART_%s_MISSION_ODDS"%part_index)
			part.criteria_for_mission_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_MISSION_ODDS"%part_index)
			part.returning_odds = data.get_value("DEFAULT","PART_%s_RETURNING_ODDS"%part_index)
			part.criteria_for_returning_odds = data.get_value("DEFAULT","PART_%s_CRITERIA_FOR_RETURNING_ODDS"%part_index)
			part.type = data.get_value("DEFAULT","PART_%s_TYPE"%part_index)

			if(user_data.has_section_key(section,"PART_%s_STATUS"%part_index)):
				part.status = user_data.get_value(section,"PART_%s_STATUS"%part_index)
			else:
				data.get_value("DEFAULT","PART_%s_STATUS"%part_index)

			if(user_data.has_section_key(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)):
				part.attached_to_mech_id = user_data.get_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)
			else:
				data.get_value("DEFAULT","PART_%s_ATTACHED_TO_MECH_ID"%part_index)

			STATE.PARTS.push_back(part);

func save_parts_to_user_data():

	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
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
	var err = user_data.save("user://parts.cfg")
	if err != OK:
		print(err)

func load_or_create_user_pilots():
	STATE.PILOTS=[]
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://pilots.cfg")
	var resource_data_err = resource_data.load("res://data/data_pilots.cfg")
	STATE.PILOTS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
		for pilot_index in number_of_pilots:
			create_and_push_pilot_to_STATE("DEFAULT",pilot_index,resource_data)
		save_pilots_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://pilots_backup__no_version.cfg")
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
			user_data.save("user://pilots_backup_%s.cfg"%user_version)
			var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
			for pilot_index in number_of_pilots:
				create_and_push_pilot_to_STATE_try_from_user(section,pilot_index,resource_data,user_data)
			save_pilots_to_user_data()
		elif(user_version>STATE.PILOTS_VERSION):
			var number_of_pilots:int = resource_data.get_value("DEFAULT","NUMBER_OF_PILOTS")
			user_data.save("user://pilots_backup_%s.cfg"%user_version)
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
			pilot.ID = data.get_value("DEFAULT","PILOT_%s_ID"%pilot_index)
			pilot.name = data.get_value("DEFAULT","PILOT_%s_NAME"%pilot_index)
			pilot.cost = data.get_value("DEFAULT","PILOT_%s_COST"%pilot_index)
			pilot.flavor = data.get_value("DEFAULT","PILOT_%s_FLAVOR"%pilot_index)
			pilot.theme = data.get_value("DEFAULT","PILOT_%s_THEME"%pilot_index)
			pilot.mission_odds = data.get_value("DEFAULT","PILOT_%s_MISSION_ODDS"%pilot_index)
			pilot.criteria_for_mission_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_MISSION_ODDS"%pilot_index)
			pilot.returning_odds = data.get_value("DEFAULT","PILOT_%s_RETURNING_ODDS"%pilot_index)
			pilot.criteria_for_returning_odds = data.get_value("DEFAULT","PILOT_%s_CRITERIA_FOR_RETURNING_ODDS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_STATUS"%pilot_index)):
				pilot.status = user_data.get_value(section,"PILOT_%s_STATUS"%pilot_index)
			else:
				pilot.status = data.get_value(section,"PILOT_%s_STATUS"%pilot_index)

			if(user_data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)):
				pilot.mech_id = user_data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)
			else:
				pilot.mech_id = data.get_value(section,"PILOT_%s_MECH_ID"%pilot_index)


			STATE.PILOTS.push_back(pilot);

func save_pilots_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
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
	var err = user_data.save("user://pilots.cfg")
	if err != OK:
		print(err)

func load_or_create_user_locations():

	STATE.LOCATIONS = []
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://locations.cfg")
	var resource_data_err = resource_data.load("res://data/data_locations.cfg")
	STATE.LOCATIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7):
		var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
		for location_index in number_of_locations:
			create_and_push_location_to_STATE("DEFAULT",location_index,resource_data)
		save_locations_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://locations_backup__no_version.cfg")
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE(section,location_index,resource_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.LOCATIONS_VERSION):
			var number_of_locations:int = user_data.get_value(section,"NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE(section,location_index,user_data)
		elif(user_version<STATE.LOCATIONS_VERSION):
			user_data.save("user://locations_backup_%s.cfg"%user_version)
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			for location_index in number_of_locations:
				create_and_push_location_to_STATE(section,location_index,resource_data)
			save_locations_to_user_data()
		elif(user_version>STATE.LOCATIONS_VERSION):
			var number_of_locations:int = resource_data.get_value("DEFAULT","NUMBER_OF_LOCATIONS")
			user_data.save("user://locations_backup_%s.cfg"%user_version)
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
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
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
	var err = user_data.save("user://locations.cfg")
	if err != OK:
		print(err)

func load_or_create_user_mechs():
	STATE.MECHS = []
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://mechs.cfg")
	var resource_data_err = resource_data.load("res://data/data_mechs.cfg")
	STATE.MECHS_VERSION= resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7):
		var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
		for mech_index in number_of_mechs:
			create_and_push_mech_to_STATE("DEFAULT",mech_index,resource_data)
		save_mechs_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://mechs_backup__no_version.cfg")
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
			user_data.save("user://mechs_backup_%s.cfg"%user_version)
			var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
			for mech_index in number_of_mechs:
				create_and_push_mech_to_STATE_try_from_user(section,mech_index,resource_data,user_data)
			save_mechs_to_user_data()
		elif(user_version>STATE.MECHS_VERSION):
			var number_of_mechs:int = resource_data.get_value("DEFAULT","NUMBER_OF_MECHS")
			user_data.save("user://mechs_backup_%s.cfg"%user_version)
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
			mech.ID = data.get_value("DEFAULT","MECH_%s_ID"%mech_index)
			mech.name = data.get_value("DEFAULT","MECH_%s_NAME"%mech_index)
			mech.flavor = data.get_value("DEFAULT","MECH_%s_FLAVOR"%mech_index)
			mech.cost = data.get_value("DEFAULT","MECH_%s_COST"%mech_index)
			mech.selling_price = user_data.get_value(section,"MECH_%s_SELLING_PRICE"%mech_index)
			mech.theme = data.get_value("DEFAULT","MECH_%s_THEME"%mech_index)
			mech.base_health = data.get_value("DEFAULT","MECH_%s_BASE_HEALTH"%mech_index)
			mech.mission_id = data.get_value("DEFAULT","MECH_%s_MISSION_ID"%mech_index)
			mech.compatible_environments = data.get_value("DEFAULT","MECH_%s_COMPATIBLE_ENVIRONMENTS"%mech_index)
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

func save_mechs_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
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
	var err = user_data.save("user://mechs.cfg")
	if err != OK:
		print(err)

func load_or_create_user_user_options():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://user_options.cfg")
	var resource_data_err = resource_data.load("res://data/data_user_options.cfg")
	STATE.USER_OPTIONS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		create_and_push_user_option_to_STATE("DEFAULT",resource_data)
		save_user_options_to_user_data()
	elif(user_data_err != 7 ):

		if(user_data.has_section_key(section,"VERSION")==false):
			create_and_push_user_option_to_STATE("DEFAULT",resource_data)
			return
		var user_version:float = user_data.get_value(section,"VERSION")

		if(user_version==STATE.USER_OPTIONS_VERSION):
			create_and_push_user_option_to_STATE(section,user_data)
		else:
			create_and_push_user_option_to_STATE("DEFAULT",resource_data)
			save_user_options_to_user_data()

func create_and_push_user_option_to_STATE(section,data):
			STATE.SFX_VOLUME = data.get_value(section,"SFX_VOLUME")
			STATE.MUSIC_VOLUME  = data.get_value(section,"MUSIC_VOLUME")

func save_user_options_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var index = 0;
	user_data.set_value(section,"VERSION",STATE.USER_OPTIONS_VERSION)
	user_data.set_value(section,"SFX_VOLUME",STATE.SFX_VOLUME )
	user_data.set_value(section,"MUSIC_VOLUME",STATE.MUSIC_VOLUME )
	var err = user_data.save("user://user_options.cfg")
	if err != OK:
		print(err)

func load_or_create_user_game_state():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://game_state.cfg")
	var resource_data_err = resource_data.load("res://data/data_game_state.cfg")
	STATE.GAME_STATE_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		create_and_push_game_state_data_to_STATE("DEFAULT",resource_data)
		save_game_state_to_user_data()
	elif(user_data_err != 7 ):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://game_state_backup__no_version.cfg")
			create_and_push_game_state_data_to_STATE_try_from_user(section,resource_data,user_data)
			return

		var user_version:float = user_data.get_value(section,"VERSION")
		if(user_version==STATE.GAME_STATE_VERSION):
			create_and_push_game_state_data_to_STATE(section,user_data)
		elif(user_version<STATE.GAME_STATE_VERSION):
			user_data.save("user://game_state_backup_%s.cfg"%user_version)
			create_and_push_game_state_data_to_STATE_try_from_user(section,resource_data,user_data)
			save_game_state_to_user_data()
		elif(user_version>STATE.GAME_STATE_VERSION):
			user_data.save("user://game_state_backup_%s.cfg"%user_version)
			create_and_push_game_state_data_to_STATE("DEFAULT",resource_data)

func create_and_push_game_state_data_to_STATE(section,user_data):

			#todo - add checks to this- so the game doesn't crash if the user messes something up.
			STATE.USE_REAL_TIME = user_data.get_value(section,"USE_REAL_TIME")
			STATE.CREDITS = user_data.get_value(section,"CREDITS")
			STATE.RECYCLE_POINTS= user_data.get_value(section,"RECYCLE_POINTS")
			STATE.DIFFICULTY_ALREADY_CHOSEN  = user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")

func create_and_push_game_state_data_to_STATE_try_from_user(section,data,user_data:ConfigFile):

			#todo - add checks to this- so the game doesn't crash if the user messes something up.

			if(user_data.get_value(section,"USE_REAL_TIME")):
				STATE.USE_REAL_TIME= user_data.get_value(section,"USE_REAL_TIME")
			else:
				STATE.USE_REAL_TIME= data.get_value(section,"USE_REAL_TIME")

			if(user_data.get_value(section,"CREDITS")):
				STATE.CREDITS= user_data.get_value(section,"CREDITS")
			else:
				STATE.CREDITS = data.get_value(section,"CREDITS")

			if(user_data.get_value(section,"RECYCLE_POINTS")):
				STATE.RECYCLE_POINTS = user_data.get_value(section,"RECYCLE_POINTS")
			else:
				STATE.RECYCLE_POINTS = data.get_value(section,"RECYCLE_POINTS")

			if(user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")):
				STATE.DIFFICULTY_ALREADY_CHOSEN = user_data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")
			else:
				STATE.DIFFICULTY_ALREADY_CHOSEN = data.get_value(section,"DIFFICULTY_ALREADY_CHOSEN")

			STATE.CREDITS
func save_game_state_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()

	user_data.set_value(section,"VERSION",STATE.GAME_STATE_VERSION)

	user_data.set_value(section,"CREDITS",STATE.CREDITS)
	user_data.set_value(section,"RECYCLE_POINTS",STATE.RECYCLE_POINTS)
	user_data.set_value(section,"USE_REAL_TIME",STATE.USE_REAL_TIME)
	user_data.set_value(section,"DIFFICULTY_ALREADY_CHOSEN",STATE.DIFFICULTY_ALREADY_CHOSEN)

	var err = user_data.save("user://game_state.cfg")
	if err != OK:
		print(err)


func load_or_create_user_voicemails():
	STATE.VOICEMAILS
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var user_data = ConfigFile.new()
	var resource_data = ConfigFile.new()
	var user_data_err = user_data.load("user://voicemails.cfg")
	var resource_data_err = resource_data.load("res://data/data_voicemails.cfg")
	STATE.VOICEMAILS_VERSION = resource_data.get_value("DEFAULT","VERSION")
	if(user_data_err == 7 ):
		var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
		for voicemail_index in number_of_voicemails:
			create_and_push_voicemail_to_STATE("DEFAULT",voicemail_index,resource_data)
		save_voicemails_to_user_data()
	elif(user_data_err != 7):
		if(user_data.has_section_key(section,"VERSION")==false):
			user_data.save("user://voicemails_backup__no_version.cfg")
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
			user_data.save("user://voicemails_backup_%s.cfg"%user_version)
			var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
			for voicemail_index in number_of_voicemails:
				create_and_push_voicemail_to_STATE_try_from_user(section,voicemail_index,resource_data,user_data)
			save_voicemails_to_user_data()
		elif(user_version>STATE.VOICEMAILS_VERSION):
			var number_of_voicemails:int = resource_data.get_value("DEFAULT","NUMBER_OF_VOICEMAILS")
			user_data.save("user://voicemails_backup_%s.cfg"%user_version)
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
			voicemail.ID = data.get_value("DEFAULT","VOICEMAIL_%s_ID"%voicemail_index)
			voicemail.name = data.get_value("DEFAULT","VOICEMAIL_%s_NAME"%voicemail_index)


			voicemail.voicemail_script = user_data.get_value(section,"VOICEMAIL_%s_SCRIPT"%voicemail_index)
			voicemail.callback_script = user_data.get_value(section,"VOICEMAIL_%s_CALLBACK"%voicemail_index)

			if(user_data.has_section_key(section,"VOICEMAIL_%s_STATUS"%voicemail_index)):
				voicemail.status = user_data.get_value(section,"VOICEMAIL_%s_STATUS"%voicemail_index)
			else:
				voicemail.status = data.get_value("DEFAULT","VOICEMAIL_%s_STATUS"%voicemail_index)


			STATE.VOICEMAILS.push_back(voicemail);

func save_voicemails_to_user_data():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
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
	var err = user_data.save("user://voicemails.cfg")
	if err != OK:
		print(err)
