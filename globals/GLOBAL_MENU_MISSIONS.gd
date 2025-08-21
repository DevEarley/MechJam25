extends Node
var MISSION_BOX_PREFAB = preload("res://prefabs/mission_box_small.tscn")
var MISSION_BUTTONS
var MISSION_BUTTONS_CONTAINER
var MISSION_BOX
var MAP_MATERIAL:ShaderMaterial = preload("res://materials/map_mat.tres")
var BACK_BUTTON
var LAST_LOCATION

func show_missions():
	var _mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID == STATE.CURRENT_MISSION_ID)
	if(_mission != null && _mission.status == ENUMS.MISSION_STATUS.UNLOCKED):
		var mech= LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==STATE.CURRENT_MISSION_ID);
		if(mech != null):
			var pilot= LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
			if(pilot != null):
				pilot.mech_id = -1
				pilot.status=ENUMS.PILOT_STATUS.HIRED
			mech.mission_id = -1
			mech.status=ENUMS.MECH_STATUS.IN_GARAGE
	LAST_LOCATION = null
	MISSION_BUTTONS = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	MISSION_BUTTONS_CONTAINER = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE")
	MISSION_BUTTONS_CONTAINER.show()
	MISSION_BOX = STATE.MISSIONS_MENU_CANVAS.get_node("MISSION_BOX")
	MISSION_BOX.hide()
	BACK_BUTTON = STATE.MISSIONS_MENU_CANVAS.get_node("BACK_BUTTON")
	BACK_BUTTON.text="BACK"
	check_for_completed_missions()
	for child in MISSION_BUTTONS.get_children():
		child.queue_free()
	for mission:Mission in STATE.MISSIONS:
		var mission_button = MISSION_BOX_PREFAB.instantiate()
		if(mission.status == ENUMS.MISSION_STATUS.LOCKED):
			mission_button.get_node("NAME").text = "???"
		else:
			mission_button.get_node("NAME").text = "%s"%mission.name
			mission_button.get_node("ONE_OVER_ODDS_FOR_MISSION").text =DATA_TO_UI.one_over_dim_zeros(mission.one_over_odds_for_mission)
			mission_button.get_node("ONE_OVER_ODDS_FOR_RETURNING").text			=DATA_TO_UI.one_over_dim_zeros(mission.one_over_odds_for_returning)
		mission_button.get_node("ID").text = DATA_TO_UI.insert_leading_zeros(mission.ID)
		mission_button.get_node("STATUS").text = "%s"%mission.status
		build_status_for_mission(mission, mission_button)
		mission_button.connect("pressed",on_mission_pressed.bind(mission));
		MISSION_BUTTONS.add_child(mission_button)

func on_mission_pressed(mission:Mission):
	STATE.CURRENT_MISSION_ID = mission.ID;
	SFX.play_click_sound()
	STATE.ON_BACK_BUTTON_PRESSED =on_back_to_mission_list
	MAP.CURSOR.show()
	MISSION_BUTTONS_CONTAINER.hide();
	STATE.MAP_BG.hide()
	BACK_BUTTON.text="MISSION LIST  	"
	MISSION_BOX.get_node("MECH").text ="???"
	MISSION_BOX.get_node("MECH").disabled = true
	MISSION_BOX.get_node("PILOT_BUTTON").disabled = true
	MISSION_BOX.get_node("PILOT_BUTTON").text ="???"
	var time_24_hours
	if(STATE.USE_REAL_TIME == true):
		time_24_hours = 60.0*60.0*24.0
	else:
		time_24_hours = 8.0
	var time_now = Time.get_unix_time_from_system()
	var mech:Mech = null
	var parts = [];
	var pilot = null
	STATE.CURRENT_MECH_ID=-1
	STATE.CURRENT_PILOT_ID=-1
	if(mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS):
		if(mission.time_started + time_24_hours <= time_now):
			mission.status = ENUMS.MISSION_STATUS.NEEDS_DEBRIEF;
			STATE.CURRENT_MISSION_ID = -1;
			show_missions();
			return
	if(mission.status == ENUMS.MISSION_STATUS.UNLOCKED ):
		mech= LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
		if(mech!=null):
			if(mech.current_health <=0):
				STATE.CURRENT_MECH_ID =-1
				pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
				STATE.CURRENT_PILOT_ID = -1
				if(pilot!=null):
					pilot.mech_id = -1;
					pilot.status = ENUMS.PILOT_STATUS.HIRED;#todo - should be dead,but we should not be in this state.
					parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID);
			else:
				pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
				parts = STATE.PARTS.filter(
					func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);
				STATE.CURRENT_MECH_ID = mech.ID
				if(pilot!=null):
					STATE.CURRENT_PILOT_ID = pilot.ID;
	elif(mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS || mission.status == ENUMS.MISSION_STATUS.NEEDS_DEBRIEF):
		mech= LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
		if(mech!=null):
			STATE.CURRENT_MECH_ID = mech.ID
			pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
			parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);
		else:
			STATE.CURRENT_MECH_ID = -1
			pilot = null
			parts = []

		if(pilot!=null):
			STATE.CURRENT_PILOT_ID = pilot.ID;
		else:
			STATE.CURRENT_PILOT_ID = -1


	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	STATE.CURRENT_LOCATION_ID = location.ID;
	var mission_bonus = CALCULATOR.get_mission_bonus(mission);
	var return_bonus = CALCULATOR.get_return_bonus(mission);
	for child in MISSION_BOX.get_children():
		if(child.name.begins_with("STATUS_") || child.name.begins_with("NAME") || child.name.begins_with("ID")):continue
		if(child.name.ends_with("LABEL") || child.name.ends_with("BG") || child.name.ends_with("MISSION")):continue
		if(child.name =="NEEDS_DEBRIEF"):continue
		if(child.name =="START_MISSION"):continue
		if(child.name =="MECH"):continue
		child.hide()
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
		MISSION_BOX.get_node("PILOT_BUTTON").text ="???"
		MISSION_BOX.get_node("NEEDS_DEBRIEF").visible = false
		MISSION_BOX.get_node("START_MISSION").visible = false
		MISSION_BOX.get_node("NEEDS_DEBRIEF").disabled = true
		MISSION_BOX.get_node("START_MISSION").disabled = true
		MISSION_BOX.get_node("MECH").disabled = true
		MISSION_BOX.get_node("PILOT_BUTTON").disabled = true
		MISSION_BOX.get_node("PARTS_BUTTON").disabled = true
		MISSION_BOX.get_node("MECH/MECH_BOX").hide()
		MISSION_BOX.get_node("ID").text = DATA_TO_UI.insert_leading_zeros(mission.ID)
		MISSION_BOX.get_node("NAME").text ="???"
		MISSION_BOX.get_node("FLAVOR").text = "???"
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_MISSION").text ="1/???"
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_RETURNING").text = "1/???"
		MISSION_BOX.get_node("MISSION_BONUS").text ="1/???"
		MISSION_BOX.get_node("RETURN_BONUS").text = "1/???"
		MISSION_BOX.get_node("ENVIRONMENT").text = "???"
		MISSION_BOX.get_node("LOCATION_POSITION").text = "[???,???]"
		MISSION_BOX.get_node("LOCATION_FLAVOR").text = "???"
		MISSION_BOX.get_node("LOCATION_NAME").text = "???"
		LAST_LOCATION = null
	else:
		if(parts.size() ==0):
			MISSION_BOX.get_node("PARTS_BUTTON").disabled = true
		else:
			MISSION_BOX.get_node("PARTS_BUTTON").disabled = false
		MISSION_BOX.get_node("NEEDS_DEBRIEF").visible = false
		MISSION_BOX.get_node("START_MISSION").visible = false
		MISSION_BOX.get_node("NEEDS_DEBRIEF").disabled = true
		MISSION_BOX.get_node("START_MISSION").disabled = true
		MISSION_BOX.get_node("MECH/MECH_BOX").hide()
		MISSION_BOX.get_node("ID").text = DATA_TO_UI.insert_leading_zeros(mission.ID)
		MISSION_BOX.get_node("NAME").text = mission.name
		MISSION_BOX.get_node("FLAVOR").text = mission.flavor
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_MISSION").text =DATA_TO_UI.one_over_dim_zeros(mission.one_over_odds_for_mission)
		MISSION_BOX.get_node("ONE_OVER_ODDS_FOR_RETURNING").text =DATA_TO_UI.one_over_dim_zeros(mission.one_over_odds_for_returning)
		MISSION_BOX.get_node("MISSION_BONUS").text ="+%s" % mission_bonus
		MISSION_BOX.get_node("RETURN_BONUS").text = "+%s" % return_bonus
		var total_odds = mission.one_over_odds_for_mission + mission_bonus
		var total_return_odds = mission.one_over_odds_for_returning + return_bonus
		var total_mission_percentage
		var total_return_percentage
		if( mission.one_over_odds_for_mission >0):
			MISSION_BOX.get_node("MISSION_TOTAL_ODDS").text ="[right]%s"%DATA_TO_UI.one_over_dim_zeros(total_odds)
			total_mission_percentage = int((1.0 - (1.0/total_odds) )* 100.0)
			MISSION_BOX.get_node("MISSION_TOTAL_PERCENTAGE").text = "%%%2d" % total_mission_percentage
			MISSION_BOX.get_node("MISSION_TOTAL_PERCENTAGE").modulate = Color(0,1,170.0/255.0)
		else:
			MISSION_BOX.get_node("MISSION_TOTAL_ODDS").text = "[right][dim]%s/[/dim]%s" % [(1+mission_bonus),(mission.one_over_odds_for_mission*-1)]
			total_mission_percentage = ((float(1.0+mission_bonus)/float(mission.one_over_odds_for_mission)) * -100.0)
			MISSION_BOX.get_node("MISSION_TOTAL_PERCENTAGE").text = "%%%2.1f" % total_mission_percentage
			MISSION_BOX.get_node("MISSION_TOTAL_PERCENTAGE").modulate = Color(338.0/255.0,0,93.0/255.0)
		if( mission.one_over_odds_for_returning >0):
			MISSION_BOX.get_node("RETURN_TOTAL_ODDS").text ="[right]%s"%DATA_TO_UI.one_over_dim_zeros(total_return_odds)
			total_return_percentage = int((1.0 - (1.0/total_return_odds) )* 100.0)
			MISSION_BOX.get_node("RETURN_TOTAL_PERCENTAGE").text = "%%%2d" % total_return_percentage
			MISSION_BOX.get_node("RETURN_TOTAL_PERCENTAGE").modulate = Color(0,1,170.0/255.0)
		else:
			MISSION_BOX.get_node("RETURN_TOTAL_ODDS").text = "[right][dim]%s/[/dim]%s" % [(1+return_bonus),(mission.one_over_odds_for_returning*-1)]
			total_return_percentage = ((float(1.0+return_bonus)/float(mission.one_over_odds_for_returning)) * -100.0)
			MISSION_BOX.get_node("RETURN_TOTAL_PERCENTAGE").text = "%%%2.1f" % total_return_percentage
			MISSION_BOX.get_node("RETURN_TOTAL_PERCENTAGE").modulate = Color(338.0/255,0,93.0/255.0)
		MISSION_BOX.get_node("LOCATION_POSITION").text = "[%3s,%3s]"%[location.map_position.x,location.map_position.z]
		MISSION_BOX.get_node("LOCATION_FLAVOR").text = location.flavor
		MISSION_BOX.get_node("LOCATION_NAME").text = location.name
		var results = DATA_TO_UI.get_environment_text_and_tint(location.environment)
		environment_text= results[0]
		environment_tint= results[1]
		color = environment_tint/Vector3(255.0,255.0,255.0)
		MISSION_BOX.get_node("ENVIRONMENT").text = environment_text
		if(LAST_LOCATION==null || location!=LAST_LOCATION):
			MAP.ANIMATOR.stop()
			MAP.CAMERA.rotation = Vector3(-PI/2,0,0)
			MAP.start_moving_to_position( location)
			await WAIT.for_seconds(0.15)
			MAP.CURSOR.global_position = Vector3(location.map_position.x,MAP.CURSOR.global_position.y,location.map_position.z)
		LAST_LOCATION = location
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
	if(mission.status == ENUMS.MISSION_STATUS.SUCCESS):
			MISSION_BOX.get_node("NEEDS_DEBRIEF").disabled = true;
			MISSION_BOX.get_node("START_MISSION").disabled = true;
			MISSION_BOX.get_node("MECH").disabled = true;
			MISSION_BOX.get_node("PILOT_BUTTON").disabled = true;
			MISSION_BOX.get_node("PARTS_BUTTON").disabled = true;
	elif(mission.status != ENUMS.MISSION_STATUS.LOCKED):
		if(mech == null):
			MISSION_BOX.get_node("START_MISSION").disabled = true
			MISSION_BOX.get_node("PILOT_BUTTON").disabled = true
			MISSION_BOX.get_node("PILOT_BUTTON").text = "UNASSIGNED"
			MISSION_BOX.get_node("MECH").text = "ASSIGN MECH"
			MISSION_BOX.get_node("MECH").disabled = false
		elif(pilot == null && mech != null):
			MISSION_BOX.get_node("START_MISSION").disabled = true
			MISSION_BOX.get_node("PILOT_BUTTON").text = "ASSIGN PILOT"
			MISSION_BOX.get_node("PILOT_BUTTON").disabled = false
			MISSION_BOX.get_node("MECH").disabled = false
			MISSION_BOX.get_node("MECH").text = mech.name
		elif(pilot != null && mech != null):
			MISSION_BOX.get_node("MECH").disabled = false
			MISSION_BOX.get_node("MECH").text = mech.name
			MISSION_BOX.get_node("PILOT_BUTTON").disabled = false
			MISSION_BOX.get_node("PILOT_BUTTON").text =pilot.name



func check_for_completed_missions():
		var something_changed = false
		for mission:Mission in STATE.MISSIONS:
			if(mission.status == ENUMS.MISSION_STATUS.IN_PROGRESS):
				var time_24_hours
				if(STATE.USE_REAL_TIME == true):
					time_24_hours = 60.0*60.0*24.0
				else:
					time_24_hours = 8.0
				var time_now = Time.get_unix_time_from_system()
				var seconds_left = (int)((mission.time_started + time_24_hours) - time_now)
				if(seconds_left<=0):
					something_changed =true
					mission.status = ENUMS.MISSION_STATUS.NEEDS_DEBRIEF
		if(something_changed):
			DATA.save_everything()

func on_instant_player_result_script_finished():
	QS.run_script_from_file(preload("res://quest_scripts/daily.qs.tres")) #for instant user
	STATE.ON_QUEST_SCRIPT_DONE = on_back_to_mission_list

func on_start_mission_script_finished():
	DATA.save_everything()
	on_back_to_mission_list()

func start_mission_pressed():
	SFX.play_start_mission_sound()
	hide_all_menus()
	var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==STATE.CURRENT_MISSION_ID);
	STATE.HAS_MISSION_IN_PROGRESS = true
	STATE.MISSION_COMPLETE_NOTIFICATION_SENT = false
	STATE.CURRENT_MISSION = mission
	mission.status = ENUMS.MISSION_STATUS.IN_PROGRESS
	DATA.save_everything()
	mission.time_started = Time.get_unix_time_from_system()
	STATE.ON_QUEST_SCRIPT_DONE = on_start_mission_script_finished;
	QS.run_script(mission.start_script);
	STATE.MISSIONS_MENU_CANVAS.hide();
	STATE.STATUS_BAR_CANVAS.hide()

func on_back_to_start_menu():
	START_MENU.show_start_menu()
	STATE.MISSIONS_MENU_CANVAS.hide()
	MUSIC.AUDIO_SOURCE.play(0)
	MUSIC.play_music_for_start_menu()

func on_back_to_mission_list():
	MUSIC.play_music_for_mission_menu()
	STATE.CURRENT_MECH_ID = -1
	STATE.CURRENT_PILOT_ID = -1
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
	MISSION_BOX.get_node("PILOT_BUTTON/PILOT_BOX").hide()
	MISSION_BOX.get_node("PILOT_BUTTON/PILOT_LIST").hide()
	MISSION_BOX.get_node("MECH/MECH_BOX").hide()
	MISSION_BOX.get_node("MECH/MECH_LIST").hide()
	MISSION_BOX.get_node("PARTS_BUTTON/PART_LIST").hide()

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
