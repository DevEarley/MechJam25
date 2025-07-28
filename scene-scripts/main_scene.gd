extends Node

func _ready():
	STATE.DEPLOYMENTS_MENU = preload("res://scenes/deployments-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.DEPLOYMENTS_MENU)
	STATE.DEPLOYMENTS_MENU.hide()

	STATE.LOCATION_SELECT_MENU = preload("res://scenes/locations-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.LOCATION_SELECT_MENU)
	STATE.LOCATION_SELECT_MENU.hide()

	STATE.MAIN_MENU = preload("res://scenes/main-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MAIN_MENU)
	if _difficulty_already_chosen():
		STATE.MAIN_MENU.show()
	else:
		STATE.MAIN_MENU.hide()

	STATE.PARTS_MENU = preload("res://scenes/parts-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.PARTS_MENU)
	STATE.PARTS_MENU.hide()

	STATE.PILOT_MENU = preload("res://scenes/pilots-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.PILOT_MENU)
	STATE.PILOT_MENU.hide()

	STATE.MECH_MENU = preload("res://scenes/mechs-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MECH_MENU)
	STATE.MECH_MENU.hide()

	STATE.MISSIONS_MENU = preload("res://scenes/missions-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MISSIONS_MENU)
	STATE.MISSIONS_MENU.hide()

	STATE.OPTIONS_MENU = preload("res://scenes/options-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.OPTIONS_MENU)
	STATE.OPTIONS_MENU.hide()

	STATE.START_MENU = preload("res://scenes/start-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.START_MENU)
	STATE.START_MENU.hide()

	STATE.DIFFICULTY_SETTTING_MENU = preload("res://scenes/difficulty-setting.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.DIFFICULTY_SETTTING_MENU)
	if !_difficulty_already_chosen():
		STATE.DIFFICULTY_SETTTING_MENU.show()
	else:
		STATE.DIFFICULTY_SETTTING_MENU.hide()

func _difficulty_already_chosen():
	var config_user = ConfigFile.new()
	var err = config_user.load("user://user_data.cfg")
	if err == 7: #if file doesn't exist, load difficulty screen
		return false
	else:
		return true
