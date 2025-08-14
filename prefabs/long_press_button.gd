extends Button
var timer:Timer

var ON_TIMER_DONE:Callable

func _ready():
	timer = Timer.new()
	timer.one_shot = true;
	timer.wait_time= 0.45
	timer.connect("timeout",on_timer_done);
	add_child(timer)


func _on_button_down() -> void:
	SFX.play_long_press_sound()
	$AnimationPlayer.play("fill")
	timer.start()
	$NinePatchRect.modulate = Color(1,1,1)


func _on_button_up() -> void:
	SFX.play_long_press_stop_sound()

	$AnimationPlayer.play("idle")
	timer.stop()


func on_timer_done():
	SFX.play_click_sound()
	self.release_focus()
	$AnimationPlayer.play("idle")
	ON_TIMER_DONE.call()

func disable():
	self.disabled = true
	$NinePatchRect.modulate = Color(0,0,0,0.2)

func enable():
	self.disabled = false
	$NinePatchRect.modulate = Color(1,1,1,1)


func _on_focus_entered() -> void:
	if(self.disabled == true):
		self.release_focus()


func _on_mouse_entered() -> void:
	$NinePatchRect.modulate = Color(0.0,1.0,170.0/255.0)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	$NinePatchRect.modulate = Color(1,1,1)

	pass # Replace with function body.
