extends CanvasLayer
class_name StatusBar



func _process(delta: float) -> void:
	#if(STATE.USE_REAL_TIME == false):
			#$StatusBar/MISSION_TIME.text ="%s [INSTANT MODE]" % Time.get_time_string_from_system();
			#$StatusBar/MISSION_STAR_ICON.hide()
			#$StatusBar/MISSION_TIME_ICON.show()

	if(STATE.HAS_MISSION_IN_PROGRESS == true):
		if(STATE.CURRENT_MISSION != null):
			var time_24_hours;
			if(STATE.USE_REAL_TIME == true):
				time_24_hours = 60.0*60.0*24.0
			else:
				time_24_hours = 8.0
			var time_now = Time.get_unix_time_from_system()
			var seconds_left = (int)(STATE.CURRENT_MISSION.time_started + time_24_hours - time_now)

			if(seconds_left <0 && STATE.MISSION_COMPLETE_NOTIFICATION_SENT == false):
				STATE.MISSION_COMPLETE_NOTIFICATION_SENT = true
				if(STATE.MISSIONS_MENU_CANVAS.visible):
					MISSIONS_MENU.show_missions()
			if(seconds_left <0 ):
				$StatusBar/MISSION_LABEL.text = STATE.CURRENT_MISSION.name;
				$StatusBar/MISSION_TIME.text = "[COMPLETE]"

			else:
				$StatusBar/MISSION_TIME.text = "%s REMAINING" % get_24_string_from_seconds(seconds_left);
				$StatusBar/MISSION_LABEL.text = STATE.CURRENT_MISSION.name
			$StatusBar/MISSION_STAR_ICON.show()
			$StatusBar/MISSION_TIME_ICON.hide()
		else:
			$StatusBar/MISSION_LABEL.text = "Current Time"
			$StatusBar/MISSION_TIME.text = "%s [NO ACTIVE MISSION]" %Time.get_time_string_from_system();
			$StatusBar/MISSION_STAR_ICON.hide()
			$StatusBar/MISSION_TIME_ICON.show()
	else:
		$StatusBar/MISSION_LABEL.text = "Current Time"
		$StatusBar/MISSION_TIME.text = "%s [NO ACTIVE MISSION]" % Time.get_time_string_from_system();
		$StatusBar/MISSION_STAR_ICON.hide()
		$StatusBar/MISSION_TIME_ICON.show()

func get_24_string_from_seconds(seconds):
			var display_seconds_left = seconds % 60
			var total_minutes_left = (seconds - (seconds % 60)) / 60
			var display_minutes_left = total_minutes_left % 60
			var hours_left = (total_minutes_left - (total_minutes_left % 60)) / 60
			return "%02d:%02d:%02d" %[hours_left,display_minutes_left,display_seconds_left]
