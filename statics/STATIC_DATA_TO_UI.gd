class_name DATA_TO_UI

static func build_mech_box(mech_button, mech):
		if(mech_button.has_node("ID")):
			mech_button.get_node("ID").text = "%03d"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name

		if(mech_button.has_node("COMPATIBLE_ENVIRONMENT")):
			mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "";
			for environment in mech.compatible_environments:
				var results = get_environment_text_and_tint(environment)
				var environment_text= results[0]
				var environment_tint= results[1]
				mech_button.get_node("COMPATIBLE_ENVIRONMENT").text += "[%s] "%environment_text

		if(mech_button.has_node("TYPE")):
			mech_button.get_node("TYPE").text  = get_mech_type(mech)
		if(mech_button.has_node("BASE_HEALTH")):
			mech_button.get_node("BASE_HEALTH").text = "%03d"%mech.base_health

		if(mech_button.has_node("CURRENT_HEALTH")):
			mech_button.get_node("CURRENT_HEALTH").text = "%03d"%mech.current_health

		if(mech_button.has_node("FLAVOR")):
			mech_button.get_node("FLAVOR").text = mech.flavor
		if(mech_button.has_node("STATUS")):
			mech_button.get_node("STATUS").text = get_status_text_for_mech(mech)
		return mech_button

static func build_mech_box_small(MECH_BOX_PREFAB, mech):
		var mech_button = MECH_BOX_PREFAB.instantiate()
		mech_button.get_node("ID").text = "%03d"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name
		mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "";
		for environment in mech.compatible_environments:
			var results = get_environment_text_and_tint(environment)
			var environment_text= results[0]
			var environment_tint= results[1]
			mech_button.get_node("COMPATIBLE_ENVIRONMENT").text += "[%s] "%environment_text
		mech_button.get_node("TYPE").text  = get_mech_type(mech)
		mech_button.get_node("BASE_HEALTH").text = "%03d"%mech.base_health
		mech_button.get_node("CURRENT_HEALTH").text = "%03d"%mech.current_health
		mech_button.get_node("STATUS").text = get_status_text_for_mech(mech)
		return mech_button

static func build_small_part_box(BOX_PREFAB,part:Part):
		var part_button = BOX_PREFAB.instantiate()
		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		match(part.status):
			ENUMS.PART_STATUS.FOR_SALE:
				part_button.get_node("STATUS").text ="FOR SALE [%s CREDITS]"%part.cost
			ENUMS.PART_STATUS.PURCHASED:
				part_button.get_node("STATUS").text ="AVAILABLE"
			ENUMS.PART_STATUS.EQUIPT:
				var mech = LINQ.First(STATE.MECHS, func (mech:Mech):return mech.ID == part.attached_to_mech_id  && part.status == ENUMS.PART_STATUS.EQUIPT)
				part_button.get_node("STATUS").text ="EQUIPT TO %s"% mech.name

			ENUMS.PART_STATUS.NOT_AVAILABLE:
				part_button.get_node("STATUS").text ="NOT AVAILABLE"

		return part_button

static func build_part_button(part_button,part:Part):
	build_part_box(part_button.get_node("PART_BOX"),part)

static func build_part_box(part_button,part:Part):

		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		if(part_button.has_node("FLAVOR")):
			part_button.get_node("FLAVOR").text = "%s"%part.flavor
		if(part_button.has_node("RECYCLE_POINTS")):
			part_button.get_node("RECYCLE_POINTS").text = "%s"%part.recycle_points
		if(part_button.has_node("SELLING_PRICE")):
			part_button.get_node("SELLING_PRICE").text = "%s"%part.selling_price
		part_button.get_node("MISSION_ODDS").text = "+/%03d"%part.mission_odds
		part_button.get_node("CRITERIA_FOR_MISSION_ODDS").text =  get_criteria_for_mission_odds(part.criteria_for_mission_odds)
		part_button.get_node("RETURNING_ODDS").text = "+/%03d"%part.returning_odds
		part_button.get_node("CRITERIA_FOR_RETURNING_ODDS").text = get_criteria_for_return_odds(part.criteria_for_returning_odds)
		if(part_button.has_node("MECH")):
			var mech = LINQ.First(STATE.MECHS, func (mech:Mech):return mech.ID == part.attached_to_mech_id )

			part_button.get_node("MECH").text = "EQUIPT TO %s"%mech.name
		if(part_button.has_node("STATUS")):
			part_button.get_node("STATUS").text = "%s"%part.status
		if(part_button.has_node("TYPE")):
			part_button.get_node("TYPE").text = "%s"%part.type
		return part_button

static func build_pilot_box(pilot_button,pilot:Pilot):

		pilot_button.get_node("ID").text = "%s"%pilot.ID
		pilot_button.get_node("NAME").text = "%s"%pilot.name
		#pilot_button.get_node("COST").text = "%s"%pilot.cost
		#pilot_button.get_node("FLAVOR").text = "%s"%pilot.flavor
		#pilot_button.get_node("THEME").text = "%s"%pilot.theme
		pilot_button.get_node("MISSION_ODDS").text = "+/%03d"%pilot.mission_odds
		pilot_button.get_node("CRITERIA_FOR_MISSION_ODDS").text = get_criteria_for_mission_odds(pilot.criteria_for_mission_odds)
		pilot_button.get_node("RETURNING_ODDS").text = "+/%03d"%pilot.returning_odds

		pilot_button.get_node("CRITERIA_FOR_RETURNING_ODDS").text =get_criteria_for_return_odds(pilot.criteria_for_returning_odds)
		#pilot_button.get_node("STATUS").text = "%s"%pilot.status

		return pilot_button

static func get_criteria_for_mission_odds(criteria_code:ENUMS.MISSION_CRITERIA)->String:
	match(criteria_code):
		ENUMS.MISSION_CRITERIA.UNDECIDED:
			return "UNDECIDED";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_1:
			return "MISSION_CRITERIA #1";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_2:
			return "MISSION_CRITERIA #2";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_3:
			return "MISSION_CRITERIA #3";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_4:
			return "MISSION_CRITERIA #4";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_5:
			return "MISSION_CRITERIA #5";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_6:
			return "MISSION_CRITERIA #6";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_7:
			return "MISSION_CRITERIA #7";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_8:
			return "MISSION_CRITERIA #8";

		ENUMS.MISSION_CRITERIA.MISSION_CRITERIA_9:
			return "MISSION_CRITERIA #9";

	return "UNDECIDED"
static func get_criteria_for_return_odds(criteria_code:ENUMS.RETURN_CRITERIA)->String:
	match(criteria_code):
		ENUMS.RETURN_CRITERIA.UNDECIDED:
			return "UNDECIDED";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_1:
			return "RETURN_CRITERIA #1";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_2:
			return "RETURN_CRITERIA #2";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_3:
			return "RETURN_CRITERIA #3";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_4:
			return "RETURN_CRITERIA #4";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_5:
			return "RETURN_CRITERIA #5";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_6:
			return "RETURN_CRITERIA #6";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_7:
			return "RETURN_CRITERIA #7";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_8:
			return "RETURN_CRITERIA #8";

		ENUMS.RETURN_CRITERIA.RETURN_CRITERIA_9:
			return "RETURN_CRITERIA #9";

	return "UNDECIDED"

static func display_node_for_part(id,part_nodes_parent):
	for _node in part_nodes_parent.get_children():
		_node.hide()
	match(id):
			0:
				part_nodes_parent.get_node("HEAT_BLADE").show();
			1:
				part_nodes_parent.get_node("ICE_BLADE").show();
			2:
				part_nodes_parent.get_node("BLUE_NUT").show();
			3:
				part_nodes_parent.get_node("RED_NUT").show();
			4:
				part_nodes_parent.get_node("BLUE_NUT").show();
			5:
				part_nodes_parent.get_node("RED_NUT").show();
			6:
				part_nodes_parent.get_node("BLUE_NUT").show();
			7:
				part_nodes_parent.get_node("RED_NUT").show();
			8:
				part_nodes_parent.get_node("BLUE_NUT").show();
			9:
				part_nodes_parent.get_node("RED_NUT").show();

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
	return [environment_text,environment_tint]

static func get_mech_type(mech):
	var type_text
	match(mech.type):
			ENUMS.MECH_TYPE.DESERT:
				type_text = "DESERT"
				#environment_tint = Vector3(194,114,44);
			ENUMS.MECH_TYPE.SWAMP:
				type_text = "SWAMP"
				#environment_tint = Vector3(25,157,102);
			ENUMS.MECH_TYPE.URBAN:
				type_text = "URBAN"
				#environment_tint = Vector3(157,0,100);
			ENUMS.MECH_TYPE.JUNGLE:
				type_text = "JUNGLE"
				#environment_tint = Vector3(82,176,53);
			ENUMS.MECH_TYPE.SPACE:
				type_text = "SPACE"
				#environment_tint = Vector3(30,29,196);
			ENUMS.MECH_TYPE.UNDERWATER_FROZEN:
				type_text = "FROZEN WATER"
				#environment_tint = Vector3(179,255,229);
			ENUMS.MECH_TYPE.UNDERWATER:
				type_text = "SALT WATER"
				#environment_tint = Vector3(21,99,188);
			ENUMS.MECH_TYPE.UNDERWATER_BOILING:
				type_text = "BOILING WATER"
				#environment_tint = Vector3(255,0,93);
			ENUMS.MECH_TYPE.ICY:
				type_text = "ICY"
				#environment_tint = Vector3(255,255,255);
			ENUMS.MECH_TYPE.UNDERGROUND:
				type_text = "SUBTERRANEAN"
				#environment_tint = Vector3(71,0,106);
			ENUMS.MECH_TYPE.ACID_LAKE:
				type_text = "ACID LAKE"
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
