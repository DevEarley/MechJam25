extends CanvasLayer

var MECH_BOX_PREFAB = preload("res://prefabs/mech_box.tscn")
var BUTTON = preload("res://prefabs/left-hand-button.tscn");

func _ready():
	$CONFIRM_MECH.connect("pressed",on_confirm_mech)
	$EQUIP_BUTTON.connect("pressed",on_equip_button_pressed)
	connect("visibility_changed",on_visibility_changed)
	init_children()

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
		mech_button.custom_minimum_size = Vector2(640,220)
		var mech_box = DATA_TO_UI.build_mech_box(MECH_BOX_PREFAB, mech)
		mech_button.add_child(mech_box)
		mech_button.connect("pressed",on_pick_mech.bind(mech))
		$MECH_LIST/MECH_BUTTONS.add_child(mech_button);

func on_pick_mech(mech:Mech):
	$CONFIRM_MECH.disabled = false;

	STATE.CURRENT_MECH_ID = mech.ID

func on_confirm_mech():

	$AnimationPlayer.play("step_1")
	$Part_SubViewportContainer.show()
	$Mech_SubViewportContainer.show()
	$EQUIP_BUTTON.show()
	$CANCEL_BUTTON.show()
	$CONFIRM_MECH.hide()
	$SELECT_MECH.hide()
	$EQUIP_PART.show()
	$TextureRect.show()
	$TextureRect2.show()
	$TextureRect3.show()
	$MECH_LIST.hide()

func on_equip_button_pressed():
	var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
		return part.ID == STATE.CURRENT_PART_ID);
	current_part.attached_to_mech_id = STATE.CURRENT_MECH_ID;
	DATA.save_parts_to_user_data()
	self.hide();

func on_visibility_changed():
	if(self.visible == true):
		init_children()
