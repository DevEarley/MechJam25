extends Node

func get_mission_bonus(mission:Mission)->int:

	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
	if(mech== null):return 0;
	var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
	if(pilot== null):return 0;
	var parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);

	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	var bonus = 0;
	for part in parts:
		bonus += calculate_mission_bonus_for_part(part,mission,pilot,location,mech);
	bonus += calculate_mission_bonus_for_pilot(parts,mission,pilot,location,mech);
	return bonus;

func get_return_bonus(mission:Mission)->int:
	var mech:Mech = LINQ.First(STATE.MECHS,func (mech:Mech): return mech.mission_id==mission.ID);
	if(mech == null):return 0
	var pilot:Pilot = LINQ.First(STATE.PILOTS,func (pilot:Pilot): return pilot.mech_id==mech.ID);
	if(pilot == null):return 0

	var location:Location = LINQ.First(STATE.LOCATIONS,func (location:Location): return location.ID==mission.location_id);
	var parts = STATE.PARTS.filter(func (part:Part): return part.attached_to_mech_id==mech.ID && part.status == ENUMS.PART_STATUS.EQUIPT);
	var bonus = 0;
	for part in parts:
		bonus += calculate_return_bonus_for_part(part,mission,pilot,location,mech);
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

func has_passed_current_mission():
	return true;
