extends Button

func _on_pressed() -> void:
	if($BOX.visible):
		$BOX.hide()
	else:
		$BOX.show()
