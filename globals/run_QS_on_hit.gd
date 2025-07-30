extends Node3D
#@export_multiline var _Script:String;
#
#func _on_hit(area):
	#CONVERSATION_UI.show_start_conversation_button(self);
	#QS.init_script(_Script,on_finished_script)
#
#func on_finished_script():
	#STATE.PLAYER_IS_LOCKED = false
	#
#func _on_area_3d_area_exited(area):
	#CONVERSATION_UI.leave_conversation_area()
