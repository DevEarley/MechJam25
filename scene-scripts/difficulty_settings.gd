extends Node
class_name DifficultySettings

var real_time : bool


func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	real_time = true
	_save_difficulty_choice()
	#save to options user file
	STATE.DIFFICULTY_SETTTING_MENU.hide()
	STATE.MAIN_MENU.show()

func _on_difficulty_instant_button_pressed():
	real_time = false
	_save_difficulty_choice()
	#save to options user file
	STATE.DIFFICULTY_SETTTING_MENU.hide()
	STATE.MAIN_MENU.show()


func _save_difficulty_choice():
	var config_user = ConfigFile.new()
	var err = await config_user.load("user://user_data.cfg")
	if err == 7: #if file doesn't exist, load base mission list, and then save it user side
		config_user.load("res://data/user_data.cfg")
		config_user.set_value("USER","USER_REAL_TIME",real_time)
		config_user.save("user://user_data.cfg")
	else:
		config_user.set_value("USER","USER_REAL_TIME",real_time)
		config_user.save("user://user_data.cfg")
