extends Node

var ON_BACK_BUTTON_PRESSED:Callable

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
var START_MENU_CANVAS:CanvasLayer


var EQUIP_PART_TO_MECH_POP_UP:CanvasLayer
var USER_REAL_TIME : bool
var DIFFICULTY_ALREADY_CHOSEN : bool

var SPEED = 1.0
var PILOTS:Array[Pilot]
var PARTS:Array[Part]
var MECHS:Array[Mech]
var MISSIONS:Array[Mission]
var LOCATIONS:Array[Location]

var CURRENT_PART_ID:int;
var CURRENT_MECH_ID:int;
var CURRENT_PILOT_ID:int;
var CURRENT_MISSION_ID:int;
var CURRENT_LOCATION_ID:int;
