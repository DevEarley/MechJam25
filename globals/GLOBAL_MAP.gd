extends Node

var PACKED_SCENE = preload("res://scenes/map.tscn")
var MAP_NODE
var CURSOR
var ANIMATOR
var CAMERA
func _ready():
	MAP_NODE= PACKED_SCENE.instantiate()
	add_child(MAP_NODE)
	ANIMATOR = MAP_NODE.get_node("ANIMATOR")
	CURSOR = MAP_NODE.get_node("CURSOR")
	CAMERA = MAP_NODE.get_node("CAMERA")
