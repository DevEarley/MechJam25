extends "res://scripts/generic_button.gd"
var part_button_scene = preload("res://prefabs/part-button.tscn")
@export var VBOX:VBoxContainer
func _on_pressed() -> void:
	if($PART_LIST.visible):
		$PART_LIST.hide()
	else:

		MISSIONS_MENU.hide_all_menus()

		$PART_LIST.show()
		VBOX.show()

		for child in VBOX.get_children():
			child.queue_free()
		for part:Part in STATE.PARTS:
			if(part.attached_to_mech_id == STATE.CURRENT_MECH_ID && part.status == ENUMS.PART_STATUS.EQUIPT):
				var part_button = part_button_scene.instantiate()
				part_button.text = part.name;
				DATA_TO_UI.build_part_button(part_button,part)
				part_button.connect("pressed",_on_part_pressed.bind(part,part_button))
				VBOX.add_child(part_button)

func _on_part_pressed(part:Part,button) -> void:
	for child in VBOX.get_children():
		var child_PART_BOX  = child.get_node("PART_BOX")
		child_PART_BOX.hide()

	var PART_BOX  = button.get_node("PART_BOX")
	if(PART_BOX.visible):
		PART_BOX.hide()
	else:
		PART_BOX.show()
		DATA_TO_UI.build_part_box(PART_BOX,part)
