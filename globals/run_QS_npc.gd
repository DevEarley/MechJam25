extends Area3D
class_name NPC
#
#@export var character:BroduceEnums.CHARACTERS = BroduceEnums.CHARACTERS.UNDECIDED;
#@export_multiline var _Script:String;
#
##func _process(delta: float) -> void:
	###TODO - fix this
	##if(STATE.PLAYING_CARD_GAME == true):
		##self.hide()
		##self.process_mode =Node.PROCESS_MODE_DISABLED
	##if(STATE.PLAYING_CARD_GAME == false):
		##self.process_mode =Node.PROCESS_MODE_ALWAYS
		##self.show()
#
#
#func _on_area_entered(area:Area3D):
	#CONVERSATION_UI.show_start_conversation_button(self);
	#QS.init_script_from_npc(_Script, self,on_battle_start, on_finished_card_game)
	#var unprojected = STATE.CURRENT_CAMERA.unproject_position(self.global_position)
	##func set_button(button,_position, origin, from_scaled_ui,player):
	#JOYSTICK.set_button(JOYSTICK.POINTER_DIRECTION.POINTING_UP,unprojected,Vector2.ZERO,Vector2.ZERO,1)
#
#func on_finished_card_game():
	#CONVERSATION_UI.leave_conversation_area()
	#await WAIT.for_seconds(2)
	#self.show()
	#self.process_mode =Node.PROCESS_MODE_ALWAYS
#
#func on_battle_start():
	#CONVERSATION_UI.leave_conversation_area()
	#self.hide()
	#self.process_mode =Node.PROCESS_MODE_DISABLED
#
#func _on_area_exited(area:Area3D):
	#CONVERSATION_UI.leave_conversation_area()
