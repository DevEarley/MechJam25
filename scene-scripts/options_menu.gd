extends Node
class_name OptionsMenu;

var last_script =""

func _ready():
	$MUSIC_SLIDER.connect("value_changed", on_music_slider_changed);
	$SFX_SLIDER.connect("value_changed", on_SFX_slider_changed);
	$SFX_SLIDER.connect("drag_ended", on_SFX_slider_drag_ended);

func on_music_slider_changed(value):
	MUSIC.AUDIO_SOURCE.volume_linear = value
	STATE.MUSIC_VOLUME = value
	$MUSIC_VALUE.text = "%03d%%" % (value *100)

func on_SFX_slider_changed(value):
	SFX.AUDIO_SOURCE.volume_linear = value
	STATE.SFX_VOLUME =value
	$SFX_VALUE.text = "%03d%%" % (value *100)

func on_SFX_slider_drag_ended(value):
	SFX.play_dialogue_click_sound()
