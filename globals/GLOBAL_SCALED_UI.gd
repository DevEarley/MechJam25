extends Node

var _scene = preload("res://scenes/scaled-ui.tscn")
var scaled_subviewport_container:CanvasLayer;
var SCALED_UI_VIEWPORT
var SCALED_UI_VIEWPORT_CONTAINER:SubViewportContainer

func _ready() -> void:
	scaled_subviewport_container = _scene.instantiate();
	add_child(scaled_subviewport_container);
	SCALED_UI_VIEWPORT = scaled_subviewport_container.get_node("SCALED_UI/SCALED_UI_VIEWPORT");
	SCALED_UI_VIEWPORT_CONTAINER = scaled_subviewport_container.get_node("SCALED_UI");

func add_canvas_to_viewport(canvas:CanvasLayer):
	#canvas.reparent(SCALED_UI_VIEWPORT)
	SCALED_UI_VIEWPORT.add_child(canvas);
