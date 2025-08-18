extends Node
class_name MainMenu;

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$START1.connect("pressed",_on_START_pressed.bind(1))
	$START2.connect("pressed",_on_START_pressed.bind(2))
	$START3.connect("pressed",_on_START_pressed.bind(3))
	$EXIT.connect("pressed",_on_EXIT_pressed)
	$FULLSCREEN.connect("pressed",_on_fullscreen)
	$OPTIONS.connect("pressed",_on_OPTIONS_pressed)

func on_back_to_main_menu():
	DATA.update_ui_after_USER_OPTIONS_are_loaded()
	MUSIC.play_music_for_main_menu()
	MAP.ANIMATOR.play("still")
	STATE.MAIN_MENU_CANVAS.show()
	STATE.OPTIONS_MENU_CANVAS.hide()
	STATE.STATUS_BAR_CANVAS.hide()




func _on_START_pressed(save_slot):
	STATE.SAVE_SLOT = "SAVESLOT_%s" % save_slot;
	DATA.load_or_create_everything()
	DATA.show_difficulty_select_or_main_menu()


func _on_EXIT_pressed():
	get_tree().quit()

func _on_OPTIONS_pressed():
	SFX.play_click_sound()
	MUSIC.play_music_for_options_menu()
	STATE.MAIN_MENU_CANVAS.hide()
	STATE.OPTIONS_MENU_CANVAS.show()
	STATE.ON_BACK_BUTTON_PRESSED = on_back_to_main_menu

func _on_fullscreen():
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
