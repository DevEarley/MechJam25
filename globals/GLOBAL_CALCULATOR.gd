extends Node

func get_mission_bonus(mission:Mission)->int:

	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
	if(mech== null):return 0;
	var parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);

	var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	var bonus = 0;
	for part in parts:
		bonus += calculate_mission_bonus_for_part(part,mission,pilot,location,mech);
	if(pilot== null):return bonus;
	bonus += calculate_mission_bonus_for_pilot(parts,mission,pilot,location,mech);
	return bonus;

func get_return_bonus(mission:Mission)->int:
	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
	if(mech == null):return 0

	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
	var parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);
	var bonus:int = 0;
	for part in parts:
		bonus += calculate_return_bonus_for_part(part,mission,pilot,location,mech);
	if(pilot == null):return bonus
	bonus += calculate_return_bonus_for_pilot(parts,mission,pilot,location,mech);
	return bonus;

func calculate_mission_bonus_for_part(part:Part,mission:Mission,pilot:Pilot,location:Location, mech:Mech)->int:
	match(part.criteria_for_mission_odds):
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_0:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_1:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_2:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_3:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_4:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_5:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_6:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_7:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_8:
			return part.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_9:
			return part.mission_odds;
	return 3;

func calculate_mission_bonus_for_pilot(parts:Array[Part],mission:Mission,pilot:Pilot,location:Location, mech:Mech)->int:
	match(pilot.criteria_for_mission_odds):
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_0:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_1:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_2:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_3:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_4:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_5:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_6:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_7:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_8:
			return pilot.mission_odds;
		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_9:
			return pilot.mission_odds;
	return 3;

func calculate_return_bonus_for_part(part:Part,mission:Mission,pilot:Pilot,location:Location, mech:Mech)->int:
	match(part.criteria_for_returning_odds):
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_0:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_1:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_2:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_3:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_4:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_5:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_6:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_7:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_8:
			return part.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_9:
			return part.returning_odds;
	return 3;

func calculate_return_bonus_for_pilot(parts:Array[Part],mission:Mission,pilot:Pilot,location:Location, mech:Mech)->int:
	match(pilot.criteria_for_returning_odds):
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_0:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_1:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_2:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_3:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_4:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_5:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_6:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_7:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_8:
			return pilot.returning_odds;
		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_9:
			return pilot.returning_odds;
	return 3;
func print_rng_and_odds(rng_number,odds):
	print("RNG: %s | out of %s | ODS: %s | 1/RNG: %s | 1/ODDS: %s" % [rng_number,RNG.RNG_COUNT,odds,rng_number/ RNG.RNG_COUNT,1.0/odds] )

func has_passed_current_mission():

	var mission_odds = STATE.CURRENT_MISSION.one_over_odds_for_mission;
	var return_odds = STATE.CURRENT_MISSION.one_over_odds_for_returning;
	var mission_bonus = get_mission_bonus(STATE.CURRENT_MISSION)
	var return_bonus= get_return_bonus(STATE.CURRENT_MISSION)
	var completed_mission = false
	var returned = false

	var rng_number = RNG.Next()
	var rng_value = rng_number/ RNG.RNG_COUNT
	if(mission_odds + mission_bonus>0.0):
		mission_odds += mission_bonus
		completed_mission =abs (1.0/mission_odds) < rng_value
		print_rng_and_odds(rng_number,mission_odds)
	else:
		var calculated_odds =1.0-abs ((1.0+mission_bonus)/mission_odds)
		completed_mission =calculated_odds < rng_value
		print("RNG: %s | out of %s | ODS: %s | 1/RNG: %s | 1/ODDS: %s" % [rng_number,RNG.RNG_COUNT,mission_odds,rng_value,calculated_odds] )

	var rng_number_2 = RNG.Next()
	var rng_value_2 = rng_number_2/ RNG.RNG_COUNT
	if(return_odds+return_bonus>0.0):
		return_odds+= return_bonus
		returned = abs(1.0/return_odds) < rng_value_2
		print_rng_and_odds(rng_number_2,return_odds)
	else:
		var calculated_odds = 1.0-abs ((1.0+return_bonus)/return_odds)
		returned = calculated_odds< rng_value_2
		print("RNG: %s | out of %s | ODS: %s | 1/RNG: %s | 1/ODDS: %s" % [rng_number,RNG.RNG_COUNT,return_odds,rng_number/ RNG.RNG_COUNT,calculated_odds] )

	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech):return mech.mission_id == STATE.CURRENT_MISSION_ID)
	var pilot:Pilot = LINQ.First(STATE.PILOTS,func ( pilot:Pilot ):return pilot.mech_id == mech.ID)

	if(completed_mission==false):
		mech.current_health -=1
	if(returned==false):
		mech.current_health -=1
	mech.current_health-=1
	mech.mission_id = -1
	pilot.mech_id = -1
	if(mech.current_health<=0 ):
		mech.status = ENUMS.MECH_STATUS.NOT_AVAILABLE
		pilot.status = ENUMS.PILOT_STATUS.DEAD
		DATA.save_everything()
		return false;
	elif(completed_mission== true):
		mech.status = ENUMS.MECH_STATUS.IN_GARAGE
		pilot.status = ENUMS.PILOT_STATUS.HIRED
		DATA.save_everything()
		return true;

	else:
		mech.status = ENUMS.MECH_STATUS.IN_GARAGE
		pilot.status = ENUMS.PILOT_STATUS.HIRED
		DATA.save_everything()
		return false;
