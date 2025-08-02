extends Node

var LOCATION_BOX_PREFAB = preload("res://prefabs/location_box.tscn")

func show_locations():
	var LOCATION_BUTTONS = STATE.LOCATION_SELECT_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in LOCATION_BUTTONS.get_children():
		child.queue_free()

	for location:Location in STATE.LOCATIONS:
		var location_button = LOCATION_BOX_PREFAB.instantiate()
		location_button.get_node("ID").text = "%s"%location.ID
		location_button.get_node("ENVIRONMENT").text = "%s"%location.environment
		location_button.get_node("FLAVOR").text = "%s"%location.flavor
		location_button.get_node("NAME").text = "%s"%location.name
		location_button.get_node("POSITION").text = "%s"%location.position
		location_button.get_node("MISSION").text = "%s"%location.mission
		location_button.get_node("MECH").text = "%s"%location.mech
		location_button.get_node("PILOT").text = "%s"%location.pilot
		LOCATION_BUTTONS.add_child(location_button)
