extends Node
class_name OptionsMenu;

var real_time : bool

func _ready():
	$save_button.connect("pressed",_on_save_button_pressed)
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	real_time = true
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")


func _on_difficulty_instant_button_pressed():
	real_time = false
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")




func _on_save_button_pressed():
	STATE.USER_REAL_TIME = real_time
	DATA.save_user_data(STATE.USER_REAL_TIME)
	print("Saved!")
	#save to options user file
	#get_tree().change_scene("res://scenes/main_menu.tscn")
