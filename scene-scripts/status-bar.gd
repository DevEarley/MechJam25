extends CanvasLayer
class_name StatusBar



func _process(delta: float) -> void:
	if(STATE.USE_REAL_TIME == false):
			$StatusBar/MISSION_TIME.text ="%s [INSTANT MODE]" % Time.get_time_string_from_system();
			$StatusBar/MISSION_STAR_ICON.hide()
			$StatusBar/MISSION_TIME_ICON.show()

	elif(STATE.HAS_MISSION_IN_PROGRESS == true):
		if(STATE.CURRENT_MISSION != null):
			var time_24_hours = 60.0*60.0*24.0
			var time_now = Time.get_unix_time_from_system()
			var seconds_left = (int)(STATE.CURRENT_MISSION.time_started + time_24_hours - time_now)
			$StatusBar/MISSION_STAR_ICON.show()
			$StatusBar/MISSION_TIME_ICON.hide()
			$StatusBar/MISSION_TIME.text = "%s REMAINING [%s]" % [get_24_string_from_seconds(seconds_left) ,STATE.CURRENT_MISSION.name];
		else:
			$StatusBar/MISSION_TIME.text = "%s [NO ACTIVE MISSION]" %Time.get_time_string_from_system();
			$StatusBar/MISSION_STAR_ICON.hide()
			$StatusBar/MISSION_TIME_ICON.show()
	else:
		$StatusBar/MISSION_TIME.text = "%s [NO ACTIVE MISSION]" % Time.get_time_string_from_system();
		$StatusBar/MISSION_STAR_ICON.hide()
		$StatusBar/MISSION_TIME_ICON.show()

func get_24_string_from_seconds(seconds):
			var display_seconds_left = seconds % 60
			var total_minutes_left = (seconds - (seconds % 60)) / 60
			var display_minutes_left = total_minutes_left % 60
			var hours_left = (total_minutes_left - (total_minutes_left % 60)) / 60
			return "%02d:%02d:%02d" %[hours_left,display_minutes_left,display_seconds_left]
