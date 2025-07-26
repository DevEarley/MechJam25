extends Node
class_name MainMenu;

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$START.connect("pressed",_on_START_pressed)
	$EXIT.connect("pressed",_on_EXIT_pressed)
	$OPTIONS.connect("pressed",_on_OPTIONS_pressed)

func on_back_to_main_menu():
	STATE.MAIN_MENU.show()
	STATE.OPTIONS_MENU.hide()


func _on_START_pressed():
	STATE.MAIN_MENU.hide()
	STATE.START_MENU.show()

func _on_EXIT_pressed():
	get_tree().quit()

func _on_OPTIONS_pressed():
	STATE.MAIN_MENU.hide()
	STATE.OPTIONS_MENU.show()
	STATE.ON_BACK_BUTTON_PRESSED = on_back_to_main_menu
