extends Node

func _ready() -> void:
	load_or_create_user_missions()
	load_or_create_user_parts()
	load_or_create_user_pilots()

func load_or_create_user_missions():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var data_user = ConfigFile.new()
	var data_res = ConfigFile.new()
	var data_user_err = await data_user.load("user://missions.cfg")
	var data_res_err = await data_res.load("res://data/missions_data.cfg")
	if(data_user_err == 7 && data_res_err != 7):
		var number_of_missions:int = data_res.get_value("DEFAULT","NUMBER_OF_MISSIONS")
		for mission_index in number_of_missions:
			create_and_push_mission_to_STATE("DEFAULT",mission_index,data_user)
		save_missions_to_user_data(section)
	elif(data_user_err != 7 ):
		var number_of_missions:int = data_user.get_value(section,"NUMBER_OF_MISSIONS")
		for mission_index in number_of_missions:
			create_and_push_mission_to_STATE(section,mission_index,data_user)

func create_and_push_mission_to_STATE(section,mission_index,data):
			var mission = Mission.new();
			mission.ID = "%s"%data.get_value(section,"MISSION_%s_ID"%mission_index)
			mission.name = data.get_value(section,"MISSION_%s_NAME"%mission_index)
			mission.flavor = data.get_value(section,"MISSION_%s_FLAVOR"%mission_index)
			mission.flavor_icon = data.get_value(section,"MISSION_%s_FLAVOR_ICON"%mission_index)
			mission.one_over_odds_of_success = data.get_value(section,"MISSION_%s_ONE_OVER_ODDS_OF_SUCCESS"%mission_index)
			mission.environment = data.get_value(section,"MISSION_%s_ENVIRONMENT"%mission_index)
			mission.allowed_mech_types = data.get_value(section,"MISSION_%s_ALLOWED_MECH_TYPES"%mission_index)
			mission.mech_id = data.get_value(section,"MISSION_%s_MECH_ID"%mission_index)
			mission.pilot_id = data.get_value(section,"MISSION_%s_PILOT_ID"%mission_index)
			mission.location_id = data.get_value(section,"MISSION_%s_LOCATION_ID"%mission_index)
			mission.status = data.get_value(section,"MISSION_%s_STATUS"%mission_index)
			STATE.MISSIONS.push_back(mission);

func save_missions_to_user_data(section):
	var data_user = ConfigFile.new()
	var index = 0;
	data_user.set_value(section,"NUMBER_OF_MISSIONS",STATE.MISSIONS.size())
	for mission:Mission in STATE.MISSIONS:
		data_user.set_value(section,"MISSION_%s_ID"%index,mission.ID)
		data_user.set_value(section,"MISSION_%s_NAME"%index,mission.name)
		data_user.set_value(section,"MISSION_%s_FLAVOR"%index,mission.flavor)
		data_user.set_value(section,"MISSION_%s_FLAVOR_ICON"%index,mission.flavor_icon)
		data_user.set_value(section,"MISSION_%s_ENVIRONMENT"%index,mission.environment)
		data_user.set_value(section,"MISSION_%s_ALLOWED_MECH_TYPES"%index,mission.allowed_mech_types)
		data_user.set_value(section,"MISSION_%s_LOCATION_ID"%index,mission.location_id)
		data_user.set_value(section,"MISSION_%s_MECH_ID"%index,mission.mech_id)
		data_user.set_value(section,"MISSION_%s_PILOT_ID"%index,mission.pilot_id)
		data_user.set_value(section,"MISSION_%s_STATUS"%index,mission.status)


		data_user.set_value(section,"MISSION_%s_ONE_OVER_ODDS_OF_SUCCESS"%index,mission.one_over_odds_of_success)

		index+=1;
	var err = data_user.save("user://missions.cfg")
	if err != OK:
		print(err)

func load_or_create_user_parts():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var data_user = ConfigFile.new()
	var data_res = ConfigFile.new()
	var data_user_err = await data_user.load("user://parts.cfg")
	var data_res_err = await data_res.load("res://data/parts_data.cfg")
	if(data_user_err == 7 && data_res_err != 7):
		var number_of_parts:int = data_res.get_value("DEFAULT","NUMBER_OF_PARTS")
		for part_index in number_of_parts:
			create_and_push_part_to_STATE("DEFAULT",part_index,data_user)
		save_parts_to_user_data(section)
	elif(data_user_err != 7 ):
		var number_of_parts:int = data_user.get_value(section,"NUMBER_OF_PARTS")
		for part_index in number_of_parts:
			create_and_push_part_to_STATE(section,part_index,data_user)

func create_and_push_part_to_STATE(section,part_index,data):
			var part = Part.new();
			part.ID = "%s"%data.get_value(section,"PART_%s_ID"%part_index)
			part.name = data.get_value(section,"PART_%s_NAME"%part_index)
			part.flavor = data.get_value(section,"PART_%s_FLAVOR"%part_index)
			part.theme = data.get_value(section,"PART_%s_THEME"%part_index)
			part.recycle_power = data.get_value(section,"PART_%s_RECYCLE_POWER"%part_index)
			part.selling_price = data.get_value(section,"PART_%s_SELLING_PRICE"%part_index)
			part.better_odds = data.get_value(section,"PART_%s_BETTER_ODDS"%part_index)
			part.criteria_for_better_odds = data.get_value(section,"PART_%s_CIRTERIA_FOR_BETTER_ODDS"%part_index)
			part.worse_odds = data.get_value(section,"PART_%s_WORSE_ODDS"%part_index)
			part.criteria_for_worse_odds = data.get_value(section,"PART_%s_CRITERIA_FOR_WORSE_ODDS"%part_index)
			part.equipability = data.get_value(section,"PART_%s_EQUIPABILITY"%part_index)
			part.attached_to_mech_id = data.get_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%part_index)
			STATE.PARTS.push_back(part);

func save_parts_to_user_data(section):
	var data_user = ConfigFile.new()
	var index = 0;
	data_user.set_value(section,"NUMBER_OF_PARTS",STATE.PARTS.size())
	for part:Part in STATE.PARTS:
		data_user.set_value(section,"PART_%s_ID"%index,part.ID)
		data_user.set_value(section,"PART_%s_NAME"%index,part.name)
		data_user.set_value(section,"PART_%s_FLAVOR"%index,part.flavor)
		data_user.set_value(section,"PART_%s_THEME"%index,part.theme)
		data_user.set_value(section,"PART_%s_RECYCLE_POWER"%index,part.recycle_power)
		data_user.set_value(section,"PART_%s_SELLING_PRICE"%index,part.selling_price)
		data_user.set_value(section,"PART_%s_BETTER_ODDS"%index,part.better_odds)
		data_user.set_value(section,"PART_%s_CRITERIA_FOR_BETTER_ODDS"%index,part.criteria_for_better_odds)
		data_user.set_value(section,"PART_%s_WORSE_ODDS"%index,part.worse_odds)
		data_user.set_value(section,"PART_%s_CRITERIA_FOR_WORSE_ODDS"%index,part.criteria_for_worse_odds)
		data_user.set_value(section,"PART_%s_EQUIPABILITY"%index,part.equipability)
		data_user.set_value(section,"PART_%s_ATTACHED_TO_MECH_ID"%index,part.attached_to_mech_id)
		index+=1;
	var err = data_user.save("user://parts.cfg")
	if err != OK:
		print(err)
func load_or_create_user_pilots():
	var slot_index = 1
	var section = "SAVESLOT_%s"%slot_index
	var data_user = ConfigFile.new()
	var data_res = ConfigFile.new()
	var data_user_err = await data_user.load("user://pilots.cfg")
	var data_res_err = await data_res.load("res://data/pilots_data.cfg")
	if(data_user_err == 7 && data_res_err != 7):
		var number_of_pilots:int = data_res.get_value("DEFAULT","NUMBER_OF_PILOTS")
		for pilot_index in number_of_pilots:
			create_and_push_pilot_to_STATE("DEFAULT",pilot_index,data_user)
		save_pilot_user_data(section)
	elif(data_user_err != 7 ):
		var number_of_pilots:int = data_user.get_value(section,"NUMBER_OF_PILOTS")
		for pilot_index in number_of_pilots:
			create_and_push_pilot_to_STATE(section,pilot_index,data_user)

func create_and_push_pilot_to_STATE(section,pilot_index,data):
			var pilot = Pilot.new();
			pilot.ID = "%s"%data.get_value(section,"PILOT_%s_ID"%pilot_index)
			pilot.name = data.get_value(section,"PILOT_%s_NAME"%pilot_index)
			pilot.cost = data.get_value(section,"PILOT_%s_COST"%pilot_index)
			pilot.flavor = data.get_value(section,"PILOT_%s_FLAVOR"%pilot_index)
			pilot.theme = data.get_value(section,"PILOT_%s_THEME"%pilot_index)
			pilot.status = data.get_value(section,"PILOT_%s_STATUS"%pilot_index)
			pilot.mission = data.get_value(section,"PILOT_%s_MISSION_ID"%pilot_index)
			pilot.better_odds = data.get_value(section,"PILOT_%s_BETTER_ODDS"%pilot_index)
			pilot.criteria_for_better_odds = data.get_value(section,"PILOT_%s_CIRTERIA_FOR_BETTER_ODDS"%pilot_index)
			pilot.worse_odds = data.get_value(section,"PILOT_%s_WORSE_ODDS"%pilot_index)
			pilot.criteria_for_worse_odds = data.get_value(section,"PILOT_%s_CRITERIA_FOR_WORSE_ODDS"%pilot_index)

			STATE.PILOTS.push_back(pilot);


func save_pilot_user_data(section):
	var data_user = ConfigFile.new()
	var index = 0;
	data_user.set_value(section,"NUMBER_OF_PILOTS",STATE.PILOTS.size())
	for pilot:Pilot in STATE.PILOTS:
		data_user.set_value(section,"PILOT_%s_ID"%index,pilot.ID)
		data_user.set_value(section,"PILOT_%s_NAME"%index,pilot.name)
		data_user.set_value(section,"PILOT_%s_COST"%index,pilot.cost)
		data_user.set_value(section,"PILOT_%s_FLAVOR"%index,pilot.flavor)
		data_user.set_value(section,"PILOT_%s_THEME"%index,pilot.theme)
		data_user.set_value(section,"PILOT_%s_STATUS"%index,pilot.status)
		data_user.set_value(section,"PILOT_%s_MISSION_ID"%index,pilot.mission_id)
		data_user.set_value(section,"PILOT_%s_BETTER_ODDS"%index,pilot.better_odds)
		data_user.set_value(section,"PILOT_%s_CRITERIA_FOR_BETTER_ODDS"%index,pilot.criteria_for_better_odds)
		data_user.set_value(section,"PILOT_%s_WORSE_ODDS"%index,pilot.worse_odds)
		data_user.set_value(section,"PILOT_%s_CRITERIA_FOR_WORSE_ODDS"%index,pilot.criteria_for_worse_odds)

		index+=1;
	var err = data_user.save("user://pilots.cfg")
	if err != OK:
		print(err)
