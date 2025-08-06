extends Button
var timer:Timer

var ON_TIMER_DONE:Callable

func _ready():
	timer = Timer.new()
	timer.one_shot = true;
	timer.connect("timeout",on_timer_done);
	add_child(timer)


func _on_button_down() -> void:
	SFX.play_long_press_sound()
	$AnimationPlayer.play("fill")
	timer.start()


func _on_button_up() -> void:
	SFX.play_long_press_stop_sound()

	$AnimationPlayer.play("idle")
	timer.stop()


func on_timer_done():
	SFX.play_click_sound()
	self.release_focus()
	$AnimationPlayer.play("idle")
	ON_TIMER_DONE.call()
