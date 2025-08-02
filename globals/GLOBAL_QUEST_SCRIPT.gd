extends Node
var CURRENT_SCRIPT:PackedStringArray
var CURRENT_LINE = 0;
var REGISTERED_SIGNALS:Array[String] = [];

var CHOICE_1_MARKER;
var CHOICE_2_MARKER;
var CHOICE_3_MARKER;
var CHOICE_4_MARKER;

var ACTION_1_MARKER;
var ACTION_2_MARKER;
var ACTION_3_MARKER;
var ACTION_4_MARKER;
var CURRENT_NPC:NPC;

var call_back_on_finished:Callable;


func process_signal(signal_string:String):
	for REGISTERED_SIGNAL in REGISTERED_SIGNALS:
		if(REGISTERED_SIGNAL.contains(signal_string)):
			var split_on_comma;
			if(REGISTERED_SIGNAL.contains("\"")):
				var split_on_quotes = REGISTERED_SIGNAL.split("\"",false)
				split_on_comma = split_on_quotes[0].split(",");
			else:
				split_on_comma = REGISTERED_SIGNAL.split(",");

			var last_index = split_on_comma.size()-1;
			CURRENT_LINE = get_line_index_for_marker(split_on_comma[last_index]);
			run_script__process_line();

func start():
	CURRENT_LINE = 0;
	run_script__process_line();

func continue_script():
	CURRENT_LINE +=1;
	if(CURRENT_SCRIPT.size()>CURRENT_LINE):
		run_script__process_line()
	else:
		on_script_finished();


func process_script_for_quotes(_script:String):
	return _script.replace("“","\"").replace("”","\"");

func init_script(_script:String,callback:Callable):
	call_back_on_finished = callback;
	_script = process_script_for_quotes(_script)
	var lines:PackedStringArray = _script.split("\n",false)
	CURRENT_SCRIPT = lines
	CURRENT_LINE = 0;

func run_script_from_file(filename):
		var intro_script = FileAccess.open("res://quest_scripts/%s.qs.txt"%filename, FileAccess.READ)
		var content = intro_script.get_as_text()
		QS.run_script(content)

func run_script(_script:String):
	if(_script == ""):
		on_script_finished();
		return
	CONVERSATION_UI.start_conversation()
	_script = process_script_for_quotes(_script)
	var lines:PackedStringArray = _script.split("\n",false)
	CURRENT_SCRIPT = lines
	CURRENT_LINE = 0;
	run_script__process_line();

func get_line_index_for_marker(marker:String):
	if(marker.begins_with("[")==false):
		marker = "[%s]"%marker;
	var index = 0;
	var target = -1;
	for line in CURRENT_SCRIPT:
		if(line == marker):
			target = index;
			break
		index +=1;
	return target;

func process_info(rest_of_line):
	var message:String;
	var options:String = "";
	var split_on_commas:PackedStringArray = rest_of_line.split(",",false);
	if(split_on_commas.size()==1):
		message = split_on_commas[0];
	if(split_on_commas.size()==2):
		message = split_on_commas[0];
		options = split_on_commas[1];
	run_script__info(message,options);

func process_say(rest_of_line):
	var message:String;
	var speaker:String;
	var options:String;
	if(rest_of_line.contains("\"")):
		var split_on_quotes:PackedStringArray = rest_of_line.split("\"",false);
		if(split_on_quotes.size() == 2):
			message = split_on_quotes[0]
			speaker = split_on_quotes[1].trim_prefix(",");
		elif(split_on_quotes.size() == 3):
			message = split_on_quotes[0]
			speaker = split_on_quotes[1].trim_prefix(",");
			options = split_on_quotes[2].trim_prefix(",")
		else:
			var split_on_commas:PackedStringArray = split_on_quotes[1].split(",",false)
			var last_index = split_on_commas.size()-1;
			var first_choice = ""
			var index = 0;
			for part in split_on_commas:
				if(index<last_index-1):
					first_choice+=part;
				index+=1;
			message = first_choice
			speaker = split_on_commas[last_index-1];
			options = split_on_commas[last_index]
	#elif(rest_of_line.contains(",")):
#
		#var split_on_commas:PackedStringArray = rest_of_line.split(",",false);
#
		#if(split_on_commas.size()==2):
#
			#message = split_on_commas[0];
			#speaker = split_on_commas[1];
		#if(split_on_commas.size()==3):
#
			#message = split_on_commas[0];
			#speaker = split_on_commas[1];
			#options = split_on_commas[2];
		#if(split_on_commas.size()>3):
			#var last_index = split_on_commas.size()-1;
			#var first_choice = ""
			#var index = 0;
			#for choice in split_on_commas:
				#if(index<last_index-1):
					#first_choice+=choice;
				#index+=1;
			#message = first_choice;
			#speaker = split_on_commas[last_index];
	elif(rest_of_line.contains("]")):
		message = rest_of_line.split("]")[0]
		speaker= rest_of_line.split("]")[1]
	else:
		message= rest_of_line
	speaker = speaker.trim_prefix(" ")
	speaker = speaker.trim_prefix("[")
	speaker = speaker.trim_suffix(" ")
	speaker = speaker.trim_suffix("]")
	run_script__say(message,speaker,options);

func process_choices_or_actions(rest_of_line, show_speaker_for_choices):
	var choices = []
	if(rest_of_line.contains("\"")):
		var split_on_quotes:PackedStringArray = rest_of_line.split("\"",false); # split on "
		for split_ in split_on_quotes:
			var trimmed_back = split_.trim_suffix(",");
			var trimmed_front = trimmed_back.trim_prefix(",");
			if(trimmed_front != ""):
				choices.push_back(trimmed_front.trim_prefix(" ").trim_suffix(" "))
	else:
		var split_on_commas:PackedStringArray = rest_of_line.split(",",false);
		for split_ in split_on_commas:
			choices.push_back(split_.trim_prefix(" ").trim_suffix(" "))
	var last_index = choices.size()-1;
	if(choices.size() == 2):
		run_script__choices_or_actions(choices[0], choices[1], show_speaker_for_choices)
	elif(choices.size() == 3):
		run_script__choices_3_or_actions(choices[0], choices[1], choices[2], show_speaker_for_choices)
	elif(choices.size() == 4):
		run_script__choices_4_or_actions(choices[0], choices[1], choices[2], choices[3], show_speaker_for_choices)
	elif(choices.size() > 4):
		var first_choice = ""
		var index = 0;
		for choice in choices:
			if(index<last_index-3):
				first_choice+=choice;
			index+=1;
		run_script__choices_4_or_actions(first_choice, choices[last_index-2], choices[last_index-1], choices[last_index], show_speaker_for_choices)

func run_script__process_line():
	if(CURRENT_LINE > CURRENT_SCRIPT.size()-1):
		on_script_finished()
		return
	var line = CURRENT_SCRIPT[CURRENT_LINE];
	print(line)
	if(line.contains("[") == false):
		continue_script();
		return
	if(line.begins_with("[")):
		CURRENT_LINE+=1;
		run_script__process_line();
		return;
	var split_line = line.split("[",false)
	var start_of_line:String = split_line[0];
	var rest_of_line:String = split_line[1];
	rest_of_line = rest_of_line.trim_suffix("]")
	if(start_of_line != ""):
		match(start_of_line.to_lower()):
			"say":
				process_say(rest_of_line)
			"info":
				process_info(rest_of_line)
			"go":
				CURRENT_LINE = get_line_index_for_marker(rest_of_line);
				run_script__process_line()
				return;
			"do":
				QS_DO.run_script__do(rest_of_line);
			"choice":
				process_choices_or_actions(rest_of_line, true)
			"choices":
				process_choices_or_actions(rest_of_line, true)
			"action":
				process_choices_or_actions(rest_of_line, false)
			"actions":
				process_choices_or_actions(rest_of_line, false)
			"if":
				var predicate:String;
				var marker:String;

				if(rest_of_line.contains("\"")):
					var split_on_quotes:PackedStringArray = rest_of_line.split("\"");
					marker = split_on_quotes[1]
					predicate = split_on_quotes[0].trim_suffix(",")
				else:
					var split_on_commas = rest_of_line.split(",",false)
					predicate = split_on_commas[0]
					marker = split_on_commas[1]
				var should_go_to_marker  = QS_IF.if_predicate(predicate)
				if(should_go_to_marker):
					CURRENT_LINE = get_line_index_for_marker(marker);
					run_script__process_line()
					return;
				else:
					CURRENT_LINE+=1
					run_script__process_line()
					return;
			"wait":
				var time_to_wait = rest_of_line.to_int()
				await WAIT.for_seconds(time_to_wait);
			"on":
				REGISTERED_SIGNALS.push_back(rest_of_line)

func run_script__say(message:String, character_name:String, options:String):
	if(message.contains("%s")):
		var processed_options = process_options(options);
		message = message % processed_options;
	CONVERSATION_UI.continue_conversation(message,character_name)

func run_script__info(message:String, options:String):
	if(message.contains("%s")):
		var processed_options = process_options(options);
		message = message % processed_options;
	CONVERSATION_UI.show_info(message)

func run_script__choices_or_actions(choice_1:String,choice_2:String, show_speaker_for_choices):
	if(show_speaker_for_choices):
		CHOICE_1_MARKER = choice_1;
		CHOICE_2_MARKER = choice_2;
		CONVERSATION_UI.setup_choices([choice_1,choice_2]);
	else:
		ACTION_1_MARKER = choice_1;
		ACTION_2_MARKER = choice_2;
		CONVERSATION_UI.setup_actions([choice_1,choice_2]);

func run_script__choices_3_or_actions(choice_1:String,choice_2:String,choice_3:String, show_speaker_for_choices):
	if(show_speaker_for_choices):
		CHOICE_1_MARKER = choice_1;
		CHOICE_2_MARKER = choice_2;
		CHOICE_3_MARKER = choice_3;
		CONVERSATION_UI.setup_choices([choice_1,choice_2,choice_3]);
	else:
		ACTION_1_MARKER = choice_1;
		ACTION_2_MARKER = choice_2;
		ACTION_3_MARKER = choice_3;
		CONVERSATION_UI.setup_actions([choice_1,choice_2,choice_3]);

func run_script__choices_4_or_actions(choice_1:String,choice_2:String,choice_3:String,choice_4:String, show_speaker_for_choices):
		if(show_speaker_for_choices):
			CHOICE_1_MARKER = choice_1;
			CHOICE_2_MARKER = choice_2;
			CHOICE_3_MARKER = choice_3;
			CHOICE_4_MARKER = choice_4;
			CONVERSATION_UI.setup_choices([choice_1,choice_2,choice_3,choice_4]);
		else:
			ACTION_1_MARKER = choice_1;
			ACTION_2_MARKER = choice_2;
			ACTION_3_MARKER = choice_3;
			ACTION_4_MARKER = choice_4;
			CONVERSATION_UI.setup_actions([choice_1,choice_2,choice_3,choice_4]);


func process_options(options:String)->Array[String]:
	var array_of_replacements:Array[String] = []
	array_of_replacements.push_back(options)
	#for option in options:
	#	match(string_of_predicate):
	return array_of_replacements;

func on_choice_1_pressed():
	CURRENT_LINE = get_line_index_for_marker(CHOICE_1_MARKER);
	CONVERSATION_UI.done_with_choices();
	run_script__process_line();

func on_choice_2_pressed():
	CURRENT_LINE = get_line_index_for_marker(CHOICE_2_MARKER);
	CONVERSATION_UI.done_with_choices();
	run_script__process_line();

func on_choice_3_pressed():
	CURRENT_LINE = get_line_index_for_marker(CHOICE_3_MARKER);
	CONVERSATION_UI.done_with_choices();
	run_script__process_line();

func on_choice_4_pressed():
	CURRENT_LINE = get_line_index_for_marker(CHOICE_4_MARKER);
	CONVERSATION_UI.done_with_choices();
	run_script__process_line();

func on_action_1_pressed():
	CURRENT_LINE = get_line_index_for_marker(ACTION_1_MARKER);
	CONVERSATION_UI.done_with_actions();
	run_script__process_line();

func on_action_2_pressed():
	CURRENT_LINE = get_line_index_for_marker(ACTION_2_MARKER);
	CONVERSATION_UI.done_with_actions();
	run_script__process_line();

func on_action_3_pressed():
	CURRENT_LINE = get_line_index_for_marker(ACTION_3_MARKER);
	CONVERSATION_UI.done_with_actions();
	run_script__process_line();

func on_action_4_pressed():
	CURRENT_LINE = get_line_index_for_marker(ACTION_4_MARKER);
	CONVERSATION_UI.done_with_actions();
	run_script__process_line();


func on_script_finished():
	if(STATE.ON_QUEST_SCRIPT_DONE!=null):
		STATE.CONVERSATION_SCREEN_CANVAS.hide()
		STATE.CONVERSATION_CONTROL_NODE.hide()
		STATE.ON_QUEST_SCRIPT_DONE.call()
