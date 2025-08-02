extends Node
class_name OptionsMenu;


func _ready():
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	STATE.USE_REAL_TIME = true


func _on_difficulty_instant_button_pressed():
	STATE.USE_REAL_TIME = false
