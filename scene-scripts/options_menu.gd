extends Node
class_name OptionsMenu;


func _ready():
	$difficulty_24_hours_button.connect("pressed",_on_difficulty_24_hours_button_pressed)
	$difficulty_instant_button.connect("pressed",_on_difficulty_instant_button_pressed)
	$RESET_GAME.ON_TIMER_DONE = reset_game
	$HARD_RESET.ON_TIMER_DONE = hard_reset_game
	$UNLOCK_EVERYTHING.ON_TIMER_DONE = unlock
	$TOGGLE_AUTOSAVE.ON_TIMER_DONE = toggle_autosave
	$EXECUTE_SCRIPT.ON_TIMER_DONE = execute_script
	$OPEN_DOCUMENTAION.ON_TIMER_DONE = open_documentation

func _on_difficulty_24_hours_button_pressed():

	SFX.play_start_mission_sound()
	STATE.USE_REAL_TIME = true


func _on_difficulty_instant_button_pressed():

	SFX.play_start_mission_sound()
	STATE.USE_REAL_TIME = false


func _on_options_menu_visibility_changed() -> void:
	if(STATE.OPTIONS_MENU_CANVAS.visible):
		if(STATE.USE_REAL_TIME):
			$difficulty_24_hours_button.grab_focus()
		else:
			$difficulty_instant_button.grab_focus()

func reset_game():
	STATE.OPTIONS_MENU_CANVAS.visible = false
	DATA.soft_reset_data()

func hard_reset_game():
	STATE.OPTIONS_MENU_CANVAS.visible = false
	DATA.hard_reset_data()

func unlock():
	for mission in STATE.MISSIONS:
		if(	mission.status == ENUMS.MISSION_STATUS.LOCKED):
			mission.status = ENUMS.MISSION_STATUS.UNLOCKED
	for voicemail in STATE.VOICEMAILS:
		if(	voicemail.status == ENUMS.VOICEMAIL_STATUS.LOCKED):
			voicemail.status = ENUMS.VOICEMAIL_STATUS.UNHEARD
	for pilot in STATE.PILOTS:
		if(	pilot.status == ENUMS.PILOT_STATUS.NOT_AVAILABLE_YET):
			pilot.status = ENUMS.PILOT_STATUS.FOR_HIRE


func toggle_autosave():
	STATE.AUTOSAVE = !STATE.AUTOSAVE
	if(STATE.AUTOSAVE):
		$TOGGLE_AUTOSAVE.text = "AUTOSAVE ON"
	else:
		$TOGGLE_AUTOSAVE.text = "AUTOSAVE OFF"

func execute_script():
	if($TextEdit.text==""):return;
	STATE.OPTIONS_MENU_CANVAS.hide()
	last_script = $TextEdit.text
	STATE.ON_QUEST_SCRIPT_DONE=execute_script_done
	QS.run_script($TextEdit.text)

var last_script =""

func execute_script_done():
	$TextEdit.text = ""
	STATE.OPTIONS_MENU_CANVAS.show()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_up") && $TextEdit.text == ""):
		$TextEdit.text =last_script


func open_documentation():
	OS.shell_open("https://gist.github.com/DevEarley/7cce1f08b92514237aeca8ae08c9b254")
