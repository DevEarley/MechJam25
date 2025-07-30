extends Node

var CONVERSATION_CONTROL_NODE
var CONVERSATION_CANVAS
var ANIMATOR
var TEXT
var NAME
var CHOICE_1:Button
var CHOICE_2:Button
var CHOICE_3:Button
var CHOICE_4:Button
var ACTION_1:Button
var ACTION_2:Button
var ACTION_3:Button
var ACTION_4:Button

func _ready():
	CONVERSATION_CONTROL_NODE = preload("res://scenes/conversation-ui.tscn").instantiate()
	CONVERSATION_CANVAS = preload("res://scenes/conversation-canvas.tscn").instantiate()
	SCALED_UI.add_canvas_to_viewport(CONVERSATION_CANVAS)
	add_child(CONVERSATION_CONTROL_NODE);

	ANIMATOR = CONVERSATION_CONTROL_NODE.get_node("AnimationPlayer")
	TEXT = CONVERSATION_CANVAS.get_node("TEXT")
	NAME = CONVERSATION_CANVAS.get_node("NAME")
	CHOICE_1 = CONVERSATION_CANVAS.get_node("CHOICE_1")
	CHOICE_2 = CONVERSATION_CANVAS.get_node("CHOICE_2")
	CHOICE_3 = CONVERSATION_CANVAS.get_node("CHOICE_3")
	CHOICE_4 = CONVERSATION_CANVAS.get_node("CHOICE_4")
	ACTION_1 = CONVERSATION_CANVAS.get_node("ACTION_1")
	ACTION_2 = CONVERSATION_CANVAS.get_node("ACTION_2")
	ACTION_3 = CONVERSATION_CANVAS.get_node("ACTION_3")
	ACTION_4 = CONVERSATION_CANVAS.get_node("ACTION_4")
	CHOICE_1.hide()
	CHOICE_2.hide()
	CHOICE_3.hide()
	CHOICE_4.hide()
	ACTION_1.hide()
	ACTION_2.hide()
	ACTION_3.hide()
	ACTION_4.hide()
	CHOICE_1.connect("pressed",QS.on_choice_1_pressed)
	CHOICE_2.connect("pressed",QS.on_choice_2_pressed)
	CHOICE_3.connect("pressed",QS.on_choice_3_pressed)
	CHOICE_4.connect("pressed",QS.on_choice_4_pressed)
	ACTION_1.connect("pressed",QS.on_action_1_pressed)
	ACTION_2.connect("pressed",QS.on_action_2_pressed)
	ACTION_3.connect("pressed",QS.on_action_3_pressed)
	ACTION_4.connect("pressed",QS.on_action_4_pressed)
	CONVERSATION_CONTROL_NODE.hide()
	CONVERSATION_CANVAS.hide()

#QS.start();

#QS.continue_script()

#match(CHOICE_INDEX):
	#0:
		#QS.on_choice_1_pressed()
	#1:
		#QS.on_choice_2_pressed()
	#2:
		#QS.on_choice_3_pressed()
	#3:
		#QS.on_choice_4_pressed()


#match(CHOICE_INDEX):
	#0:
		#QS.on_action_1_pressed()
	#1:
		#QS.on_action_2_pressed()
	#2:
		#QS.on_action_3_pressed()
	#3:
		#QS.on_action_4_pressed()
func start_conversation():
	CONVERSATION_CONTROL_NODE.show()
	CONVERSATION_CANVAS.show()

func hide_ui():
	CONVERSATION_CONTROL_NODE.hide()
	CONVERSATION_CANVAS.hide()

func show_ui():
	CONVERSATION_CANVAS.show()
	CONVERSATION_CONTROL_NODE.show()

func done_with_choices():
	CHOICE_1.hide()
	CHOICE_2.hide()
	CHOICE_3.hide()
	CHOICE_4.hide()

func done_with_actions():
	ACTION_1.hide()
	ACTION_2.hide()
	ACTION_3.hide()
	ACTION_4.hide()

func setup_choices(arr:Array):
	CHOICE_1.show()
	CHOICE_2.show()
	CHOICE_1.text = arr[0]
	CHOICE_2.text = arr[1]
	CHOICE_3.hide()
	CHOICE_4.hide()

	if(arr.size()>2):
		CHOICE_3.text = arr[2]
		CHOICE_3.show()
	elif(arr.size()>3):
		CHOICE_3.show()
		CHOICE_4.show()
		CHOICE_3.text = arr[2]
		CHOICE_4.text = arr[3]

func setup_actions(arr:Array):
	ACTION_1.show()
	ACTION_2.show()
	ACTION_1.text = arr[0]
	ACTION_2.text = arr[1]
	ACTION_3.hide()
	ACTION_4.hide()

	if(arr.size()>2):
		ACTION_3.text = arr[2]
		ACTION_3.show()
	elif(arr.size()>3):
		ACTION_3.show()
		ACTION_4.show()
		ACTION_3.text = arr[2]
		ACTION_4.text = arr[3]

func show_info(message:String):
	pass

func continue_conversation(message,character_name):
	CONVERSATION_CANVAS.show()
	CONVERSATION_CONTROL_NODE.show()
	TEXT.text = message;
	NAME.text = character_name


func _input(event: InputEvent) -> void:
	if(event.is_action_released("ui_accept")):
		QS.continue_script()
