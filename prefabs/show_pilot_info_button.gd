extends Button

var BUTTON_PREFAB = preload("res://prefabs/left-hand-button.tscn")

func _on_pressed() -> void:
	self.disabled = false
	if($PILOT_BOX.visible):
		$PILOT_BOX.hide()
	else:
		MISSIONS_MENU.hide_all_menus()
		if(STATE.CURRENT_PILOT_ID == -1):
			$PILOT_LIST.show()
			for pilot in STATE.PILOTS:
				var new_button = BUTTON_PREFAB.instantiate()
				new_button.text = "%s [%s]"%[pilot.name,get_status_text_for_pilot(pilot)]
				if(pilot.status == ENUMS.PILOT_STATUS.HIRED):
					new_button.connect("pressed",on_pick_pilot.bind(pilot))
					new_button.disabled = false
				else:
					new_button.disabled = true

				$PILOT_LIST/Control/ScrollContainer/VBoxContainer.add_child(new_button);
		else:
			$PILOT_BOX.show()
			var current_pilot:Pilot = LINQ.First(STATE.PILOTS, func (pilot:Pilot):
				return pilot.ID == STATE.CURRENT_PILOT_ID);
			DATA_TO_UI.build_pilot_box($PILOT_BOX,current_pilot)
			#DATA_TO_UI.display_node_for_pilot(STATE.CURRENT_PILOT_ID,$PILOT_BOX/SubViewportContainer/SubViewport/PILOTS_NODE)


static func get_status_text_for_pilot(pilot:Pilot):
	match(pilot.status):
		ENUMS.PILOT_STATUS.FOR_HIRE:
			return "UNAVAILABLE";

		ENUMS.PILOT_STATUS.HIRED:
			return "AVAILABLE";

		ENUMS.PILOT_STATUS.ON_MISSION:
			return "UNAVAILABLE";

		ENUMS.PILOT_STATUS.DEAD:
			return "UNAVAILABLE";

func on_pick_pilot(pilot:Pilot):

	SFX.play_click_sound()
	if(pilot.status == ENUMS.PILOT_STATUS.HIRED):
		pilot.status = ENUMS.PILOT_STATUS.ON_MISSION #don't save yet
		STATE.CURRENT_PILOT_ID = pilot.ID;
		MISSIONS_MENU.hide_all_menus()
		MISSIONS_MENU.MISSION_BOX.get_node("PILOT_BUTTON").disabled = false;
		MISSIONS_MENU.MISSION_BOX.get_node("PILOT_BUTTON").text = pilot.name;
		if(STATE.CURRENT_MECH_ID!=-1):
			MISSIONS_MENU.MISSION_BOX.get_node("START_MISSION").disabled = false
			var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.ID==STATE.CURRENT_MECH_ID);
			pilot.mech_id = mech.ID
		MISSIONS_MENU.on_mission_pressed(STATE.CURRENT_MISSION)
