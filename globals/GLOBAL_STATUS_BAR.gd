extends Node


func update_status():
	var number_of_available_or_active_pilots = LINQ.Count(STATE.PILOTS, func (pilot:Pilot): return pilot.status == ENUMS.PILOT_STATUS.HIRED || pilot.status == ENUMS.PILOT_STATUS.ON_MISSION);
	var number_of_available_or_active_mechs= LINQ.Count(STATE.MECHS, func (mech:Mech): return mech.status == ENUMS.MECH_STATUS.IN_GARAGE || mech.status == ENUMS.MECH_STATUS.ON_MISSION);
	var number_of_available_or_equipt_parts = LINQ.Count(STATE.PARTS, func (part:Part): return part.status == ENUMS.PART_STATUS.PURCHASED || part.status == ENUMS.PART_STATUS.EQUIPT);
	STATE.STATUS_BAR_CANVAS.get_node("StatusBar/PARTS_TEXT").text  = "%s" % number_of_available_or_equipt_parts
	STATE.STATUS_BAR_CANVAS.get_node("StatusBar/MECH_TEXT").text = "%s" % number_of_available_or_active_mechs
	STATE.STATUS_BAR_CANVAS.get_node("StatusBar/PILOT_TEXT").text = "%s" % number_of_available_or_active_pilots
	STATE.STATUS_BAR_CANVAS.get_node("StatusBar/RECYCLE_POINTS").text = "%s" % STATE.RECYCLE_POINTS
	STATE.STATUS_BAR_CANVAS.get_node("StatusBar/CREDITS").text = "%04dK" % int(STATE.CREDITS / 1000)
