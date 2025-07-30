extends Button



func _on_pressed() -> void:
	self.disabled = false
	$MECH_BOX.show()
	var current_mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
		return mech.ID == STATE.CURRENT_MECH_ID);
	DATA_TO_UI.build_mech_box($MECH_BOX,current_mech)
