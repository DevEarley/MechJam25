extends Node
class_name DifficultySettings

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$difficulty_24_hours_button.ON_TIMER_DONE = _on_difficulty_24_hours_button_pressed
	#$difficulty_instant_button.ON_TIMER_DONE =_on_difficulty_instant_button_pressed

func _on_difficulty_24_hours_button_pressed():
	STATE.USE_REAL_TIME = true
	STATE.DIFFICULTY_ALREADY_CHOSEN = true

	if(STATE.SAVE_SLOT == "SAVESLOT_1"):
		STATE.SAVE_SLOT_1_IS_FRESH = false
	elif(STATE.SAVE_SLOT == "SAVESLOT_2"):
		STATE.SAVE_SLOT_2_IS_FRESH = false
	elif(STATE.SAVE_SLOT == "SAVESLOT_3"):
		STATE.SAVE_SLOT_3_IS_FRESH = false

	DATA.save_everything(true)
	show_start();

func _on_difficulty_instant_button_pressed():
	STATE.USE_REAL_TIME = false
	STATE.DIFFICULTY_ALREADY_CHOSEN = true

	if(STATE.SAVE_SLOT == "SAVESLOT_1"):
		STATE.SAVE_SLOT_1_IS_FRESH = false
	elif(STATE.SAVE_SLOT == "SAVESLOT_2"):
		STATE.SAVE_SLOT_2_IS_FRESH = false
	elif(STATE.SAVE_SLOT == "SAVESLOT_3"):
		STATE.SAVE_SLOT_3_IS_FRESH = false

	DATA.save_everything(true)
	show_start();

func show_start():
	SFX.play_start_mission_sound()
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()
	STATE.MAIN_MENU_CANVAS.hide()
	MUSIC.AUDIO_SOURCE.play(0)
	STATE.START_MENU_CANVAS.show()
	START_MENU.show_start_menu()
	MUSIC.play_music_for_start_menu()
