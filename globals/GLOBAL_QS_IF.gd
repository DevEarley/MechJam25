extends Node

func if_predicate(string_of_predicate:String)->bool:
	match(string_of_predicate.to_lower()):
		"rng_1_out_of_n":
			return false
		#"first time talking to strawbro": return SAVE_SLOTS.CURRENT.TALKED_TO_STRAWBRO_1 == false;
		#"do not have all the cards": return SAVE_SLOTS.CURRENT.COLLECTED_CARD_INDEXES.size() < 6;
		#"do have cards": return SAVE_SLOTS.CURRENT.COLLECTED_CARD_INDEXES.size() >= 6;
	return false;
