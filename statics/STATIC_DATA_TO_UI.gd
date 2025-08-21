class_name DATA_TO_UI

static func build_mech_box(mech_button, mech):
		if(mech_button.has_node("ID")):
			mech_button.get_node("ID").text =  DATA_TO_UI.insert_leading_zeros(mech.ID)
		mech_button.get_node("NAME").text = "%s"%mech.name

		if(mech_button.has_node("COMPATIBLE_ENVIRONMENT")):
			mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "";
			for environment in mech.compatible_environments:
				var results = get_environment_text_and_tint(environment)
				var environment_text= results[0]
				var environment_tint= results[1]
				mech_button.get_node("COMPATIBLE_ENVIRONMENT").text += "[%s]\n"%environment_text

		if(mech_button.has_node("TYPE")):
			mech_button.get_node("TYPE").text  = get_mech_type(mech)
		if(mech_button.has_node("BASE_HEALTH")):
			mech_button.get_node("BASE_HEALTH").text =  DATA_TO_UI.insert_leading_zeros(mech.base_health)

		if(mech_button.has_node("CURRENT_HEALTH")):
			mech_button.get_node("CURRENT_HEALTH").text = DATA_TO_UI.insert_leading_zeros(mech.current_health)

		if(mech_button.has_node("FLAVOR")):
			mech_button.get_node("FLAVOR").text = mech.flavor
		if(mech_button.has_node("STATUS")):
			mech_button.get_node("STATUS").text = get_status_text_for_mech(mech)
			match(mech.status):
				ENUMS.MECH_STATUS.IN_GARAGE:
					mech_button.get_node("STATUS").modulate = Color(0,1,170.0/255.0)

				ENUMS.MECH_STATUS.NOT_AVAILABLE:
					mech_button.get_node("STATUS").modulate = Color(338.0/255,0,93.0/255.0)
		return mech_button


static func build_small_part_box(BOX_PREFAB,part:Part):
		var part_button = BOX_PREFAB.instantiate()
		part_button.get_node("ID").text = DATA_TO_UI.insert_leading_zeros(part.ID)
		part_button.get_node("NAME").text = "%s"%part.name
		build_status(part_button,part)
		return part_button

static func build_status(part_button,part:Part):
		if(part_button.has_node("STATUS") == false): return;
		match(part.status):
			ENUMS.PART_STATUS.FOR_SALE:
				part_button.get_node("STATUS").text ="FOR SALE [%s CREDITS]"%part.cost
			ENUMS.PART_STATUS.PURCHASED:
				part_button.get_node("STATUS").modulate = Color(0,1,170.0/255.0)
				part_button.get_node("STATUS").text ="AVAILABLE"
			ENUMS.PART_STATUS.EQUIPT:
				part_button.get_node("STATUS").modulate = Color(0,1,170.0/255.0)
				var mech = LINQ.First(STATE.MECHS, func (mech:Mech):return mech.ID == part.attached_to_mech_id  && part.status == ENUMS.PART_STATUS.EQUIPT)
				part_button.get_node("STATUS").text ="EQUIPT TO %s"% mech.name
			ENUMS.PART_STATUS.NOT_AVAILABLE:
				part_button.get_node("STATUS").modulate = Color(338.0/255,0,93.0/255.0)
				part_button.get_node("STATUS").text ="NOT AVAILABLE"


static func build_part_button(part_button,part:Part):
	build_part_box(part_button.get_node("PART_BOX"),part)

static func build_part_box(part_button,part:Part):

		part_button.get_node("ID").text =DATA_TO_UI.insert_leading_zeros(part.ID)
		part_button.get_node("NAME").text = "%s"%part.name
		if(part_button.has_node("FLAVOR")):
			part_button.get_node("FLAVOR").text = "%s"%part.flavor
		if(part_button.has_node("RECYCLE_POINTS")):
			part_button.get_node("RECYCLE_POINTS").text = DATA_TO_UI.insert_leading_zeros(part.recycle_points)
		if(part_button.has_node("SELLING_PRICE")):
			part_button.get_node("SELLING_PRICE").text = "%s"%part.selling_price
		if(part_button.has_node("MISSION_ODDS")):
			part_button.get_node("MISSION_ODDS").text = "+%s"%DATA_TO_UI.insert_leading_zeros(part.mission_odds)
		part_button.get_node("CRITERIA_FOR_MISSION_ODDS").text =  get_criteria_for_mission_odds(part.criteria_for_mission_odds)
		if(part_button.has_node("RETURNING_ODDS")):
			part_button.get_node("RETURNING_ODDS").text =  "+%s"%DATA_TO_UI.insert_leading_zeros(part.returning_odds)
		part_button.get_node("CRITERIA_FOR_RETURNING_ODDS").text = get_criteria_for_return_odds(part.criteria_for_returning_odds)
		if(part_button.has_node("MECH")):
			var mech = LINQ.First(STATE.MECHS, func (mech:Mech):return mech.ID == part.attached_to_mech_id )

			part_button.get_node("MECH").text = "EQUIPT TO %s"%mech.name
		build_status(part_button,part)

		#if(part_button.has_node("TYPE")):
			#part_button.get_node("TYPE").text = "%s"%part.type
		return part_button

static func build_pilot_box(pilot_button,pilot:Pilot):

		if(pilot_button.has_node("ID")):
			pilot_button.get_node("ID").text = DATA_TO_UI.insert_leading_zeros(pilot.ID)
		if(pilot_button.has_node("NAME")):
			pilot_button.get_node("NAME").text = "%s"%pilot.name
		if(pilot_button.has_node("COST")):
			pilot_button.get_node("COST").text = "%s"%pilot.cost
		if(pilot_button.has_node("FLAVOR")):
			pilot_button.get_node("FLAVOR").text = pilot.flavor
		if(pilot_button.has_node("MISSION_ODDS")):
			pilot_button.get_node("MISSION_ODDS").text = "+%s/%s"%[pilot.mission_odds,pilot.mission_odds]
		if(pilot_button.has_node("CRITERIA_FOR_MISSION_ODDS")):
			pilot_button.get_node("CRITERIA_FOR_MISSION_ODDS").text = get_criteria_for_mission_odds(pilot.criteria_for_mission_odds)
		if(pilot_button.has_node("RETURNING_ODDS")):
			pilot_button.get_node("RETURNING_ODDS").text = "+%s/%s"%[pilot.returning_odds,pilot.returning_odds]
		if(pilot_button.has_node("CRITERIA_FOR_RETURNING_ODDS")):
			pilot_button.get_node("CRITERIA_FOR_RETURNING_ODDS").text =get_criteria_for_return_odds(pilot.criteria_for_returning_odds)
		if(pilot_button.has_node("STATUS")):
			match(pilot.status):
				ENUMS.PILOT_STATUS.HIRED:
					pilot_button.get_node("STATUS").text = "HIRED"
					pilot_button.get_node("STATUS").modulate = Color(0,1,170.0/255.0)
				ENUMS.PILOT_STATUS.FOR_HIRE:
					pilot_button.get_node("STATUS").text = "FOR HIRE"
				ENUMS.PILOT_STATUS.ON_MISSION:
					pilot_button.get_node("STATUS").text = "ON MISSION"
				ENUMS.PILOT_STATUS.DEAD:
					pilot_button.get_node("STATUS").text = "DEAD"
					pilot_button.get_node("STATUS").modulate = Color(338.0/255,0,93.0/255.0)
		return pilot_button

static func get_criteria_for_mission_odds(criteria_code:ENUMS.MISSION_CRITERIA)->String:
	match(criteria_code):
		ENUMS.MISSION_CRITERIA.UNDECIDED:
			return "UNDECIDED";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_OFFENSIVE_COMBAT:
			return "ADVANTAGE_DURING_OFFENSIVE_COMBAT";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_RESCUE:
			return "ADVANTAGE_DURING_RESCUE";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_DELIVERY:
			return "ADVANTAGE_DURING_DELIVERY";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_ESCORT:
			return "ADVANTAGE_DURING_ESCORT";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_INTEL_GATHERING:
			return "ADVANTAGE_DURING_INTEL_GATHERING";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_DEFENSIVE_COMBAT:
			return "ADVANTAGE_DURING_DEFENSIVE_COMBAT";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_TRAVEL:
			return "ADVANTAGE_DURING_TRAVEL";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_IN_SPACE:
			return "ADVANTAGE_IN_SPACE";

		ENUMS.MISSION_CRITERIA.UNDERWATER_COMBAT_ADVANTAGE:
			return "UNDERWATER_COMBAT_ADVANTAGE";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_RACING:
			return "ADVANTAGE_RACING";

		ENUMS.MISSION_CRITERIA.NO_CRITERIA_FOR_ADVANTAGE:
			return "NO_CRITERIA_FOR_ADVANTAGE";

		ENUMS.MISSION_CRITERIA.ADVANTAGE_DURING_ANY_COMBAT:
			return "ADVANTAGE_DURING_ANY_COMBAT";

		ENUMS.MISSION_CRITERIA.DRY_COMBAT_ADVANTAGE:
			return "DRY_COMBAT_ADVANTAGE";

	return "UNDECIDED"
static func get_criteria_for_return_odds(criteria_code:ENUMS.RETURN_CRITERIA)->String:
	match(criteria_code):
		ENUMS.RETURN_CRITERIA.UNDECIDED:
			return "UNDECIDED";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_UNDERWATER:
			return "ADVANTAGE_UNDERWATER";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_AERIAL:
			return "ADVANTAGE_AERIAL";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_IN_CITY:
			return "ADVANTAGE_IN_CITY";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_SPECIAL_OPS:
			return "ADVANTAGE_SPECIAL_OPS";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_ESCORT:
			return "ADVANTAGE_ESCORT";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_IN_SPACE:
			return "ADVANTAGE_IN_SPACE";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_IN_SWAMP:
			return "ADVANTAGE_IN_SWAMP";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_IN_DESERT:
			return "ADVANTAGE_IN_DESERT";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_IN_EXTREME_TEMPERATURES:
			return "ADVANTAGE_IN_EXTREME_TEMPERATURES";

		ENUMS.RETURN_CRITERIA.ADVANTAGE_RACING:
			return "ADVANTAGE_RACING";

		ENUMS.RETURN_CRITERIA.NO_CRITERIA_FOR_ADVANTAGE:
			return "NO_CRITERIA_FOR_ADVANTAGE";

		ENUMS.RETURN_CRITERIA.NO_ADVANTAGE_UNDERWATER:
			return "NO_ADVANTAGE_UNDERWATER";

	return "UNDECIDED"

static func display_node_for_part(id,part_nodes_parent):
	for _node in part_nodes_parent.get_children():
		_node.hide()
	match(id):
			0:
				part_nodes_parent.get_node("CRYSTAL_MUSHROOMS").show();

				#part_nodes_parent.get_node("ICE_BLADE").show();
			1:
				part_nodes_parent.get_node("HEAT_BLADE").show();
			2:
				part_nodes_parent.get_node("BLUE_NUT").show();
			3:
				part_nodes_parent.get_node("RED_NUT").show();
			4:
				part_nodes_parent.get_node("BLUE_PLATE").show();
			5:
				part_nodes_parent.get_node("RED_PLATE").show();
			6:
				part_nodes_parent.get_node("BLUE_NADE").show();
			7:
				part_nodes_parent.get_node("RED_NADE").show();
			8:
				part_nodes_parent.get_node("BLUE_GUN").show()
			9:
				part_nodes_parent.get_node("RED_GUN").show();
			10:
				part_nodes_parent.get_node("BLUE_ChainMesh").show()
			11:
				part_nodes_parent.get_node("BLUE_CLIPMesh").show();
			12:
				part_nodes_parent.get_node("BLUE_HammerKnuckle").show();
			13:
				part_nodes_parent.get_node("BLUE_NanoApplicator").show();
			14:
				part_nodes_parent.get_node("RED_ChainMesh").show();
			15:
				part_nodes_parent.get_node("RED_CLIPMesh").show();
			16:
				part_nodes_parent.get_node("RED_HammerKnuckle").show();
			17:
				part_nodes_parent.get_node("RED_NanoApplicator").show();
			18:
				part_nodes_parent.get_node("RED_ENGINE").show();
			19:
				part_nodes_parent.get_node("BLUE_ENGINE").show();
			20:
				part_nodes_parent.get_node("TAN_NUT").show();
			21:
				part_nodes_parent.get_node("DARK_NUT").show();
			21:
				part_nodes_parent.get_node("TAN_BLADE").show();
			22:
				part_nodes_parent.get_node("CRYSTAL_MUSHROOMS").show();

static func display_node_for_mech(id,mech_nodes_parent):

	for _node in mech_nodes_parent.get_children():
		_node.hide()
	match(id):
			0:
				mech_nodes_parent.get_node("BLUE_MECH_001").show();
			1:
				mech_nodes_parent.get_node("RED_MECH_001").show();
			2:
				mech_nodes_parent.get_node("BLUE_MECH_002").show();
			3:
				mech_nodes_parent.get_node("RED_MECH_002").show();
			4:
				mech_nodes_parent.get_node("BLUE_MECH_003").show();
			5:
				mech_nodes_parent.get_node("RED_MECH_003").show();
			6:
				mech_nodes_parent.get_node("BLUE_MECH_004").show();
			7:
				mech_nodes_parent.get_node("RED_MECH_004").show();
			8:
				mech_nodes_parent.get_node("BLUE_MECH_005").show();
			9:
				mech_nodes_parent.get_node("RED_MECH_005").show();

static func get_environment_text_and_tint(environment):
	var environment_text = "DESERT"
	var environment_tint = Vector3.ZERO;
	match(environment):
			ENUMS.ENVIRONMENT.DESERT:
				environment_text = "DESERT"
				environment_tint = Vector3(194,114,44);
			ENUMS.ENVIRONMENT.SWAMP:
				environment_text = "SWAMP"
				environment_tint = Vector3(25,157,102);
			ENUMS.ENVIRONMENT.URBAN:
				environment_text = "URBAN"
				environment_tint = Vector3(157,0,100);
			ENUMS.ENVIRONMENT.JUNGLE:
				environment_text = "JUNGLE"
				environment_tint = Vector3(82,176,53);
			ENUMS.ENVIRONMENT.SPACE:
				environment_text = "SPACE"
				environment_tint = Vector3(30,29,196);
			ENUMS.ENVIRONMENT.UNDERWATER_FROZEN:
				environment_text = "FROZEN WATER"
				environment_tint = Vector3(179,255,229);
			ENUMS.ENVIRONMENT.UNDERWATER:
				environment_text = "SALT WATER"
				environment_tint = Vector3(21,99,188);
			ENUMS.ENVIRONMENT.UNDERWATER_BOILING:
				environment_text = "BOILING WATER"
				environment_tint = Vector3(255,0,93);
			ENUMS.ENVIRONMENT.ICY:
				environment_text = "ICY"
				environment_tint = Vector3(255,255,255);
			ENUMS.ENVIRONMENT.UNDERGROUND:
				environment_text = "SUBTERRANEAN"
				environment_tint = Vector3(71,0,106);
			ENUMS.ENVIRONMENT.ACID_LAKE:
				environment_text = "ACID LAKE"
				environment_tint = Vector3(120,227,86);
			ENUMS.ENVIRONMENT.IN_ATMOSPHERE:
				environment_text = "ATMOSPHERE"
				environment_tint = Vector3(120,227,86);
	return [environment_text,environment_tint]

static func get_mech_type(mech):
	var type_text
	match(mech.type):
			ENUMS.MECH_TYPE.DEFENSIVE:
				type_text = "DEFENSIVE"
				#environment_tint = Vector3(194,114,44);
			ENUMS.MECH_TYPE.AERIAL:
				type_text = "AERIAL"
				#environment_tint = Vector3(25,157,102);
			ENUMS.MECH_TYPE.SPECIAL_OPS:
				type_text = "SPECIAL OPS"
				#environment_tint = Vector3(157,0,100);
			ENUMS.MECH_TYPE.UNDERWATER:
				type_text = "UNDERWATER"
				#environment_tint = Vector3(82,176,53);
			ENUMS.MECH_TYPE.SPACE:
				type_text = "SPACE"
				#environment_tint = Vector3(30,29,196);
			ENUMS.MECH_TYPE.EXTREME_TEMP:
				type_text = "EXTREME TEMP"
				#environment_tint = Vector3(179,255,229);
			ENUMS.MECH_TYPE.LONG_HAUL:
				type_text = "LONG HAUL"
				#environment_tint = Vector3(21,99,188);
			ENUMS.MECH_TYPE.ANY_TYPE:
				type_text = "ANY TYPE"
				#environment_tint = Vector3(255,0,93);
			ENUMS.MECH_TYPE.HIGH_GRAVITY:
				type_text = "HIGH GRAVITY"
				#environment_tint = Vector3(255,255,255);
			ENUMS.MECH_TYPE.ANTI_CORROSIVE:
				type_text = "ANTI CORROSIVE"
				#environment_tint = Vector3(71,0,106);
			ENUMS.MECH_TYPE.RACING:
				type_text = "RACING"
				#environment_tint = Vector3(120,227,86);
	return type_text;
static func get_status_text_for_mech(mech):
	var status=""
	match(mech.status):
			ENUMS.MECH_STATUS.IN_GARAGE:
				status="IN GARAGE"
			ENUMS.MECH_STATUS.FOR_SALE:
				status ="FOR SALE [%s]"%mech.cost
			ENUMS.MECH_STATUS.ON_MISSION:
				status ="ON MISSION"
			ENUMS.MECH_STATUS.NOT_AVAILABLE:
				status ="NOT AVAILABLE"
	return status;

static func insert_leading_zeros(value:int):
	var string_value = "%s" % value
	if(string_value.length() == 0):
		string_value = "[dim]000[/dim]"
	elif(string_value.length() == 1):
		string_value = "[dim]00[/dim]%s" %value
	elif(string_value.length() == 2):
		string_value = "[dim]0[/dim]%s" %value
	return string_value

static func insert_more_leading_zeros(value:int):
	var string_value = "%s" % value
	if(string_value.length() == 0):
		string_value = "[dim]00000[/dim]"
	elif(string_value.length() == 1):
		string_value = "[dim]0000[/dim]%s" %value
	elif(string_value.length() == 2):
		string_value = "[dim]000[/dim]%s" %value
	elif(string_value.length() == 3):
		string_value = "[dim]00[/dim]%s" %value
	elif(string_value.length() == 4):
		string_value = "[dim]0[/dim]%s" %value
	return string_value

static func one_over_dim_zeros(value:int):
	if(value < 0):
		return "[right][dim]1/[/dim]%s"%(value*-1)
	else:
		return "[right][dim]%s/[/dim]%s"%[value-1,(value)]
