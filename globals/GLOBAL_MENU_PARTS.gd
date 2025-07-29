extends Node

var PART_BOX_PREFAB = preload("res://prefabs/part_box_small.tscn")
var EQUIP_BUTTON
var RECYCLE_BUTTON
var SELL_BUTTON



func show_parts():
	var part_noded =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/Control/SubViewportContainer/SubViewport/PARTS_NODE")
	var part_list_buttons = STATE.PARTS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
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

	for child in part_list_buttons.get_children():
		child.queue_free()

	for part:Part in STATE.PARTS:
		var part_button = DATA_TO_UI.build_small_part_box(PART_BOX_PREFAB,part)
		part_button.connect("pressed",on_part_pressed.bind(part.ID))
		part_list_buttons.add_child(part_button)
func on_cancel_equip_part_pop_up():
	pass

func on_equip_pressed():
	STATE.EQUIP_PART_TO_MECH_POP_UP.show();
	STATE.EQUIP_PART_TO_MECH_POP_UP.show_popup(on_cancel_equip_part_pop_up)

func on_recycle_button_pressed():
	#todo show popup
	pass

func on_sell_button_pressed():
	#todo show popup
	pass

func on_part_pressed(id:int):
	SELL_BUTTON.disabled = false
	RECYCLE_BUTTON.disabled = false
	EQUIP_BUTTON.disabled = false

	var PART_NODES =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewportContainer/SubViewport/PARTS_NODE")
	var ANIMATOR:AnimationPlayer =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewportContainer/SubViewport/AnimationPlayer")

	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	if(current_part.status == ENUMS.PART_STATUS.EQUIPT):
		EQUIP_BUTTON.disabled = true;
	else:
		EQUIP_BUTTON.disabled = false;

	STATE.CURRENT_PART_ID = id;

	#if(ANIMATOR.current_animation!= "spin_up"):
		#ANIMATOR.play("spin_up")
	#else:
	ANIMATOR.play("spin")
	for _node in PART_NODES.get_children():
		_node.hide()
	match(id):
			0:
				PART_NODES.get_node("HEAT_BLADE").show();
			1:
				PART_NODES.get_node("ICE_BLADE").show();
			2:
				PART_NODES.get_node("BLUE_NUT").show();
			3:
				PART_NODES.get_node("RED_NUT").show();
			4:
				PART_NODES.get_node("RED_NUT").show();
			5:
				PART_NODES.get_node("RED_NUT").show();
			6:
				PART_NODES.get_node("RED_NUT").show();
			7:
				PART_NODES.get_node("RED_NUT").show();
			8:
				PART_NODES.get_node("RED_NUT").show();
			9:
				PART_NODES.get_node("RED_NUT").show();
