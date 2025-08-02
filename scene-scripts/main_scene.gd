extends Node

func _ready():

	STATE.MAP_BG = $BG2

	STATE.DEPLOYMENTS_MENU_CANVAS = preload("res://scenes/deployments-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.DEPLOYMENTS_MENU_CANVAS)
	STATE.DEPLOYMENTS_MENU_CANVAS.hide()

	STATE.LOCATION_SELECT_MENU_CANVAS = preload("res://scenes/locations-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.LOCATION_SELECT_MENU_CANVAS)
	STATE.LOCATION_SELECT_MENU_CANVAS.hide()

	STATE.PARTS_MENU_CANVAS = preload("res://scenes/parts-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.PARTS_MENU_CANVAS)
	STATE.PARTS_MENU_CANVAS.hide()

	STATE.PILOT_MENU_CANVAS = preload("res://scenes/pilots-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.PILOT_MENU_CANVAS)
	STATE.PILOT_MENU_CANVAS.hide()

	STATE.MECH_MENU_CANVAS = preload("res://scenes/mechs-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MECH_MENU_CANVAS)
	STATE.MECH_MENU_CANVAS.hide()

	STATE.MISSIONS_MENU_CANVAS = preload("res://scenes/missions-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MISSIONS_MENU_CANVAS)
	STATE.MISSIONS_MENU_CANVAS.hide()

	STATE.OPTIONS_MENU_CANVAS = preload("res://scenes/options-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.OPTIONS_MENU_CANVAS)
	STATE.OPTIONS_MENU_CANVAS.hide()

	STATE.START_MENU_CANVAS = preload("res://scenes/start-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.START_MENU_CANVAS)
	STATE.START_MENU_CANVAS.hide()

	STATE.EQUIP_PART_TO_MECH_POP_UP = preload("res://pop-ups/equip-part-to-mech-pop-up.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.EQUIP_PART_TO_MECH_POP_UP)
	STATE.EQUIP_PART_TO_MECH_POP_UP.hide()

	STATE.DIFFICULTY_SETTTING_MENU_CANVAS = preload("res://scenes/difficulty-setting.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.DIFFICULTY_SETTTING_MENU_CANVAS)
	STATE.DIFFICULTY_SETTTING_MENU_CANVAS.hide()

	STATE.MAIN_MENU_CANVAS = preload("res://scenes/main-menu.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.MAIN_MENU_CANVAS)
	STATE.MAIN_MENU_CANVAS.hide()

	STATE.STATUS_BAR_CANVAS = preload("res://scenes/status-bar.tscn").instantiate();
	SCALED_UI.add_canvas_to_viewport(STATE.STATUS_BAR_CANVAS)
	STATE.STATUS_BAR_CANVAS.hide()

	DATA.load_data()
