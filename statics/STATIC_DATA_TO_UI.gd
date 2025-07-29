class_name DATA_TO_UI

static func build_mech_box(MECH_BOX_PREFAB, mech):
		var mech_button = MECH_BOX_PREFAB.instantiate()
		mech_button.get_node("ID").text = "%s"%mech.ID
		mech_button.get_node("NAME").text = "%s"%mech.name
		mech_button.get_node("FLAVOR").text = "%s"%mech.flavor
		mech_button.get_node("COMPATIBLE_ENVIRONMENT").text = "%s"%mech.compatible_environments
		mech_button.get_node("TYPE").text = "%s"%mech.type
		mech_button.get_node("BASE_HEALTH").text = "%s"%mech.base_health
		mech_button.get_node("CURRENT_HEALTH").text = "%s"%mech.current_health
		mech_button.get_node("STATUS").text = "%s"%mech.status
		return mech_button

static func build_small_part_box(BOX_PREFAB,part:Part):
		var part_button = BOX_PREFAB.instantiate()
		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		part_button.get_node("MECH").text = "%s"%part.attached_to_mech_id
		part_button.get_node("STATUS").text = "%s"%part.status
		return part_button

static func build_part_box(BOX_PREFAB,part:Part):
		var part_button = BOX_PREFAB.instantiate()
		part_button.get_node("ID").text = "%s"%part.ID
		part_button.get_node("NAME").text = "%s"%part.name
		part_button.get_node("FLAVOR").text = "%s"%part.flavor
		part_button.get_node("RECYCLE_POINTS").text = "%s"%part.recycle_points
		part_button.get_node("SELLING_PRICE").text = "%s"%part.selling_price
		part_button.get_node("BETTER_ODDS").text = "%s"%part.better_odds
		part_button.get_node("CRITERIA_FOR_BETTER_ODDS").text = "%s"%part.criteria_for_better_odds
		part_button.get_node("WORSE_ODDS").text = "%s"%part.worse_odds
		part_button.get_node("CRITERIA_FOR_WORSE_ODDS").text = "%s"%part.criteria_for_worse_odds
		part_button.get_node("MECH").text = "%s"%part.attached_to_mech_id
		part_button.get_node("STATUS").text = "%s"%part.status
		part_button.get_node("TYPE").text = "%s"%part.type
		return part_button
