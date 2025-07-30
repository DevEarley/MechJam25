extends Node

var PART_BOX_PREFAB = preload("res://prefabs/part_box_small.tscn")
var EQUIP_BUTTON
var RECYCLE_BUTTON
var SELL_BUTTON
var BUY_BUTTON



func show_parts():

	var part_noded =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/Control/SubViewportContainer/SubViewport/PARTS_NODE")
	var part_list_buttons = STATE.PARTS_MENU_CANVAS.get_node("Control/SCROLLABLE/BUTTONS")
	var part_buttons = STATE.PARTS_MENU_CANVAS.get_node("BUTTONS");
	EQUIP_BUTTON = part_buttons.get_node("EQUIP_BUTTON");
	EQUIP_BUTTON.connect("pressed",on_equip_pressed)
	EQUIP_BUTTON.disabled = true

	RECYCLE_BUTTON = part_buttons.get_node("RECYCLE_BUTTON");
	RECYCLE_BUTTON.connect("pressed",on_recycle_button_pressed)
	RECYCLE_BUTTON.disabled = true

	SELL_BUTTON= part_buttons.get_node("SELL_BUTTON");
	SELL_BUTTON.connect("pressed",on_sell_button_pressed)
	SELL_BUTTON.disabled = true
	SELL_BUTTON.visible = false

	BUY_BUTTON= part_buttons.get_node("BUY_BUTTON");
	BUY_BUTTON.connect("pressed",on_buy_button_pressed)
	BUY_BUTTON.disabled = true
	BUY_BUTTON.visible = true

	for child in part_list_buttons.get_children():
		child.queue_free()
	var button
	for part:Part in STATE.PARTS:
		var part_button:Button = DATA_TO_UI.build_small_part_box(PART_BOX_PREFAB,part)
		part_button.connect("pressed",on_part_pressed.bind(part.ID))
		part_list_buttons.add_child(part_button)
		if(part.ID == STATE.CURRENT_PART_ID):
			button = part_button
	on_part_pressed(STATE.CURRENT_PART_ID)
	button.grab_focus()

func on_cancel_parts_menu():
	STATE.START_MENU_CANVAS.show()
	STATE.STATUS_BAR_CANVAS.show()
	STATE.PARTS_MENU_CANVAS.hide()

func on_cancel_equip_part_pop_up():
	STATE.ON_BACK_BUTTON_PRESSED = on_cancel_parts_menu

func on_buy_button_pressed():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.status= ENUMS.PART_STATUS.PURCHASED
	show_parts()


func on_equip_pressed():
	STATE.EQUIP_PART_TO_MECH_POP_UP.show();
	STATE.EQUIP_PART_TO_MECH_POP_UP.show_popup(on_cancel_equip_part_pop_up)
	STATE.ON_BACK_BUTTON_PRESSED = on_cancel_equip_part_pop_up
func on_recycle_button_pressed():
	#todo show popup
	pass

func on_sell_button_pressed():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.status= ENUMS.PART_STATUS.NOT_AVAILABLE
	show_parts()

func on_part_pressed(id:int):

	STATE.CURRENT_PART_ID = id;
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);

	if(current_part.status == ENUMS.PART_STATUS.PURCHASED):
		SELL_BUTTON.disabled = false
		SELL_BUTTON.visible = true
		BUY_BUTTON.visible = false
		RECYCLE_BUTTON.disabled = false
		EQUIP_BUTTON.disabled = false
	elif(current_part.status == ENUMS.PART_STATUS.FOR_SALE):
		SELL_BUTTON.disabled = true
		SELL_BUTTON.visible = false
		BUY_BUTTON.disabled = false
		BUY_BUTTON.visible = true
		RECYCLE_BUTTON.disabled = true
		EQUIP_BUTTON.disabled = true
	elif(current_part.status == ENUMS.PART_STATUS.NOT_AVAILABLE):
		SELL_BUTTON.disabled = true
		SELL_BUTTON.visible = true
		BUY_BUTTON.disabled = true
		BUY_BUTTON.visible = false
		RECYCLE_BUTTON.disabled = true
		EQUIP_BUTTON.disabled = true
	elif(current_part.status == ENUMS.PART_STATUS.EQUIPT):
		SELL_BUTTON.disabled = true
		SELL_BUTTON.visible = true
		BUY_BUTTON.disabled = true
		BUY_BUTTON.visible = false
		RECYCLE_BUTTON.disabled = true
		EQUIP_BUTTON.disabled = true
	else:
		SELL_BUTTON.disabled = true
		SELL_BUTTON.visible = true
		BUY_BUTTON.disabled = true
		BUY_BUTTON.visible = false
		RECYCLE_BUTTON.disabled = true
		EQUIP_BUTTON.disabled = true

	var part_nodes =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewportContainer/SubViewport/PARTS_NODE")
	var animator:AnimationPlayer =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewportContainer/SubViewport/AnimationPlayer")

	animator.play("spin")
	DATA_TO_UI.display_node_for_part(id,part_nodes)
