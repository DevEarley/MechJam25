extends Node
var MISSION_BOX_PREFAB = preload("res://prefabs/mission_box.tscn")

func show_missions():
	var MISSION_BUTTONS = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")

	for child in MISSION_BUTTONS.get_children():
		child.queue_free()

	for mission:Mission in STATE.MISSIONS:
		var mission_button = MISSION_BOX_PREFAB.instantiate()
		mission_button.get_node("ID").text = "%s"%mission.ID
		mission_button.get_node("NAME").text = "%s"%mission.name
		mission_button.get_node("FLAVOR").text = "%s"%mission.flavor
		mission_button.get_node("ONE_OVER_ODDS_OF_SUCCESS").text = "%s"%mission.one_over_odds_of_success
		mission_button.get_node("ENVIRONMENT").text = "%s"%mission.environment
		mission_button.get_node("ALLOWED_MECH_TYPES").text = "%s"%mission.allowed_mech_types
		#mission_button.get_node("LOCATION_ID").text = "%s"%mission.mission
		#mission_button.get_node("MECH_ID").text = "%s"%mission.selling_price
		#mission_button.get_node("PILOT_ID").text = "%s"%mission.base_health
		mission_button.get_node("TIME_STARTED").text = "%s"%mission.time_started
		#mission_button.get_node("TIME_REMAINING").text = "%s"%mission.time_remaining
		mission_button.get_node("STATUS").text = "%s"%mission.status
		MISSION_BUTTONS.add_child(mission_button)
