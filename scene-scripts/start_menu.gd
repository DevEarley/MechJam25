extends Node
class_name StartMenu

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$MISSIONS.connect("pressed",_on_MISSIONS_pressed)
	$PILOTS.connect("pressed",_on_PILOTS_pressed)
	$MECHS.connect("pressed",_on_MECHS_pressed)
	#$DEPLOYMENTS.connect("pressed",_on_DEPLOYMENTS_pressed)
	$PARTS.connect("pressed",_on_PARTS_pressed)
	#$LOCATIONS.connect("pressed",_on_LOCATIONS_pressed)
	$LOG_OFF.connect("pressed",_on_LOG_OFF_pressed)
	$OPTIONS.connect("pressed",on_options_pressed)

func _on_back_to_start_menu():
	MUSIC.play_music_for_start_menu()
	START_MENU.show_start_menu()
	STATE.MISSIONS_MENU_CANVAS.hide()
	STATE.PILOT_MENU_CANVAS.hide()
	STATE.MECH_MENU_CANVAS.hide()
	STATE.DEPLOYMENTS_MENU_CANVAS.hide()
	STATE.PARTS_MENU_CANVAS.hide()
	STATE.OPTIONS_START_MENU_CANVAS.hide()
	STATE.LOCATION_SELECT_MENU_CANVAS.hide()

func _on_MISSIONS_pressed():
	MUSIC.AUDIO_SOURCE.play(0)
	MUSIC.play_music_for_mission_menu()
	SFX.play_click_sound()
	MISSIONS_MENU.show_missions()
	STATE.MISSIONS_MENU_CANVAS.show()
	STATE.START_MENU_CANVAS.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_PILOTS_pressed():
	MUSIC.play_music_for_pilot_menu()

	SFX.play_click_sound()
	PILOTS_MENU.show_pilots()
	STATE.PILOT_MENU_CANVAS.show()
	STATE.START_MENU_CANVAS.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_MECHS_pressed():
	MUSIC.play_music_for_mech_menu()

	SFX.play_click_sound()
	STATE.CURRENT_MECH_ID = 0;
	MECH_MENU.show_mechs()

	STATE.MECH_MENU_CANVAS.show()
	STATE.START_MENU_CANVAS.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu
	STATE.MECH_MENU_CANVAS.get_node("Control/SCROLLABLE/BUTTONS").get_child(0).grab_focus()
#func _on_DEPLOYMENTS_pressed():
#
	#STATE.DEPLOYMENTS_MENU_CANVAS.show()
	#STATE.START_MENU_CANVAS.hide()
	#STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_PARTS_pressed():
	MUSIC.play_music_for_part_menu()

	SFX.play_click_sound()
	PARTS_MENU.show_parts()
	STATE.PARTS_MENU_CANVAS.show()
	STATE.START_MENU_CANVAS.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

#func _on_LOCATIONS_pressed():
	#STATE.LOCATION_SELECT_MENU_CANVAS.show()
	#STATE.START_MENU_CANVAS.hide()
	#STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_LOG_OFF_pressed():
	MUSIC.play_music_for_main_menu()
	SFX.play_click_sound()
	#STATE.DID_DAILY_FOR_MISSION = false;
	MAP.ANIMATOR.play("still")
	STATE.MAIN_MENU_CANVAS.show()
	STATE.START_MENU_CANVAS.hide()
	STATE.STATUS_BAR_CANVAS.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu
	await DATA.save_everything(true)
	DATA.update_ui_after_USER_OPTIONS_are_loaded()

func on_options_pressed():

	STATE.START_MENU_CANVAS.hide()
	STATE.OPTIONS_START_MENU_CANVAS.show()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu
	MUSIC.play_music_for_options_menu()
