extends Node

func if_predicate(string_of_predicate:String)->bool:
	match(string_of_predicate.to_lower()):
		"rng_bool":
			return RNG.Next_bool()
	return false;
