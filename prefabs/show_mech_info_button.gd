extends Button

var BUTTON_PREFAB = preload("res://prefabs/left-hand-button.tscn")

func _on_pressed() -> void:
	self.disabled = false
	if($MECH_BOX.visible):
		$MECH_BOX.hide()
	else:
		MISSIONS_MENU.hide_all_menus()
		if(STATE.CURRENT_MECH_ID == -1):
			for child in $MECH_LIST/Control/ScrollContainer/VBoxContainer.get_children():
				child.queue_free()
			$MECH_LIST.show()
			MISSIONS_MENU.MISSION_BOX.get_node("PILOT_BUTTON").hide()
			for mech in STATE.MECHS:
				var new_button:Button = BUTTON_PREFAB.instantiate()
				new_button.text = "%s\n[%s]"%[mech.name,get_status_text_for_mech(mech)]
				new_button.custom_minimum_size = Vector2(330,0)
				if(mech.status != ENUMS.MECH_STATUS.IN_GARAGE):
					new_button.disabled = true;
				else:
					new_button.connect("pressed",on_pick_mech.bind(mech))
					new_button.connect("focus_entered",show_mech_info.bind(mech))
					new_button.connect("mouse_entered",show_mech_info.bind(mech))
					new_button.connect("focus_exited",hide_mech_info)
					new_button.connect("mouse_exited",hide_mech_info)
				$MECH_LIST/Control/ScrollContainer/VBoxContainer.add_child(new_button);

		else:
			var current_mech:Mech = LINQ.First(STATE.MECHS, func (mech:Mech):
				return mech.ID == STATE.CURRENT_MECH_ID);
			show_mech_info(current_mech);

func hide_mech_info():
	$MECH_BOX.hide();

func show_mech_info(mech):
		$MECH_BOX.show()
		DATA_TO_UI.build_mech_box($MECH_BOX,mech)
		if($MECH_BOX.has_node("SubViewportContainer")):
			DATA_TO_UI.display_node_for_mech(mech.ID,$MECH_BOX/SubViewportContainer/SubViewport/MECHS_NODE)

static func get_status_text_for_mech(mech:Mech):
	match(mech.status):
		ENUMS.MECH_STATUS.FOR_SALE:
			return "UNAVAILABLE";

		ENUMS.MECH_STATUS.IN_GARAGE:
			return "AVAILABLE";

		ENUMS.MECH_STATUS.ON_MISSION:
			return "UNAVAILABLE";

		ENUMS.MECH_STATUS.NOT_AVAILABLE:
			return "UNAVAILABLE";

func on_pick_mech(mech:Mech):
	if(mech.status == ENUMS.MECH_STATUS.IN_GARAGE):
		mech.status = ENUMS.MECH_STATUS.ON_MISSION #don't save yet
		mech.mission_id = STATE.CURRENT_MISSION_ID
		STATE.CURRENT_MECH_ID = mech.ID;
		MISSIONS_MENU.hide_all_menus()
		MISSIONS_MENU.MISSION_BOX.get_node("MECH").disabled = false;
		MISSIONS_MENU.MISSION_BOX.get_node("MECH").text = mech.name;
		MISSIONS_MENU.MISSION_BOX.get_node("PILOT_BUTTON").disabled = false;
		if(STATE.CURRENT_PILOT_ID!=-1):
			MISSIONS_MENU.MISSION_BOX.get_node("START_MISSION").disabled = false
			var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.ID==STATE.CURRENT_PILOT_ID);
			pilot.mech_id=mech.ID;
		MISSIONS_MENU.MISSION_BOX.get_node("PILOT_BUTTON").show()
		MISSIONS_MENU.hide_all_menus()
