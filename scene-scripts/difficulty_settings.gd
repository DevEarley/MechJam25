extends Node
class_name DifficultySettings

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	STATE.USER_REAL_TIME = false
	DATA.save_user_data(true)
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	STATE.MAIN_MENU_CANVAS.show()

func _on_difficulty_instant_button_pressed():
	STATE.USER_REAL_TIME = false
	DATA.save_user_data(false)
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	STATE.MAIN_MENU_CANVAS.show()
