extends Button



func _on_pressed() -> void:
	self.disabled = false
	if($PILOT_BOX.visible):
		$PILOT_BOX.hide()
	else:
		MISSIONS_MENU.hide_all_menus()
		$PILOT_BOX.show()
		var current_pilot:Pilot = LINQ.First(STATE.PILOTS, func (pilot:Pilot):
			return pilot.ID == STATE.CURRENT_PILOT_ID);
		DATA_TO_UI.build_pilot_box($PILOT_BOX,current_pilot)
		#DATA_TO_UI.display_node_for_pilot(STATE.CURRENT_PILOT_ID,$PILOT_BOX/SubViewportContainer/SubViewport/PILOTS_NODE)
