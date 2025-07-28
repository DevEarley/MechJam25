extends Node
class_name OptionsMenu;

var real_time : bool

func _ready():
	$save_button.connect("pressed",_on_save_button_pressed)
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	pass
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")


func _on_difficulty_instant_button_pressed():
	real_time = false
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")




func _on_save_button_pressed():
	real_time = true
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")


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
