class_name Mission

var ID : int
var name : String
var flavor : String
var flavor_icon : ENUMS.MISSION_FLAVOR_TYPE
var one_over_odds_for_mission : int
var one_over_odds_for_returning : int
var location_id : int
var allowed_mech_types : Array[ENUMS.MECH_TYPE]
var status : ENUMS.MISSION_STATUS

var time_started = 0 #seconds


var start_script:String;
var success_script:String;
var fail_script:String;
