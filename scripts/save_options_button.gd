extends Button



func _on_pressed() -> void:
	DATA.save_game_state_to_user_data()
	STATE.ON_BACK_BUTTON_PRESSED.call()
