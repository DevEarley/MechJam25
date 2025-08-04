extends CanvasLayer

var MECH_BOX_PREFAB = preload("res://prefabs/mech_box_small.tscn")
var ON_CANCEL:Callable



func _ready():
	$EQUIP_BUTTON.connect("pressed",on_equip_button_pressed)
	$CANCEL_BUTTON.connect("pressed",on_cancel_equip_part_pop_up)
	init_children()

func on_cancel_equip_part_pop_up():
	ON_CANCEL.call()
	STATE.EQUIP_PART_TO_MECH_POP_UP.hide()

func show_popup(on_cancel):
	ON_CANCEL = on_cancel;
	init_children();

func init_children():
	$AnimationPlayer.queue("step_0")
	$Part_SubViewportContainer.hide()
	$Mech_SubViewportContainer.show()
	$EQUIP_BUTTON.hide()
	$CANCEL_BUTTON.show()
	$SELECT_MECH.show()

	$EQUIP_PART.hide()
	$TextureRect.hide()
	$TextureRect2.hide()
	$TextureRect3.hide()
	$MECH_LIST.show()
	$MECH_LIST/MECH_BUTTONS.show()
	for child:Button in $MECH_LIST/MECH_BUTTONS.get_children():
		child.queue_free()
	STATE.CURRENT_MECH_ID = 0;
	for mech:Mech in STATE.MECHS:
		var mech_box = DATA_TO_UI.build_mech_box_small(MECH_BOX_PREFAB, mech)

		mech_box.add_child(mech_box)
		if(mech.status == ENUMS.MECH_STATUS.IN_GARAGE):
			mech_box.disabled = false;
			mech_box.connect("pressed",on_pick_mech.bind(mech))
			mech_box.connect("focus_entered",on_look_at_mech.bind(mech))
			mech_box.connect("mouse_entered",on_look_at_mech.bind(mech))
			#mech_box.connect("mouse_exited",on_pick_mech.bind(mech))
			#mech_box.connect("focus_exited",on_pick_mech.bind(mech))
		else:
			mech_box.disabled = true;

		$MECH_LIST/MECH_BUTTONS.add_child(mech_box);

func on_look_at_mech(mech:Mech):
	STATE.CURRENT_MECH_ID = mech.ID
	DATA_TO_UI.display_node_for_mech(STATE.CURRENT_MECH_ID,$Mech_SubViewportContainer/SubViewportContainer/SubViewport/MECHS_NODE);
	#$Mech_SubViewportContainer/Button.show()
	#$Mech_SubViewportContainer/Button/MECH_BOX.hide()
	DATA_TO_UI.build_mech_box($Mech_SubViewportContainer/MECH_BOX,mech)
	$AnimationPlayer.play("step_1")
	#$Part_SubViewportContainer.show()
	$Mech_SubViewportContainer.show()
	#$Part_SubViewportContainer/Button.show()
	#$Part_SubViewportContainer/Button/PART_BOX.hide()
	$Mech_SubViewportContainer/SELL_MECH_BUTTON.hide()
	$Mech_SubViewportContainer/BUY_MECH_BUTTON.hide()

func on_pick_mech(mech:Mech):
	STATE.CURRENT_MECH_ID = mech.ID
	DATA_TO_UI.display_node_for_mech(STATE.CURRENT_MECH_ID,$Mech_SubViewportContainer/SubViewportContainer/SubViewport/MECHS_NODE);
	#$Mech_SubViewportContainer/Button.show()
	#$Mech_SubViewportContainer/Button/MECH_BOX.hide()
	DATA_TO_UI.build_mech_box($Mech_SubViewportContainer/MECH_BOX,mech)
	$AnimationPlayer.play("step_1")
	$Part_SubViewportContainer.show()
	$Mech_SubViewportContainer.show()
	$Part_SubViewportContainer/Button.show()
	$Part_SubViewportContainer/Button/PART_BOX.hide()
	$Mech_SubViewportContainer/SELL_MECH_BUTTON.hide()
	$Mech_SubViewportContainer/BUY_MECH_BUTTON.hide()
	#$Mech_SubViewportContainer/Button.show()
	#$Mech_SubViewportContainer/Button/MECH_BOX.hide()
	$EQUIP_BUTTON.show()
	$CANCEL_BUTTON.show()

	$SELECT_MECH.hide()
	$EQUIP_PART.show()
	$TextureRect.show()
	$TextureRect2.show()
	$TextureRect3.show()
	$MECH_LIST.hide()
	#ON_CANCEL.call()

func on_equip_button_pressed():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.attached_to_mech_id = STATE.CURRENT_MECH_ID;
	current_part.status = ENUMS.PART_STATUS.EQUIPT;
	DATA.save_parts_to_user_data()
	PARTS_MENU.show_parts()
	self.hide();

func on_visibility_changed():
	if(self.visible == true):
		init_children()
