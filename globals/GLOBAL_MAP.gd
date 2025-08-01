extends Node

var PACKED_SCENE = preload("res://scenes/map.tscn")
var MAP_NODE
var CURSOR
var ANIMATOR
var CAMERA

var MOVING = false

var CAMERA_MOVE_EASING_TIME =0
var CAMERA_MOVE_EASING_DURATION =0.33
var CAMERA_MOVE_OG_POSITION:Vector3
var CAMERA_MOVE_CHANGE:Vector3
var CAMERA_MOVE_TIMER:Timer

func _process(delta):
	if(MOVING):
		CAMERA_MOVE_EASING_TIME+=delta;
		CAMERA.global_position = EasingV3.Expo.EaseOut(CAMERA_MOVE_EASING_TIME,CAMERA_MOVE_OG_POSITION,CAMERA_MOVE_CHANGE,CAMERA_MOVE_EASING_DURATION)

func _ready():
	MAP_NODE= PACKED_SCENE.instantiate()
	add_child(MAP_NODE)
	CAMERA_MOVE_TIMER = Timer.new()
	CAMERA_MOVE_TIMER.wait_time = CAMERA_MOVE_EASING_DURATION;
	CAMERA_MOVE_TIMER.one_shot = true;
	CAMERA_MOVE_TIMER.connect("timeout",done_moving_camera);
	add_child(CAMERA_MOVE_TIMER)
	ANIMATOR = MAP_NODE.get_node("ANIMATOR")
	CURSOR = MAP_NODE.get_node("CURSOR")
	CAMERA = MAP_NODE.get_node("CAMERA")

func done_moving_camera():
	MOVING = false

func start_moving_to_position(new_position:Vector3):
	CAMERA_MOVE_CHANGE = new_position - CAMERA.global_position;
	CAMERA_MOVE_OG_POSITION = CAMERA.global_position;
	CAMERA_MOVE_EASING_TIME = 0
	CAMERA_MOVE_TIMER.start()
	MOVING = true
