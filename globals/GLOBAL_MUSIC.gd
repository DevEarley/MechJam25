extends Node

var TRACK_POSITION:float = 0.0;

var main_menu_music= preload("res://music/MechJam-JE-Theme-1-Var-2.ogg")
var start_menu_music= preload("res://music/MechJam-JE-Theme-1-Var-2.ogg")
var mech_menu_music= preload("res://music/MechJam-JE-Theme-1-Var-1.ogg")
var part_menu_music= preload("res://music/MechJam-JE-Theme-1-Var-1.ogg")
var pilot_menu_music= preload("res://music/MechJam-JE-Theme-1-Var-1.ogg")
var mission_menu_music= preload("res://music/TGEMech1.ogg")
var conversation_menu_music= preload("res://music/TGEMech2.ogg")

var AUDIO_SOURCE:AudioStreamPlayer

func _ready() -> void:
	AUDIO_SOURCE = AudioStreamPlayer.new()
	add_child(AUDIO_SOURCE)

func play_music_for_main_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = main_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = 0.0

func play_music_for_start_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = start_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = -5.0

func play_music_for_part_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = part_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = 0.0

func play_music_for_mech_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = mech_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = 0.0

func play_music_for_pilot_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = pilot_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = 0.0

func play_music_for_mission_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = mission_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = -10.0

func play_music_for_conversation_menu():
	TRACK_POSITION = AUDIO_SOURCE.get_playback_position()
	AUDIO_SOURCE.stream = conversation_menu_music
	AUDIO_SOURCE.play(TRACK_POSITION)
	AUDIO_SOURCE.volume_db = -10.0
