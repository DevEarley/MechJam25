extends Node

var PILOT_BOX_PREFAB = preload("res://prefabs/pilot_box_big.tscn")

func show_pilots():
	var PILOT_BUTTONS = STATE.PILOT_MENU_CANVAS.get_node("Control/SCROLLABLE/BUTTONS")
	for child in PILOT_BUTTONS.get_children():
		child.queue_free()

	for pilot:Pilot in STATE.PILOTS:
		var pilot_box = PILOT_BOX_PREFAB.instantiate()
		DATA_TO_UI.build_pilot_box(pilot_box,pilot)
		var pilot_button = pilot_box.get_node("HIRE_PILOT");
		if(pilot.status == ENUMS.PILOT_STATUS.FOR_HIRE && STATE.CREDITS >= pilot.cost):
			pilot_button.show()
			pilot_button.disabled = false;
			pilot_button.connect("pressed",hire_pilot.bind(pilot));
		else:

			pilot_button.show()
			pilot_button.disabled = true;
		PILOT_BUTTONS.add_child(pilot_box)

func hire_pilot(pilot:Pilot):
	STATE.CREDITS -= pilot.cost
	pilot.status = ENUMS.PILOT_STATUS.HIRED;
	DATA.save_pilots_to_user_data()
	DATA.save_game_state_to_user_data()
	STATUS_BAR.update_status()
	show_pilots()
