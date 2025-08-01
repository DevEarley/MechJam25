extends Button
@export var move_to_next_mission:bool




func _on_pressed() -> void:
	if(move_to_next_mission):
		MISSIONS_MENU.on_next_mission_pressed();
	else:
		MISSIONS_MENU.on_previous_mission_pressed();


func _on_mouse_entered() -> void:
	get_big()


func _on_mouse_exited() -> void:
	get_small()


func _on_focus_entered() -> void:
	get_big()


func _on_focus_exited() -> void:
	get_small()

func get_big():
	self.scale = Vector2(1.5,1.5)
func get_small():
	self.scale = Vector2(1.0,1.0)
