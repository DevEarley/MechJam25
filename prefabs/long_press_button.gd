extends Button
var timer:Timer

var ON_TIMER_DONE:Callable

func _ready():
	timer = Timer.new()
	timer.one_shot = true;
	timer.connect("timeout",on_timer_done);
	add_child(timer)


func _on_button_down() -> void:
	$AnimationPlayer.play("fill")
	timer.start()


func _on_button_up() -> void:

	$AnimationPlayer.play("idle")
	timer.stop()


func on_timer_done():
	self.release_focus()
	$AnimationPlayer.play("idle")
	ON_TIMER_DONE.call()
