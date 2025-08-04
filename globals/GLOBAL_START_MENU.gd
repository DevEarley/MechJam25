extends Node

var BUTTON_PREFAB = preload("res://prefabs/left-hand-button.tscn")

func show_start_menu():
	var color = Vector3(0.0,1.0,170.0/255.0)
	MISSIONS_MENU.MAP_MATERIAL.set_shader_parameter("ENVIRONMENT_TINT",color);
	MAP.ANIMATOR.play("idle")
	MAP.CURSOR.hide()
	STATE.START_MENU_CANVAS.show()
	STATUS_BAR.update_status()
	STATE.STATUS_BAR_CANVAS.show()
	STATE.START_MENU_CANVAS.get_node("VOICEMAIL/BOX").visible = false
	for child in STATE.START_MENU_CANVAS.get_node("VOICEMAIL/BOX/ScrollContainer/VBoxContainer").get_children():
		child.queue_free()
	var count = 0
	for voicemail:Voicemail in STATE.VOICEMAILS:
		var status_text = ""
		var button:Button = BUTTON_PREFAB.instantiate()
		if(voicemail.status == ENUMS.VOICEMAIL_STATUS.UNHEARD):
			count +=1;
			status_text="NEW"
			button.text = "%s [%s]" %[voicemail.from,status_text]

		elif(voicemail.status == ENUMS.VOICEMAIL_STATUS.HEARD):
			count +=1;
			status_text="OLD"
			button.text = "%s [%s]" %[voicemail.from,status_text]
		else:
			button.text = "???"
			button.disabled = true;
		button.custom_minimum_size = Vector2(400,0)
		button.connect("pressed",on_play_voicemail.bind(voicemail))
		STATE.START_MENU_CANVAS.get_node("VOICEMAIL/BOX/ScrollContainer/VBoxContainer").add_child(button)
	STATE.START_MENU_CANVAS.get_node("VOICEMAIL").text = "VOICEMAILS [%s]" % count
func on_callback_done():
	DATA.save_everything()
	show_start_menu()

func on_voice_mail_done(voicemail:Voicemail):
	STATE.ON_QUEST_SCRIPT_DONE = on_callback_done
	voicemail.status = ENUMS.VOICEMAIL_STATUS.HEARD
	var callback_script = "say[Call back?]\n
		choices[Yes! Call them back.,No! Don't call them back.]\n
		[Yes! Call them back.]\n
		%s\n
		go[end]\n
		[No! Don't call them back.]\n
		[end]\n
		say[*Click*]\n" % voicemail.callback_script
	QS.run_script(callback_script)

func on_play_voicemail(voicemail:Voicemail ):
	STATE.START_MENU_CANVAS.hide()
	STATE.STATUS_BAR_CANVAS.hide()
	STATE.ON_QUEST_SCRIPT_DONE = on_voice_mail_done.bind(voicemail)
	QS.run_script(voicemail.voicemail_script);
