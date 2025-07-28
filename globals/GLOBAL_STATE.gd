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

var SPEED = 1.0
var PILOTS:Array[Pilot]
var PARTS:Array[Part]
var MECHS:Array[Mech]
var MISSIONS:Array[Mission]
var LOCATIONS:Array[Location]
