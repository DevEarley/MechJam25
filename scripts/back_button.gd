extends Button

func _ready():
	self.connect("pressed",on_back);

func on_back():
	SFX.play_click_sound()

	STATE.ON_BACK_BUTTON_PRESSED.call()
