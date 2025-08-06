extends Node
func run_script__do_for_NPC(func_name_and_value:String, for_NPC:NPC):
	do(func_name_and_value, true, for_NPC)

func run_script__do(func_name_and_value:String):
	do(func_name_and_value, false, null)

func do(func_name_and_value:String, for_NPC:bool, npc:NPC):
	print("QS DO | %s" % func_name_and_value)
	var function_name;
	var values;
	if(func_name_and_value.contains(",")):
		var split_on_comma = func_name_and_value.split(",");
		function_name = split_on_comma[0]
		split_on_comma.remove_at(0)
		values = split_on_comma
	elif(func_name_and_value.contains("(")&&func_name_and_value.contains(")")):
		var split_on_parens = func_name_and_value.split("(");
		values = split_on_parens[1].trim_suffix(")").split(",")
		function_name = split_on_parens[0]
	else:
		function_name = func_name_and_value
	var pattern:String = function_name.to_lower()
	match(pattern):
		"quit":
			get_tree().quit()
		"unlock mission":
			var id:int = int(values[0])
			var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==id);
			mission.status = ENUMS.MISSION_STATUS.UNLOCKED
			DATA.save_missions_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"fail mission":
			var id:int = int(values[0])
			var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==id);
			mission.status = ENUMS.MISSION_STATUS.FAILED
			DATA.save_missions_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"complete mission":
			var id:int = int(values[0])
			var mission:Mission = LINQ.First(STATE.MISSIONS,func (mission:Mission): return mission.ID==id);
			mission.status = ENUMS.MISSION_STATUS.SUCCESS
			DATA.save_missions_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"get credits":
			STATE.CREDITS+=int(values[0])
			STATUS_BAR.update_status()
			DATA.save_game_state_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"get pilot", "unlock pilot":
			var pilot_id = int(values[0])
			var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.ID == pilot_id);
			pilot.status = ENUMS.PILOT_STATUS.HIRED
			STATUS_BAR.update_status()

			DATA.save_pilots_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"get mech", "unlock mech":
			var mech_id = int(values[0])
			var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.ID == mech_id);
			mech.status = ENUMS.MECH_STATUS.IN_GARAGE
			STATUS_BAR.update_status()

			DATA.save_mechs_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();

		"get part","unlock part":
			var part_id = int(values[0])
			var part:Part = LINQ.First(STATE.PARTS,func (part:Part): return part.ID == part_id);
			part.status = ENUMS.PART_STATUS.PURCHASED
			STATUS_BAR.update_status()

			DATA.save_parts_to_user_data()
			QS.CURRENT_LINE+=1;
			QS.run_script__process_line();
		"play":
			match(values[0]):
				"success":
					SFX.play_mission_success_sound()
					pass
				"fail","failure":
					SFX.play_mission_fail_sound()

					pass
				"ring ring":
					SFX.play_ring_ring_sound()
					pass
			pass


	pass;
