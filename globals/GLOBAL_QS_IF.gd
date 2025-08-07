extends Node

func if_predicate(string_of_predicate:String)->bool:
	match(string_of_predicate.to_lower()):
		"rng_bool":
			return RNG.Next_bool()
		"working for benefactor":
			return STATE.BENEFACTOR_IS_GIVING_YOU_MONEY
		"working for rose":
			return STATE.DT_ROSE_IS_GIVING_YOU_MONEY
		"racing with jack and jill":
			return STATE.YOU_ARE_RACING_WITH_JACK_AND_JILL
	return false;
