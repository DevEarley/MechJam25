extends Button
@export var NODE_TO_SCALE:Control;



func _on_focus_entered() -> void:
	NODE_TO_SCALE.scale= Vector2(1.1,1.1)



func _on_mouse_entered() -> void:
	NODE_TO_SCALE.scale= Vector2(1.1,1.1)


func _on_focus_exited() -> void:
	NODE_TO_SCALE.scale= Vector2(1.0,1.0)


func _on_mouse_exited() -> void:
	NODE_TO_SCALE.scale= Vector2(1.0,1.0)
