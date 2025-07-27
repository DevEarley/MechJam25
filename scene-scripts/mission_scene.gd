extends Node
class_name MissionsMenu


#@onready var BASE_MISSION_LIST  = load("res://data/mission_data.cfg")
#@onready var MISSION_BOX_PREFAB : PackedScene = load("res://prefabs/mission_box.tscn")
#
#func _save_missions():
	#pass #not done yet
#
#func _ready() -> void:
	#_ready_load_missions()
#
#func _ready_load_missions():
	#var config_missions = ConfigFile.new()
#
	#var err = await config_missions.load("user://mission_data.cfg")
	#if err == 7: #if file doesn't exist, load base mission list, and then save it user side
		#config_missions.load("res://data/mission_data.cfg")
		#config_missions.save("user://mission_data.cfg")
#
	#var mission_list = config_missions.get_sections()
	#for i in mission_list.size():
		#var mission_box = MISSION_BOX_PREFAB.instantiate()
#
		#mission_box.get_node("MissionID").text = str(config_missions.get_value(mission_list[i],"mission_ID"))
		#mission_box.get_node("MissionTitle").text = str(config_missions.get_value(mission_list[i],"mission_TITLE"))
		#mission_box.get_node("FlavorText").text = str(config_missions.get_value(mission_list[i],"mission_FLAVOR_TEXT"))
		#mission_box.get_node("Odds").text = str(config_missions.get_value(mission_list[i],"mission_ODDS_SUCCESS"))
		#mission_box.get_node("Environment").text = str(config_missions.get_value(mission_list[i],"mission_ENVIRONMENT"))
		#mission_box.get_node("AllowedMechs").text = str(config_missions.get_value(mission_list[i],"mission_OK_MECHS"))
		#mission_box.get_node("Location").text = str(config_missions.get_value(mission_list[i],"mission_LOCATION"))
		#mission_box.get_node("Result").text = str(config_missions.get_value(mission_list[i],"mission_RESULT"))
