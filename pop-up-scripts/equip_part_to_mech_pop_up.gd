extends CanvasLayer

var MECH_BOX_PREFAB = preload("res://prefabs/mech_box_small.tscn")
var BUTTON = preload("res://prefabs/left-hand-button.tscn");
var ON_CANCEL:Callable



func _ready():
	$CONFIRM_MECH.connect("pressed",on_confirm_mech)
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
	$CONFIRM_MECH.show()
	$CONFIRM_MECH.disabled = true;
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
		var mech_button:Button = BUTTON.instantiate()
		mech_button.custom_minimum_size = Vector2(640,120)
		var mech_box = DATA_TO_UI.build_mech_box_small(MECH_BOX_PREFAB, mech)
		mech_button.add_child(mech_box)
		mech_button.connect("pressed",on_pick_mech.bind(mech))
		$MECH_LIST/MECH_BUTTONS.add_child(mech_button);

func on_pick_mech(mech:Mech):
	$CONFIRM_MECH.disabled = false;
	STATE.CURRENT_MECH_ID = mech.ID
	DATA_TO_UI.display_node_for_mech(STATE.CURRENT_MECH_ID,$Mech_SubViewportContainer/SubViewportContainer/SubViewport/MECHS_NODE);
	$Mech_SubViewportContainer/Button.show()
	$Mech_SubViewportContainer/Button/MECH_BOX.hide()

func on_confirm_mech():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.status = ENUMS.PART_STATUS.EQUIPT;
	current_part.attached_to_mech_id = STATE.CURRENT_MECH_ID
	$AnimationPlayer.play("step_1")
	$Part_SubViewportContainer.show()
	$Mech_SubViewportContainer.show()
	$Part_SubViewportContainer/Button.show()
	$Part_SubViewportContainer/Button/PART_BOX.hide()
	$Mech_SubViewportContainer/Button.show()
	$Mech_SubViewportContainer/Button/MECH_BOX.hide()
	$EQUIP_BUTTON.show()
	$CANCEL_BUTTON.show()
	$CONFIRM_MECH.hide()
	$SELECT_MECH.hide()
	$EQUIP_PART.show()
	$TextureRect.show()
	$TextureRect2.show()
	$TextureRect3.show()
	$MECH_LIST.hide()
	ON_CANCEL.call()

func on_equip_button_pressed():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.attached_to_mech_id = STATE.CURRENT_MECH_ID;
	DATA.save_parts_to_user_data()
	PARTS_MENU.show_parts()
	self.hide();

func on_visibility_changed():
	if(self.visible == true):
		init_children()
