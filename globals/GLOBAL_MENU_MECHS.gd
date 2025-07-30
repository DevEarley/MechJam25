extends Node
var MECH_BOX_PREFAB = preload("res://prefabs/mech_box_small.tscn")

func show_mechs():
	var MECH_BUTTONS = STATE.MECH_MENU_CANVAS.get_node("Control/SCROLLABLE/BUTTONS")
	for child in MECH_BUTTONS.get_children():
		child.queue_free()
	var button
	for mech:Mech in STATE.MECHS:
		var mech_button = DATA_TO_UI.build_mech_box_small(MECH_BOX_PREFAB, mech)
		mech_button.connect("pressed",on_mech_pressed.bind(mech.ID))

		MECH_BUTTONS.add_child(mech_button)
		if(mech.ID == STATE.CURRENT_MECH_ID):
			button = mech_button
	on_mech_pressed(STATE.CURRENT_MECH_ID)
	button.grab_focus()

func on_mech_pressed(id):
	STATE.CURRENT_MECH_ID = id;
	var current_mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
		return mech.ID == STATE.CURRENT_MECH_ID);
	var mech_nodes =  STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/SubViewportContainer/SubViewport/MECHS_NODE")
	var animator:AnimationPlayer =  STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/SubViewportContainer/SubViewport/AnimationPlayer")
	var button =STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/Button");
	var mech_box =STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/Button/MECH_BOX");
	button.show()
	mech_box.hide();
	animator.play("spin")
	DATA_TO_UI.display_node_for_mech(id,mech_nodes)
