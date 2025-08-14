extends CanvasLayer
func _ready():
	var mission = 	get_node("MISSION_BOX")
	mission.get_node("NEEDS_DEBRIEF").ON_TIMER_DONE = on_debrief
	$MISSION_BOX/START_MISSION.ON_TIMER_DONE = MISSIONS_MENU.start_mission_pressed

func on_debrief():
	var mission:Mission = LINQ.First(STATE.MISSIONS,
		func (mission:Mission):
			return mission.ID==STATE.CURRENT_MISSION_ID);
	STATE.CURRENT_MISSION = mission;
	STATE.ON_QUEST_SCRIPT_DONE = do_daily_if_needed_or_go_to_menu
	STATE.MISSIONS_MENU_CANVAS.hide()

	if(CALCULATOR.has_passed_current_mission() ):

		QS.run_script("do[play(success)]\nsay[MISSION COMPLETE!]\n%s"%mission.success_script)
	#elif(mech.status == ENUMS.MECH_STATUS.DESTROYED):
		#QS.run_script("say[Your mech was destroyed...] \n%s"%mission.fail_script)
	else:
		QS.run_script("do[play(fail)]\nsay[MISSION FAILED.]\n%s"%mission.fail_script)

func do_daily_if_needed_or_go_to_menu():

		STATE.CURRENT_MISSION = null;
		#if(STATE.DID_DAILY_FOR_MISSION == false):
		QS.run_script_from_file(preload("res://quest_scripts/daily.qs.tres"))

		STATE.ON_QUEST_SCRIPT_DONE = MISSIONS_MENU.on_back_to_mission_list
		#else:
		#STATE.MISSIONS_MENU_CANVAS.hide()
		#STATE.START_MENU_CANVAS.show()
