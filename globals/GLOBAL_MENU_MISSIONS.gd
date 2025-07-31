extends Node
var MISSION_BOX_PREFAB = preload("res://prefabs/mission_box_small.tscn")
var MISSION_BUTTONS
func show_missions():
	MISSION_BUTTONS = STATE.MISSIONS_MENU_CANVAS.get_node("SCROLLABLE/BUTTONS")

	for child in MISSION_BUTTONS.get_children():
		child.queue_free()

	for mission:Mission in STATE.MISSIONS:
		var mission_button = MISSION_BOX_PREFAB.instantiate()
		mission_button.get_node("ID").text = "%s"%mission.ID
		mission_button.get_node("NAME").text = "%s"%mission.name
		mission_button.get_node("STATUS").text = "%s"%mission.status
		mission_button.connect("pressed",on_mission_pressed.bind(mission));
		MISSION_BUTTONS.add_child(mission_button)

func on_back_to_start_menu():
	STATE.START_MENU_CANVAS.show()
	STATE.MISSIONS_MENU_CANVAS.hide()

func on_back_to_mission_list():
	MISSION_BUTTONS.show();
	STATE.MAP_BG.show()
	STATE.ON_BACK_BUTTON_PRESSED =on_back_to_start_menu

func on_mission_pressed(mission:Mission):
	STATE.ON_BACK_BUTTON_PRESSED =on_back_to_mission_list
	MISSION_BUTTONS.hide();
	STATE.MAP_BG.hide()
	MAP.ANIMATOR.stop()
	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	MAP.CAMERA.global_position = location.map_position
	MAP.CAMERA.rotation = Vector3(-PI/2,0,0)
	MAP.CURSOR.global_position = Vector3(location.map_position.x,MAP.CURSOR.global_position.y,location.map_position.z)
	pass
