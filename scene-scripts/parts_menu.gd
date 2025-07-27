extends Node
class_name PartsMenu

func _ready_load_or_create_user_parts():
	var slot_index = 1
	var data_user = ConfigFile.new()
	var data_res = ConfigFile.new()
	var data_user_err = await data_user.load("user://parts.cfg")
	var data_res_err = await data_res.load("res://data/parts_data.cfg")
	if(data_user_err == 7 && data_res_err != 7):
		var number_of_parts:int = data_res.get_value("DEFAULT","NUMBER_OF_PARTS")
		for part_index in number_of_parts:
			var new_part
			STATE.PARTS.push_back(new_part)
		create_user_parts()
	else:
		var index = 0;
		var number_of_parts:int = data_res.get_value("DEFAULT","NUMBER_OF_PARTS")

		print("number_of_parts : %s" % number_of_parts)
		#for part_index in number_of_parts:
			#var deck = Part.new();
			#deck.DECK_ID = "%s"%config_player_decks.get_value("SAVESLOT%s"%slotindex,"deck%s_ID"%index)
			#deck.DeckName = config_player_decks.get_value("SAVESLOT%s"%slotindex,"deck%s_NAME"%index,deck.DeckName)
			#deck.CardNumbers = config_player_decks.get_value("SAVESLOT%s"%slotindex,"deck%s_NUMBERS"%index,deck.CardNumbers)
			#deck.DeckStyle = config_player_decks.get_value("SAVESLOT%s"%slotindex,"deck%s_STYLE"%index,deck.DeckStyle)
			#STATE.DECKS.push_back(deck);
			#index+=1;
			#
func create_user_parts():
	var config_player_decks = ConfigFile.new()
	#var slot_index = SAVE_SLOTS.get_index_for_chosen_slot();
	#var index = 0;
	#config_player_decks.set_value("SAVESLOT%s"%slot_index,"number_of_decks",STATE.DECKS.size())
	#for deck:Deck in STATE.DECKS:
		#config_player_decks.set_value("SAVESLOT%s"%slotindex,"deck%s_ID"%index,deck.DECK_ID)
		#config_player_decks.set_value("SAVESLOT%s"%slotindex,"deck%s_NAME"%index,deck.DeckName)
		#config_player_decks.set_value("SAVESLOT%s"%slotindex,"deck%s_NUMBERS"%index,deck.CardNumbers)
		#config_player_decks.set_value("SAVESLOT%s"%slotindex,"deck%s_STYLE"%index,deck.DeckStyle)
		#config_player_decks.set_value("SAVESLOT%s"%slotindex,"deck%s_DICE"%index,deck.DICE_ID)
		#index+=1;
	#var err = config_player_decks.save("user://decks.cfg")
	#if err != OK:
		#print(err)
##[generic]
##
#number_of_decks=2
#
#deck_0_ID=1
#deck_0_NAME="Dawnfire"
#deck_0_NUMBERS=Array[int]([26, 59, 9, 60, 13, 55, 7])
#deck_0_STYLE=4
#
#deck_1_ID=2
#deck_1_NAME="Fae & Mages"
#deck_1_NUMBERS=Array[int]([16, 87, 85, 45, 2, 44, 6 ])
#deck_1_STYLE=1
#var err_2 = await res_missions.load("res://data/missions.cfg")
