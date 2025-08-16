extends Button



func _on_pressed() -> void:
	DATA.save_everything(true)
	STATE.ON_BACK_BUTTON_PRESSED.call()
	SFX.play_mission_success_sound()
