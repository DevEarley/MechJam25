extends Node
var MISSION_BOX_PREFAB = preload("res://prefabs/mission_box_small.tscn")
var MISSION_BUTTONS
var MISSION_BUTTONS_CONTAINER
var MISSION_BOX
var MAP_MATERIAL:ShaderMaterial = preload("res://materials/map_mat.tres")
var BACK_BUTTON

func show_missions():
	MISSION_BUTTONS = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	MISSION_BUTTONS_CONTAINER = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE")
	MISSION_BUTTONS_CONTAINER.show()
	MISSION_BOX = STATE.MISSIONS_MENU_CANVAS.get_node("MISSION_BOX")
	MISSION_BOX.hide()
	BACK_BUTTON = STATE.MISSIONS_MENU_CANVAS.get_node("BACK_BUTTON")
	BACK_BUTTON.text="BACK"
	for child in MISSION_BUTTONS.get_children():
		child.queue_free()

	for mission:Mission in STATE.MISSIONS:
		var mission_button = MISSION_BOX_PREFAB.instantiate()
		if(mission.status == ENUMS.MISSION_STATUS.LOCKED):
			mission_button.get_node("NAME").text = "???"
			mission_button.get_node("ONE_OVER_ODDS_FOR_MISSION").text = "1/???"
			mission_button.get_node("ONE_OVER_ODDS_FOR_RETURNING").text = "1/???"
		else:
			mission_button.get_node("NAME").text = "%s"%mission.name
			mission_button.get_node("ONE_OVER_ODDS_FOR_MISSION").text = "1/%03d"%mission.one_over_odds_for_mission
			mission_button.get_node("ONE_OVER_ODDS_FOR_RETURNING").text = "1/%03d"%mission.one_over_odds_for_returning

		mission_button.get_node("ID").text = "%03d"%mission.ID
		mission_button.get_node("STATUS").text = "%s"%mission.status
		build_status_for_mission(mission, mission_button)
		mission_button.connect("pressed",on_mission_pressed.bind(mission));
		MISSION_BUTTONS.add_child(mission_button)

func on_start_mission_script_finished():
	var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==STATE.CURRENT_MISSION_ID);
	if(STATE.USE_REAL_TIME == false):
		STATE.ON_QUEST_SCRIPT_DONE = on_back_to_mission_list
		if(CALCULATOR.has_passed_current_mission()):
			QS.run_script(mission.success_script)
		else:
			QS.run_script(mission.fail_script)
	else:
		mission.status = ENUMS.MISSION_STATUS.IN_PROGRESS
		DATA.save_missions_to_user_data()
		on_back_to_mission_list()


func start_mission_pressed():
	hide_all_menus()
	var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==STATE.CURRENT_MISSION_ID);
	STATE.HAS_MISSION_IN_PROGRESS = true
	STATE.CURRENT_MISSION = mission
	mission.time_started = Time.get_unix_time_from_system()
	STATE.ON_QUEST_SCRIPT_DONE = on_start_mission_script_finished;
	QS.run_script(mission.start_script);
	STATE.MISSIONS_MENU_CANVAS.hide();
	STATE.STATUS_BAR_CANVAS.hide()

func on_back_to_start_menu():
	STATE.START_MENU_CANVAS.show()
	STATE.MISSIONS_MENU_CANVAS.hide()
	var color = Vector3(0.0,1.0,170.0/255.0)
	MAP_MATERIAL.set_shader_parameter("ENVIRONMENT_TINT",color);
	MAP.ANIMATOR.play("idle")
	MAP.CURSOR.hide()

func on_back_to_mission_list():
	MISSION_BUTTONS_CONTAINER.show();
	MISSION_BUTTONS.show()
	STATE.STATUS_BAR_CANVAS.show()

	STATE.MISSIONS_MENU_CANVAS.show()
	MISSION_BOX.hide()
	STATE.MAP_BG.show()
	BACK_BUTTON.text="BACK"
	STATE.ON_BACK_BUTTON_PRESSED =on_back_to_start_menu
	var color = Vector3(0.0,1.0,170.0/255.0)
	MAP_MATERIAL.set_shader_parameter("ENVIRONMENT_TINT",color);
	MAP.CURSOR.hide()
	show_missions()

func on_mission_pressed(mission:Mission):
	STATE.ON_BACK_BUTTON_PRESSED =on_back_to_mission_list
	MAP.CURSOR.show()
	MISSION_BUTTONS_CONTAINER.hide();
	STATE.MAP_BG.hide()
	MAP.ANIMATOR.stop()
	BACK_BUTTON.text="MISSION LIST"

	var time_24_hours = 60.0*60.0*24.0
	var time_now = Time.get_unix_time_from_system()

	if(mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS):
		if(mission.time_started + time_24_hours <= time_now):
			mission.status = ENUMS.MISSION_STATUS.NEEDS_DEBRIEF;
			DATA.save_missions_to_user_data()


	var mission_bonus = CALCULATOR.get_mission_bonus(mission);
	var return_bonus = CALCULATOR.get_return_bonus(mission);
	for child in MISSION_BOX.get_children():
		if(child.name.begins_with("STATUS_") || child.name.begins_with("NAME") || child.name.begins_with("ID")):continue
		if(child.name.ends_with("LABEL") || child.name.ends_with("BG") || child.name.ends_with("MISSION")):continue
		if(child.name =="NEEDS_DEBRIEF"):continue
		if(child.name =="START_MISSION"):continue
		if(child.name =="MECH"):continue
		child.hide()
	var parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mission.ID && part.status == ENUMS.PART_STATUS.EQUIPT);
	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
	var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	STATE.CURRENT_MISSION_ID = mission.ID;
	STATE.CURRENT_MECH_ID = mech.ID;
	STATE.CURRENT_PILOT_ID = pilot.ID;
	STATE.CURRENT_LOCATION_ID = location.ID;
	MISSION_BOX.show()
	var environment_text = "UNKNOWN ENV"
	var environment_tint:Vector3 =Vector3(0.0,1.0,170.0/255.0)
	var label:Label = MISSION_BOX.get_node("ENVIRONMENT")
	var color = environment_tint/Vector3(255.0,255.0,255.0)
	MISSION_BOX.get_node("STATUS_LOCKED_ICON").hide()
	MISSION_BOX.get_node("STATUS_UNLOCKED_ICON").hide()
	MISSION_BOX.get_node("STATUS_IN_PROGRESS_ICON").hide()
	MISSION_BOX.get_node("STATUS_SUCCESS_ICON").hide()
	MISSION_BOX.get_node("STATUS_FAILED_ICON").hide()
	MISSION_BOX.get_node("START_MISSION").show()
	hide_all_menus()

	if(mission.status == ENUMS.MISSION_STATUS.LOCKED):
		build_status_for_mission(mission, MISSION_BOX)

		MISSION_BOX.get_node("MECH").text ="???"
		MISSION_BOX.get_node("NEEDS_DEBRIEF").visible = false
		MISSION_BOX.get_node("START_MISSION").visible = false
		MISSION_BOX.get_node("NEEDS_DEBRIEF").disabled = true
		MISSION_BOX.get_node("START_MISSION").disabled = true
		MISSION_BOX.get_node("MECH").disabled = true
		MISSION_BOX.get_node("PILOT_BUTTON").disabled = true
		MISSION_BOX.get_node("PARTS_BUTTON").disabled = true
		MISSION_BOX.get_node("PILOT_BUTTON").text ="???"
		MISSION_BOX.get_node("MECH/MECH_BOX").hide()
		MISSION_BOX.get_node("ID").text = "%03d"%mission.ID
		MISSION_BOX.get_node("NAME").text ="???"
		MISSION_BOX.get_node("FLAVOR").text = "???"
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_MISSION").text ="1/???"
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_RETURNING").text = "1/???"
		MISSION_BOX.get_node("MISSION_BONUS").text ="1/???"
		MISSION_BOX.get_node("RETURN_BONUS").text = "1/???"
		MISSION_BOX.get_node("ENVIRONMENT").text = "???"
		MISSION_BOX.get_node("LOCATION_POSITION").text = "[???,???]"
		MISSION_BOX.get_node("LOCATION_FLAVOR").text = "???"

	else:
		if(parts.size() ==0):
			MISSION_BOX.get_node("PARTS_BUTTON").disabled = true
		else:
			MISSION_BOX.get_node("PARTS_BUTTON").disabled = false

		MISSION_BOX.get_node("NEEDS_DEBRIEF").visible = false
		MISSION_BOX.get_node("START_MISSION").visible = false
		MISSION_BOX.get_node("NEEDS_DEBRIEF").disabled = true
		MISSION_BOX.get_node("START_MISSION").disabled = true
		MISSION_BOX.get_node("PILOT_BUTTON").text =pilot.name
		MISSION_BOX.get_node("MECH").text = mech.name
		MISSION_BOX.get_node("MECH").disabled = false
		MISSION_BOX.get_node("PILOT_BUTTON").disabled = false
		MISSION_BOX.get_node("MECH/MECH_BOX").hide()
		MISSION_BOX.get_node("ID").text = "%03d"%mission.ID
		MISSION_BOX.get_node("NAME").text = mission.name
		MISSION_BOX.get_node("FLAVOR").text = mission.flavor
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_MISSION").text = "1/%03d"%mission.one_over_odds_for_mission
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_RETURNING").text = "1/%03d"%mission.one_over_odds_for_returning

		MISSION_BOX.get_node("MISSION_BONUS").text ="1/%03d"%mission_bonus
		MISSION_BOX.get_node("RETURN_BONUS").text = "1/%03d"%return_bonus

		MISSION_BOX.get_node("LOCATION_POSITION").text = "[%03d,%03d]"%[location.map_position.x,location.map_position.z]
		MISSION_BOX.get_node("LOCATION_FLAVOR").text = location.flavor
		match(location.environment):
			ENUMS.ENVIRONMENT.DESERT:
				environment_text = "DESERT"
				environment_tint = Vector3(194,114,44);
			ENUMS.ENVIRONMENT.SWAMP:
				environment_text = "SWAMP"
				environment_tint = Vector3(25,157,102);
			ENUMS.ENVIRONMENT.URBAN:
				environment_text = "URBAN"
				environment_tint = Vector3(157,0,100);
			ENUMS.ENVIRONMENT.JUNGLE:
				environment_text = "JUNGLE"
				environment_tint = Vector3(82,176,53);
			ENUMS.ENVIRONMENT.SPACE:
				environment_text = "SPACE"
				environment_tint = Vector3(30,29,196);
			ENUMS.ENVIRONMENT.UNDERWATER_FROZEN:
				environment_text = "FROZEN WATER"
				environment_tint = Vector3(179,255,229);
			ENUMS.ENVIRONMENT.UNDERWATER:
				environment_text = "SALT WATER"
				environment_tint = Vector3(21,99,188);
			ENUMS.ENVIRONMENT.UNDERWATER_BOILING:
				environment_text = "BOILING WATER"
				environment_tint = Vector3(255,0,93);
			ENUMS.ENVIRONMENT.ICY:
				environment_text = "ICY"
				environment_tint = Vector3(255,255,255);
			ENUMS.ENVIRONMENT.UNDERGROUND:
				environment_text = "SUBTERRANEAN"
				environment_tint = Vector3(71,0,106);
			ENUMS.ENVIRONMENT.ACID_LAKE:
				environment_text = "ACID LAKE"
				environment_tint = Vector3(120,227,86);

		color = environment_tint/Vector3(255.0,255.0,255.0)
		MISSION_BOX.get_node("ENVIRONMENT").text = environment_text

		MAP.CAMERA.rotation = Vector3(-PI/2,0,0)
		MAP.start_moving_to_position( location.map_position)
		await WAIT.for_seconds(0.15)
		MAP.CURSOR.global_position = Vector3(location.map_position.x,MAP.CURSOR.global_position.y,location.map_position.z)

	label.modulate = Color(color.x,color.y,color.z);
	MAP_MATERIAL.set_shader_parameter("ENVIRONMENT_TINT",color);


	await WAIT.for_seconds(0.25)
	for child in MISSION_BOX.get_children():
		if(child.name.begins_with("STATUS_") || child.name.begins_with("NAME") || child.name.begins_with("ID")):continue
		if(child.name.ends_with("LABEL") || child.name.ends_with("BG") || child.name.ends_with("MISSION")):continue
		if(child.name =="MECH"):continue
		if(child.name =="NEEDS_DEBRIEF"):continue
		if(child.name =="START_MISSION"):continue

		child.show()
		await WAIT.for_seconds(0.001)

	build_status_for_mission(mission, MISSION_BOX)

func on_next_mission_pressed():
	var index = STATE.CURRENT_MISSION_ID+1;
	if( index > STATE.MISSIONS.size()-1):
		index = 0;
	STATE.CURRENT_MISSION_ID = index;
	hide_all_menus()

	on_mission_pressed(STATE.MISSIONS[STATE.CURRENT_MISSION_ID])

func on_previous_mission_pressed():
	var index = STATE.CURRENT_MISSION_ID-1;
	if( index <0):
		index = STATE.MISSIONS.size()-1;
	STATE.CURRENT_MISSION_ID = index;
	hide_all_menus()
	on_mission_pressed(STATE.MISSIONS[STATE.CURRENT_MISSION_ID])

func hide_all_menus():
	MISSION_BOX.get_node("Control/ScrollContainer/VBoxContainer").hide()
	MISSION_BOX.get_node("PILOT_BUTTON/PILOT_BOX").hide()
	MISSION_BOX.get_node("MECH/MECH_BOX").hide()

func build_status_for_mission(mission:Mission, BOX):
	BOX.get_node("STATUS_LOCKED_ICON").hide()
	BOX.get_node("STATUS_UNLOCKED_ICON").hide()
	BOX.get_node("STATUS_IN_PROGRESS_ICON").hide()
	BOX.get_node("STATUS_SUCCESS_ICON").hide()
	BOX.get_node("STATUS_FAILED_ICON").hide()
	var status_text = "UNKNOWN STS"
	match(mission.status):
		ENUMS.MISSION_STATUS.LOCKED:
			status_text = "LOCKED"
			if(BOX.has_node("START_MISSION")):
				BOX.get_node("START_MISSION").disabled = true
				BOX.get_node("START_MISSION").visible = true
				BOX.get_node("NEEDS_DEBRIEF").visible = false
			BOX.get_node("STATUS_LOCKED_ICON").show()
			BOX.get_node("STATUS").modulate =  Color(1.0,0.0,93.0/255.0);

		ENUMS.MISSION_STATUS.UNLOCKED:
			if(BOX.has_node("START_MISSION")):
				BOX.get_node("START_MISSION").disabled = false
				BOX.get_node("START_MISSION").visible = true
				BOX.get_node("NEEDS_DEBRIEF").visible = false
			status_text = "UNLOCKED"
			BOX.get_node("STATUS").modulate =  Color(0.0,1.0,169.0/255.0);
			BOX.get_node("STATUS_UNLOCKED_ICON").show()

		ENUMS.MISSION_STATUS.NEEDS_DEBRIEF:
			if(BOX.has_node("NEEDS_DEBRIEF")):
				BOX.get_node("NEEDS_DEBRIEF").disabled = false
				BOX.get_node("NEEDS_DEBRIEF").visible = true
				BOX.get_node("START_MISSION").visible = false
			status_text = "NEEDS DEBRIEF"
			BOX.get_node("STATUS").modulate =  Color(0.0,1.0,169.0/255.0);
			BOX.get_node("STATUS_SUCCESS_ICON").show()

		ENUMS.MISSION_STATUS.IN_PROGRESS:
			if(BOX.has_node("START_MISSION")):
				BOX.get_node("NEEDS_DEBRIEF").disabled = true
				BOX.get_node("NEEDS_DEBRIEF").visible = true
				BOX.get_node("START_MISSION").visible = false
			status_text = "IN_PROGRESS"
			BOX.get_node("STATUS_IN_PROGRESS_ICON").show()
			BOX.get_node("STATUS").modulate =  Color(1.0,1.0,1.0);

		ENUMS.MISSION_STATUS.SUCCESS:
			if(BOX.has_node("START_MISSION")):
				BOX.get_node("START_MISSION").disabled = true
				BOX.get_node("START_MISSION").visible = true
				BOX.get_node("NEEDS_DEBRIEF").visible = false
			status_text = "SUCCESS"
			BOX.get_node("STATUS_SUCCESS_ICON").show()
			BOX.get_node("STATUS").modulate =  Color(244.0/255.0,199.0/255.0,0.0);

		ENUMS.MISSION_STATUS.FAILED:
			if(BOX.has_node("START_MISSION")):
				BOX.get_node("START_MISSION").disabled = true
				BOX.get_node("START_MISSION").visible = true
				BOX.get_node("NEEDS_DEBRIEF").visible = false
			status_text = "FAILED"
			BOX.get_node("STATUS_FAILED_ICON").show()
			BOX.get_node("STATUS").modulate =  Color(1.0,0.0,93.0/255.0);

	BOX.get_node("STATUS").text = status_text
