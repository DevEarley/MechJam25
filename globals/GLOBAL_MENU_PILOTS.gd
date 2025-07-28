extends Node

var PILOT_BOX_PREFAB = preload("res://prefabs/pilot_box.tscn")
func show_pilots():
	var PILOT_BUTTONS = STATE.PILOT_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in PILOT_BUTTONS.get_children():
		child.queue_free()

	for pilot:Pilot in STATE.PILOTS:
		var pilot_button = PILOT_BOX_PREFAB.instantiate()
		pilot_button.get_node("ID").text = "%s"%pilot.ID
		pilot_button.get_node("NAME").text = "%s"%pilot.name
		pilot_button.get_node("COST").text = "%s"%pilot.cost
		pilot_button.get_node("FLAVOR").text = "%s"%pilot.flavor
		pilot_button.get_node("STATUS").text = "%s"%pilot.status
		pilot_button.get_node("THEME").text = "%s"%pilot.theme
		#pilot_button.get_node("MISSION").text = "%s"%pilot.mission
		pilot_button.get_node("BETTER_ODDS").text = "%s"%pilot.better_odds
		pilot_button.get_node("CRITERIA_FOR_BETTER_ODDS").text = "%s"%pilot.criteria_for_better_odds
		pilot_button.get_node("WORSE_ODDS").text = "%s"%pilot.worse_odds
		pilot_button.get_node("CRITERIA_FOR_WORSE_ODDS").text = "%s"%pilot.criteria_for_worse_odds

		PILOT_BUTTONS.add_child(pilot_button)
