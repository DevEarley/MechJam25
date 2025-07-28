extends Node
var MECH_BOX_PREFAB = preload("res://prefabs/mech_box.tscn")
func show_mechs():
	var MECH_BUTTONS = STATE.MECH_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in MECH_BUTTONS.get_children():
		child.queue_free()

	for mech:Mech in STATE.MECHS:
		var mech_button = MECH_BOX_PREFAB.instantiate()
		mech_button.get_node("ID").text = "%s"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name
		mech_button.get_node("FLAVOR").text = "%s"%mech.flavor
		mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "%s"%mech.compatible_environments
		mech_button.get_node("COST").text = "%s"%mech.cost
		mech_button.get_node("TYPE").text = "%s"%mech.type
		#mech_button.get_node("MISSION").text = "%s"%mech.mission
		mech_button.get_node("SELLING_PRICE").text = "%s"%mech.selling_price
		mech_button.get_node("BASE_HEALTH").text = "%s"%mech.base_health
		mech_button.get_node("CURRENT_HEALTH").text = "%s"%mech.current_health
		mech_button.get_node("STATUS").text = "%s"%mech.status
		MECH_BUTTONS.add_child(mech_button)
