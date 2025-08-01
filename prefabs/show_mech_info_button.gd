extends Button



func _on_pressed() -> void:
	self.disabled = false
	if($MECH_BOX.visible):
		$MECH_BOX.hide()
	else:

		MISSIONS_MENU.hide_all_menus()
		$MECH_BOX.show()
		var current_mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
			return mech.ID == STATE.CURRENT_MECH_ID);
		DATA_TO_UI.build_mech_box($MECH_BOX,current_mech)
		if($MECH_BOX.has_node("SubViewportContainer")):
			DATA_TO_UI.display_node_for_mech(STATE.CURRENT_MECH_ID,$MECH_BOX/SubViewportContainer/SubViewport/MECHS_NODE)
