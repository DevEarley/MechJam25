extends Node
class_name OptionsMenu;


func _ready():
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	STATE.USE_REAL_TIME = true


func _on_difficulty_instant_button_pressed():
	STATE.USE_REAL_TIME = false


func _on_options_menu_visibility_changed() -> void:
	if(STATE.OPTIONS_MENU_CANVAS.visible):
		if(STATE.USE_REAL_TIME):
			$difficulty_24_hours_button.grab_focus()
		else:
			$difficulty_instant_button.grab_focus()
