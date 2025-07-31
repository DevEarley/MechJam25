class_name DATA_TO_UI

static func build_mech_box(mech_button, mech):
		mech_button.get_node("ID").text = "%s"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name
		mech_button.get_node("FLAVOR").text = "%s"%mech.flavor
		mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "";
		for environment in mech.compatible_environments:
			mech_button.get_node("COMPATIBLE_ENVIRONMENT").text += "[%s] "%environment
		mech_button.get_node("TYPE").text = "%s"%mech.type
		mech_button.get_node("BASE_HEALTH").text = "%s"%mech.base_health
		mech_button.get_node("CURRENT_HEALTH").text = "%s"%mech.current_health
		mech_button.get_node("STATUS").text = "%s"%mech.status
		return mech_button

static func build_mech_box_small(MECH_BOX_PREFAB, mech):
		var mech_button = MECH_BOX_PREFAB.instantiate()
		mech_button.get_node("ID").text = "%s"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name
		mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "";
		for environment in mech.compatible_environments:
			mech_button.get_node("COMPATIBLE_ENVIRONMENT").text += "[%s] "%environment
		mech_button.get_node("TYPE").text = "%s"%mech.type
		mech_button.get_node("BASE_HEALTH").text = "%s"%mech.base_health
		mech_button.get_node("CURRENT_HEALTH").text = "%s"%mech.current_health
		mech_button.get_node("STATUS").text = "%s"%mech.status
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
				var mech = LINQ.First(STATE.MECHS, func (mech:Mech):return mech.ID == STATE.CURRENT_MECH_ID)
				part_button.get_node("STATUS").text ="EQUIPT TO %s"% mech.name

			ENUMS.PART_STATUS.NOT_AVAILABLE:
				part_button.get_node("STATUS").text ="NOT AVAILABLE"

		return part_button

static func build_part_box(part_button,part:Part):

		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		part_button.get_node("FLAVOR").text = "%s"%part.flavor
		part_button.get_node("RECYCLE_POINTS").text = "%s"%part.recycle_points
		part_button.get_node("SELLING_PRICE").text = "%s"%part.selling_price
		part_button.get_node("MISSION_ODDS").text = "%s"%part.mission_odds
		part_button.get_node("CRITERIA_FOR_MISSION_ODDS").text = "%s"%part.criteria_for_mission_odds
		part_button.get_node("RETURNING_ODDS").text = "%s"%part.returning_odds
		part_button.get_node("CRITERIA_FOR_RETURNING_ODDS").text = "%s"%part.criteria_for_returning_odds
		part_button.get_node("MECH").text = "%s"%part.attached_to_mech_id
		part_button.get_node("STATUS").text = "%s"%part.status
		part_button.get_node("TYPE").text = "%s"%part.type
		return part_button

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
