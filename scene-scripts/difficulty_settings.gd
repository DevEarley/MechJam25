extends Node
class_name DifficultySettings

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)


func _on_difficulty_24_hours_button_pressed():
	SFX.play_start_mission_sound()

	STATE.USE_REAL_TIME = true
	STATE.DIFFICULTY_ALREADY_CHOSEN = true
	DATA.save_game_state_to_user_data()
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	STATE.MAIN_MENU_CANVAS.show()

	MUSIC.AUDIO_SOURCE.play(0)
	MUSIC.play_music_for_main_menu()

func _on_difficulty_instant_button_pressed():
	SFX.play_start_mission_sound()

	STATE.USE_REAL_TIME = false
	STATE.DIFFICULTY_ALREADY_CHOSEN = true
	DATA.save_game_state_to_user_data()
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	STATE.MAIN_MENU_CANVAS.show()
	MUSIC.AUDIO_SOURCE.play(0)
	MUSIC.play_music_for_main_menu()
