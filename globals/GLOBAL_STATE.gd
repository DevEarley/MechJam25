extends Node
var LAST_CAMERA
var CURRENT_MISSION:Mission
var ON_QUEST_SCRIPT_DONE:Callable
var ON_BACK_BUTTON_PRESSED:Callable
var HAS_MISSION_IN_PROGRESS:bool = false
var DIFFICULTY_SETTTING_MENU_CANVAS: CanvasLayer;
var OPTIONS_MENU_CANVAS:CanvasLayer;
var MAIN_MENU_CANVAS:CanvasLayer;
var LOCATION_SELECT_MENU_CANVAS:CanvasLayer;
var PARTS_MENU_CANVAS:CanvasLayer;
var RESULTS_SCREEN_CANVAS:CanvasLayer
var PILOT_MENU_CANVAS:CanvasLayer;
var MISSIONS_MENU_CANVAS:CanvasLayer;
var DEPLOYMENTS_MENU_CANVAS:CanvasLayer;
var MECH_MENU_CANVAS:CanvasLayer;
var CONVERSATION_SCREEN_CANVAS:CanvasLayer;
var CONVERSATION_CONTROL_NODE
var START_MENU_CANVAS:CanvasLayer

var STATUS_BAR_CANVAS:CanvasLayer;
var EQUIP_PART_TO_MECH_POP_UP:CanvasLayer
var USE_REAL_TIME : bool
var DIFFICULTY_ALREADY_CHOSEN : bool = false
var CREDITS = 0;
var RECYCLE_POINTS = 0


var SPEED = 1.0
var PILOTS:Array[Pilot]
var PARTS:Array[Part]
var MECHS:Array[Mech]
var MISSIONS:Array[Mission]
var LOCATIONS:Array[Location]
var VOICEMAILS:Array[Voicemail]


var CURRENT_PART_ID:int;
var CURRENT_MECH_ID:int;
var CURRENT_PILOT_ID:int;
var CURRENT_MISSION_ID:int;
var CURRENT_LOCATION_ID:int;

var PARTS_VERSION:float
var MECHS_VERSION:float
var PILOTS_VERSION:float
var MISSIONS_VERSION:float;
var LOCATIONS_VERSION:float;
var USER_OPTIONS_VERSION:float;
var GAME_STATE_VERSION:float;
var VOICEMAILS_VERSION:float;

var MAP_BG:NinePatchRect

var SFX_VOLUME
var MUSIC_VOLUME


#var DID_DAILY_FOR_MISSION = false

# you signed in before 24 hour mark - you are still waiting. You may get Daily on Debrief.

# you signed in after 24 hour mark -
#	you got daily when you signed in. DID_DAILY_FOR_MISSION_WHEN_LOGGING_IN is true

# you signed in before 24 hour mark -
#	 - it has past 24 hours now. Get Daily on Debrief. DID_DAILY_FOR_MISSION_WHEN_LOGGING_IN is false
#    - then maybe you start a new mission. and leave the app open for 24 hours. On Debrief, DID_DAILY_FOR_MISSION_WHEN_LOGGING_IN would still be false.
