extends Node

var equip_sound = preload("res://SFX/mech_equip.wav")
var dialog_click_sound:AudioStreamWAV= preload("res://SFX/mech_dialogueclick.wav")
var click_sound:AudioStreamWAV= preload("res://SFX/mech_uiclick.wav")
var long_press_sound = preload("res://SFX/mech_uihover.wav")
var long_press_stop = preload("res://SFX/mech_uiclick.wav")
var unequip_sound= preload("res://SFX/mech_equip.wav")
var buy_sound= preload("res://SFX/mech_mechbuy.wav")
var recycle_sound= preload("res://SFX/mech_equip.wav")
var sell_sound= preload("res://SFX/mech_pilotbuy.wav")
var hire_sound= preload("res://SFX/mech_pilotbuy.wav")
var success_sound =  preload("res://SFX/mech_missionsuccess.wav")
var fail_sound=  preload("res://SFX/mech_missionfailure.wav")
var ring_ring_sound= preload("res://SFX/mech_incomingcall2.wav")
var mission_start_sound:AudioStreamWAV=preload("res://SFX/mech_startmission.wav")

var AUDIO_SOURCE:AudioStreamPlayer

func _ready() -> void:
	AUDIO_SOURCE = AudioStreamPlayer.new()
	add_child(AUDIO_SOURCE)

func play_click_sound():
	AUDIO_SOURCE.stream = click_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_dialogue_click_sound():
	AUDIO_SOURCE.stream = dialog_click_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_hire_pilot_sound():
	AUDIO_SOURCE.stream = hire_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_long_press_sound():
	AUDIO_SOURCE.stream = long_press_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_long_press_stop_sound():
	AUDIO_SOURCE.stream = long_press_stop
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_equip_sound():
	AUDIO_SOURCE.stream = equip_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_unequip_sound():
	AUDIO_SOURCE.stream =unequip_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = -5.0

func play_start_mission_sound():
	AUDIO_SOURCE.stream =mission_start_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0

func play_mission_success_sound():
	AUDIO_SOURCE.stream =success_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0


func play_mission_fail_sound():
	AUDIO_SOURCE.stream =fail_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0


func play_ring_ring_sound():
	AUDIO_SOURCE.stream =ring_ring_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0

func play_buy_sound():
	AUDIO_SOURCE.stream =buy_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0

func play_sell_sound():
	AUDIO_SOURCE.stream =sell_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0

func play_recycle_sound():
	AUDIO_SOURCE.stream =recycle_sound
	AUDIO_SOURCE.play()
	AUDIO_SOURCE.volume_db = 0.0
