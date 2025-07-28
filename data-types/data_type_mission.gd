class_name Mission

var ID : int
var name : String
var flavor : String
var flavor_icon : ENUMS.MISSION_FLAVOR_TYPE
var one_over_odds_of_success : int
var one_over_odds_of_returning : int
var environment : int
var location_id : int
var mech_id : int
var pilot_id : int
var allowed_mech_types : Array[ENUMS.MECH_TYPE]
var status : ENUMS.MISSION_STATUS

var time_started #UTC string
var time_remaining #UTC string

var reward_type_1;
var reward_value_1;
var reward_type_2;
var reward_value_2;

var start_script:String;
var success_script:String;
var fail_script:String;
