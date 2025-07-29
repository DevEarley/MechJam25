extends SubViewportContainer

var timer:Timer



func _ready():
	self.position  =Vector2.ZERO
	self.scale = Vector2.ONE;
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.24
	timer.timeout.connect(_on_view_port_resize_timer_timeout)
	get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()



func _on_viewport_resize():
	timer.start()

func _on_view_port_resize_timer_timeout():
	var window_size = get_window().size
	var ratio_x =  window_size.x /  1280.0
	var ratio_y =  window_size.y /  720.0
	if(ratio_x > 1):
		if(ratio_y > 1):
			if(ratio_x * 720 <  window_size.y):
				self.scale = Vector2(ratio_x,ratio_x)
				position_about_y(ratio_x,window_size)

			else:
				if(ratio_y * 1280 <  window_size.x):
					self.scale = Vector2(ratio_y,ratio_y)
					var x_difference = window_size.x - (ratio_y * 1280);
					self.position.x = x_difference/2.0
					self.position.y = 0
		else:
			self.scale = Vector2.ONE;
			var x_difference = window_size.x - (ratio_y * 1280);
			self.position.x = x_difference/2.0
			self.position.y = 0
	else:
		self.position  =Vector2.ZERO
		self.scale = Vector2.ONE;
		if(ratio_y > 1):
			position_about_y(ratio_x,window_size)

func position_about_y(ratio_x,window_size):
		var y_difference = window_size.y - (ratio_x * 720);
		self.position.y = y_difference/2.0
		self.position.x = 0
