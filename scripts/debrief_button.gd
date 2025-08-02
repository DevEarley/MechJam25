extends Button

func _on_pressed() -> void:
	var mission:Mission = LINQ.First(STATE.MISSIONS,
		func (mission:Mission):
			return mission.ID==STATE.CURRENT_MISSION_ID);

	STATE.ON_QUEST_SCRIPT_DONE = do_daily_if_needed_or_go_to_menu
	STATE.MISSIONS_MENU_CANVAS.hide()

	if(CALCULATOR.has_passed_current_mission()):

		QS.run_script(mission.success_script)
	else:
		QS.run_script(mission.fail_script)

func do_daily_if_needed_or_go_to_menu():
	#if(STATE.DID_DAILY_FOR_MISSION == false):
	QS.run_script_from_file("daily") #for 24hour user
	STATE.ON_QUEST_SCRIPT_DONE = MISSIONS_MENU.on_back_to_mission_list
	#else:
		#STATE.MISSIONS_MENU_CANVAS.hide()
		#STATE.START_MENU_CANVAS.show()
