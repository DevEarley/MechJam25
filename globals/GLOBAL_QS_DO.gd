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

		#"start multiplayer":
			#QS.call_back_on_finished.call()
			#STATE.CURRENT_PLAYER.hide()
			#CONVERSATION_UI.leave_conversation()
			#STATE.PLAYER_IS_LOCKED = true
			#var field_name = values[0]
			#var deck_number = values[1]
			#var player_id = values[2]
			#CARD_GAME_CONTROLLER.start_singleplayer_game(field_name, deck_number,player_id,func ():
				#print("GAME OVER!")
				#TRANSITIONS.star_in(Vector2(640,360))
				#await WAIT.for_seconds(2)
				#CAMERA_CONTROLLER.look_behind_player()
				#TRANSITIONS.star_out(Vector2(640,360))
				#)
		#"give overhead camera gift":
			#GIFTS.give_gift(GIFTS.GIFT_TYPE.OVERHEAD_CAMERA)
			#JOYSTICK.reset_and_hide_buttons()
			## actually interrupt the conversation and do a "gift git" animation
			#CONVERSATION_UI.hide_ui();
			#STATE.CURRENT_PLAYER_ANIMATOR.speed_scale = 1;
			#STATE.CURRENT_PLAYER_ANIMATOR.play("get_gift")
			#await WAIT.for_seconds(3)
			#STATE.CURRENT_PLAYER_ANIMATOR.play("idle")
#
			#CONVERSATION_UI.show_ui();
#
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#"give normal jump gift":
			#GIFTS.give_gift(GIFTS.GIFT_TYPE.NORMAL_JUMP)
			#JOYSTICK.reset_and_hide_buttons()
#
			## actually interrupt the conversation and do a "gift git" animation
			#CONVERSATION_UI.hide_ui();
			#STATE.CURRENT_PLAYER_ANIMATOR.speed_scale = 1;
			#STATE.CURRENT_PLAYER_ANIMATOR.play("get_gift")
			#await WAIT.for_seconds(3)
			#STATE.CURRENT_PLAYER_ANIMATOR.play("idle")
#
			#CONVERSATION_UI.show_ui();
#
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#"give rotation camera gift":
			#JOYSTICK.reset_and_hide_buttons()
			#GIFTS.give_gift(GIFTS.GIFT_TYPE.ROTATE_CAMERA)
			## actually interrupt the conversation and do a "gift git" animation
			#CONVERSATION_UI.hide_ui();
			#STATE.CURRENT_PLAYER_ANIMATOR.speed_scale = 1;
			#STATE.CURRENT_PLAYER_ANIMATOR.play("get_gift")
			#await WAIT.for_seconds(3)
			#STATE.CURRENT_PLAYER_ANIMATOR.play("idle")
#
			#CONVERSATION_UI.show_ui();
#
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
			#pass;
		#"play card game":
			#CONVERSATION_UI.hide_ui();
#
			#CONVERSATION_UI.leave_conversation()
			#STATE.PLAYER_IS_LOCKED = true
			##CARD_GAME_CONTROLLER.start_game(npc);
		#"go to title screen":
			#CONVERSATION_UI.hide_ui();
			#CONVERSATION_UI.leave_conversation()
#
			#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		#"talk to strawbro 1":
			#SAVE_SLOTS.CURRENT.TALKED_TO_STRAWBRO_1 = true;
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#"quit":
			#get_tree().quit()
		#"save game":
			#SAVE_SLOTS.save_game()
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#"reset game":
			#SAVE_SLOTS.CURRENT = SaveState.new()
			#SAVE_SLOTS.save_game()
			#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#"load game":
			#SAVE_SLOTS.load_game()
			#QS.CURRENT_LINE+=1;
			#QS.run_script__process_line();
		#var variable_pattern:
			#if(variable_pattern.begins_with("get card")):
				#var split = variable_pattern.split("get card ")
				#var number = int(split[0])
				#SAVE_SLOTS.CURRENT.COLLECTED_CARD_INDEXES.push_back(number)
				#JOYSTICK.reset_and_hide_buttons()
				## actually interrupt the conversation and do a "gift git" animation
				#CONVERSATION_UI.hide_ui();
#
				#QS.CURRENT_LINE+=1;
				#QS.run_script__process_line();
	pass;
