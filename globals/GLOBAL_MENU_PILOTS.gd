extends Node

var PILOT_BOX_PREFAB = preload("res://prefabs/pilot_box.tscn")
func show_pilots():
	var PILOT_BUTTONS = STATE.PILOT_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in PILOT_BUTTONS.get_children():
		child.queue_free()

	for pilot:Pilot in STATE.PILOTS:
		var pilot_button = PILOT_BOX_PREFAB.instantiate()
		DATA_TO_UI.build_pilot_box(pilot_button,pilot)

		PILOT_BUTTONS.add_child(pilot_button)
