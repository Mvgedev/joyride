extends Node

@onready var bgm: AudioStreamPlayer2D = $BGM
const MENUTHEME = preload("uid://5sfohkrbuair")
const E_2M_1_TRIBUTE = preload("uid://dwm8j4lu2455d")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func stop_bgm():
	bgm.stop()

func play_bgm(song):
	if bgm.playing == true:
		stop_bgm()
	bgm.stream = song
	bgm.play()
