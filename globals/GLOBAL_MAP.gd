extends Node

var PACKED_SCENE = preload("res://scenes/map.tscn")
var MAP_NODE
var ANIMATOR
func _ready():
	MAP_NODE= PACKED_SCENE.instantiate()
	add_child(MAP_NODE)
	ANIMATOR = MAP_NODE.get_node("AnimationPlayer")
