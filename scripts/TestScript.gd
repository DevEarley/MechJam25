extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var test_conf = ConfigFile.new()
	var slotindex = 1
	var index = 1
	var DECK_ID = 3
	test_conf.set_value("SAVESLOT%s"%slotindex,"deck%s_ID"%index,DECK_ID)
	
	slotindex = 2
	index = 2
	DECK_ID = 4
	test_conf.set_value("SAVESLOT%s"%slotindex,"deck%s_ID"%index,DECK_ID)

	print("SAVESLOT%s"%slotindex,"deck%s_ID"%index,DECK_ID)
	test_conf.save("user://test/testSaving")
	
	print(test_conf.get_sections())
	
	for i in test_conf.get_sections().size():
		print(test_conf.get_sections()[i])
		print(test_conf.get_section_keys(test_conf.get_sections()[i]))
