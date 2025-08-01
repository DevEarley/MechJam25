extends Button



func _on_pressed() -> void:
	self.disabled = false
	if($PART_BOX.visible):
		$PART_BOX.hide()
	else:
		$PART_BOX.show()
		var current_part:Part = LINQ.First(STATE.PARTS, func (part:Part):
			return part.ID == STATE.CURRENT_PART_ID);
		DATA_TO_UI.build_part_box($PART_BOX,current_part)
