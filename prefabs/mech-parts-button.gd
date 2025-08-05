extends "res://scripts/generic_button.gd"
var part_button_scene = preload("res://prefabs/part-button.tscn")
@export var VBOX:VBoxContainer

func _on_pressed() -> void:
	if($BOX.visible):
		$BOX.hide()
	else:


		$BOX.show()
		VBOX.show()

		for child in VBOX.get_children():
			child.queue_free()
		for part:Part in STATE.PARTS:
			if(part.attached_to_mech_id == STATE.CURRENT_MECH_ID && part.status == ENUMS.PART_STATUS.EQUIPT):
				var part_button = part_button_scene.instantiate()
				part_button.text = part.name;
				DATA_TO_UI.build_part_button(part_button,part)
				VBOX.add_child(part_button)
