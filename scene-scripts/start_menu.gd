extends Node
class_name StartMenu

func _ready():
	#if there is no save file - show options.
	# otherwise  - go to main menu.
	$MISSIONS.connect("pressed",_on_MISSIONS_pressed)
	$PILOTS.connect("pressed",_on_PILOTS_pressed)
	$MECHS.connect("pressed",_on_MECHS_pressed)
	$DEPLOYMENTS.connect("pressed",_on_DEPLOYMENTS_pressed)
	$PARTS.connect("pressed",_on_PARTS_pressed)
	$LOCATIONS.connect("pressed",_on_LOCATIONS_pressed)
	$LOG_OFF.connect("pressed",_on_LOG_OFF_pressed)

func _on_back_to_start_menu():
	STATE.START_MENU.show()
	STATE.MISSIONS_MENU.hide()
	STATE.PILOT_MENU.hide()
	STATE.MECH_MENU.hide()
	STATE.DEPLOYMENTS_MENU.hide()
	STATE.PARTS_MENU.hide()
	STATE.LOCATION_SELECT_MENU.hide()



func _on_MISSIONS_pressed():
	STATE.MISSIONS_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_PILOTS_pressed():
	STATE.PILOT_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_MECHS_pressed():
	STATE.MECH_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_DEPLOYMENTS_pressed():
	STATE.DEPLOYMENTS_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_PARTS_pressed():
	STATE.PARTS_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_LOCATIONS_pressed():
	STATE.LOCATION_SELECT_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu

func _on_LOG_OFF_pressed():
	STATE.MAIN_MENU.show()
	STATE.START_MENU.hide()
	STATE.ON_BACK_BUTTON_PRESSED = _on_back_to_start_menu
