extends Node


#mission_0_ID=1
#mission_0_NAME="Find Jill's Mech"
#mission_0_FLAVOR="Jack wants to find Jill. He needs you to set his location to her last known whereabouts."
#mission_0_FLAVOR_TYPE=2 #maps to a "rescue" icon.
#misison_0_ODDS_SUCCESS = 1 #1/ODDS so in this case 1/1 = 1, or 100% success rate
#mission_0_ENVIRONMENT=1 #maps to an enum
#mission_0_MECH_TYPES=[0,1] #only these types are allowed for this misison, regardless of environment
#mission_0_LOCATION=0 #location_ID
#mission_0_TIME_TO_COMPLETE=[DATETIME] 
#mission_0_RESULT=0 #enum 0=not started,1=success,2=failed

@onready var BASE_MISSION_LIST  = load("res://data/mission_data.cfg")
@onready var MISSION_DISPLAY : PackedScene = load("res://prefabs/mission_box.tscn")

func _save_missions():
	pass #not done yet

func _ready() -> void:
	_ready_load_missions()
	
func _ready_load_missions():
	var config_missions = ConfigFile.new()
	
	var err = await config_missions.load("user://mission_data.cfg")
	if err == 7: #if file doesn't exist, load base mission list, and then save it user side
		config_missions.load("res://data/mission_data.cfg")
		config_missions.save("user://mission_data.cfg")

	var mission_list = config_missions.get_sections()
	for i in mission_list.size():
		var temp = MISSION_DISPLAY.instantiate()
		#NOTE this is just a temporary way to display the information
		$"../VBoxContainer".add_child(temp)
		temp.get_child(0).text = str(config_missions.get_value(mission_list[i],"mission_ID"))
		temp.get_child(1).text = str(config_missions.get_value(mission_list[i],"mission_TITLE"))
		temp.get_child(2).text = str(config_missions.get_value(mission_list[i],"mission_FLAVOR_TEXT"))
		temp.get_child(3).text = str(config_missions.get_value(mission_list[i],"mission_ODDS_SUCCESS"))
		temp.get_child(4).text = str(config_missions.get_value(mission_list[i],"mission_ENVIRONMENT"))
		temp.get_child(5).text = str(config_missions.get_value(mission_list[i],"mission_OK_MECHS"))
		temp.get_child(6).text = str(config_missions.get_value(mission_list[i],"mission_RESULT"))
