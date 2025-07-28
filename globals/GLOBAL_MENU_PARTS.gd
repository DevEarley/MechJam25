extends Node

var PART_BOX_PREFAB = preload("res://prefabs/part_box.tscn")
func show_parts():
	var PART_NODES =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewport/PARTS_NODE")
	var PART_BUTTONS = STATE.PARTS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")
	for child in PART_BUTTONS.get_children():
		child.queue_free()

	for part:Part in STATE.PARTS:
		var part_button = PART_BOX_PREFAB.instantiate()
		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		part_button.get_node("THEME").text = "%s"%part.theme
		part_button.get_node("FLAVOR").text = "%s"%part.flavor
		part_button.get_node("COST").text = "%s"%part.cost
		part_button.get_node("RECYCLE_POINTS").text = "%s"%part.recycle_points
		part_button.get_node("SELLING_PRICE").text = "%s"%part.selling_price
		part_button.get_node("BETTER_ODDS").text = "%s"%part.better_odds
		part_button.get_node("CRITERIA_FOR_BETTER_ODDS").text = "%s"%part.criteria_for_better_odds
		part_button.get_node("WORSE_ODDS").text = "%s"%part.worse_odds
		part_button.get_node("CRITERIA_FOR_WORSE_ODDS").text = "%s"%part.criteria_for_worse_odds
		part_button.get_node("STATUS").text = "%s"%part.status
		part_button.get_node("TYPE").text = "%s"%part.type
		part_button.connect("pressed",on_part_pressed.bind(part.ID))
		PART_BUTTONS.add_child(part_button)

func on_part_pressed(id:int):
	var PART_NODES =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewport/PARTS_NODE")
	var ANIMATOR:AnimationPlayer =  STATE.PARTS_MENU_CANVAS.get_node("SubViewportContainer/SubViewport/AnimationPlayer")

	if(ANIMATOR.current_animation!= "spin_up"):
		ANIMATOR.play("spin_up")
	else:
		ANIMATOR.play("spin")

	for _node in PART_NODES.get_children():
		_node.hide()
	match(id):
			0:
				PART_NODES.get_node("HEAT_BLADE").show();
			1:
				PART_NODES.get_node("ICE_BLADE").show();
			2:
				PART_NODES.get_node("BLUE_NUT").show();
			3:
				PART_NODES.get_node("RED_NUT").show();
