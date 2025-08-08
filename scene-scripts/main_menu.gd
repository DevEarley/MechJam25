extends Node
class_name MainMenu;

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$START.connect("pressed",_on_START_pressed)
	$EXIT.connect("pressed",_on_EXIT_pressed)
	$OPTIONS.connect("pressed",_on_OPTIONS_pressed)

func on_back_to_main_menu():

	MUSIC.play_music_for_main_menu()
	MAP.ANIMATOR.play("still")
	STATE.MAIN_MENU_CANVAS.show()
	STATE.OPTIONS_MENU_CANVAS.hide()
	STATE.STATUS_BAR_CANVAS.hide()


func go_to_start_menu():
		MUSIC.play_music_for_start_menu()
		SFX.play_click_sound()
		STATUS_BAR.update_status()
		MAP.ANIMATOR.play("idle")
		STATE.MAIN_MENU_CANVAS.hide()
		START_MENU.show_start_menu()

func _on_START_pressed():


	#if(STATE.USE_REAL_TIME == true &&
		#STATE.HAS_MISSION_IN_PROGRESS == true &&
		#STATE.CURRENT_MISSION != null ):
				#var time_24_hours = 60.0*60.0*24.0
				#var time_now = Time.get_unix_time_from_system()
				#var seconds_left = (int)(time_now-(STATE.CURRENT_MISSION.time_started + time_24_hours))
				#if(seconds_left <= 0):
					#STATE.DID_DAILY_FOR_MISSION = true;
					#QS.run_script_from_file("daily")
					#STATE.ON_QUEST_SCRIPT_DONE = go_to_start_menu
					#STATE.MAIN_MENU_CANVAS.hide()
#
				#else:
					#go_to_start_menu()
	#else:
		go_to_start_menu()



func _on_EXIT_pressed():

	get_tree().quit()

func _on_OPTIONS_pressed():
	#MUSIC.AUDIO_SOURCE.play(0)
	SFX.play_click_sound()
	MUSIC.play_music_for_options_menu()
	STATE.MAIN_MENU_CANVAS.hide()
	STATE.OPTIONS_MENU_CANVAS.show()
	STATE.ON_BACK_BUTTON_PRESSED = on_back_to_main_menu
