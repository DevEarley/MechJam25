extends Button

func _ready():
	self.connect("pressed",on_back);

func on_back():
	STATE.ON_BACK_BUTTON_PRESSED.call()
