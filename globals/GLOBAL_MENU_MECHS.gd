extends Node
var MECH_BOX_PREFAB = preload("res://prefabs/mech_box_small.tscn")

func show_mechs():
	STATE.CURRENT_MECH_ID = 0;
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
	var buy_button =STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/BUY_MECH_BUTTON");
	var sell_button =STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/SELL_MECH_BUTTON");
	var mech_box =STATE.MECH_MENU_CANVAS.get_node("MECH_VIEW/MECH_BOX");
	if(buy_button.has_connections("pressed") == false):
		buy_button.connect("pressed",on_buy_mech);
	if(sell_button.has_connections("pressed") == false):
		sell_button.connect("pressed",on_sell_mech);
	mech_box.show()
	DATA_TO_UI.build_mech_box(mech_box,current_mech)
	if(current_mech.status == ENUMS.MECH_STATUS.IN_GARAGE):
		sell_button.show()
		buy_button.hide()

		sell_button.text = "SELL MECH [%s]"%current_mech.selling_price
	elif(current_mech.status == ENUMS.MECH_STATUS.FOR_SALE):
		sell_button.hide()
		buy_button.show()
		buy_button.text = "BUY MECH [%s]"%current_mech.cost
	else:
		sell_button.hide()
		buy_button.hide()
	if(STATE.CREDITS >= current_mech.cost):
		buy_button.disabled = false;
	else:
		buy_button.disabled = true;

	animator.play("look_up_at_mech")
	DATA_TO_UI.display_node_for_mech(id,mech_nodes)

func on_buy_mech():
	var mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
		return mech.ID == STATE.CURRENT_MECH_ID);
	STATE.CREDITS-=mech.cost
	mech.status = ENUMS.MECH_STATUS.IN_GARAGE
	DATA.save_game_state_to_user_data()
	DATA.save_mechs_to_user_data()
	STATUS_BAR.update_status()

	show_mechs()

func on_sell_mech():
	var mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
		return mech.ID == STATE.CURRENT_MECH_ID);
	STATE.CREDITS+=mech.selling_price
	mech.status = ENUMS.MECH_STATUS.NOT_AVAILABLE
	DATA.save_mechs_to_user_data()
	DATA.save_game_state_to_user_data()
	STATUS_BAR.update_status()
	show_mechs()
