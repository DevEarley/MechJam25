extends CanvasLayer
class_name StatusBar


func _process(delta: float) -> void:
	if(STATE.USE_REAL_TIME == false):
			$StatusBar/MISSION_TIME.text = Time.get_time_string_from_system();

	elif(STATE.HAS_MISSION_IN_PROGRESS == true):
		if(STATE.CURRENT_MISSION != null):
			var time_24_hours = 60.0*60.0*24.0
			var time_now = Time.get_unix_time_from_system()
			var seconds_left = (int)(STATE.CURRENT_MISSION.time_started + time_24_hours - time_now)
			$StatusBar/MISSION_TIME.text = get_24_string_from_seconds(seconds_left);

func get_24_string_from_seconds(seconds):
			var display_seconds_left = seconds % 60
			var total_minutes_left = (seconds - (seconds % 60)) / 60
			var display_minutes_left = total_minutes_left % 60
			var hours_left = (total_minutes_left - (total_minutes_left % 60)) / 60
			return "%02d:%02d:%02d" %[hours_left,display_minutes_left,display_seconds_left]
