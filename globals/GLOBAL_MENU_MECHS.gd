extends Node
var MECH_BOX_PREFAB = preload("res://prefabs/mech_box.tscn")
func show_mechs():
	var MECH_BUTTONS = STATE.MECH_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in MECH_BUTTONS.get_children():
		child.queue_free()

	for mech:Mech in STATE.MECHS:
		var mech_button = DATA_TO_UI.build_mech_box(MECH_BOX_PREFAB, mech)
		MECH_BUTTONS.add_child(mech_button)
