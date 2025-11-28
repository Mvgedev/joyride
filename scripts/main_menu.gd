extends Node2D

@onready var score: Label = $CanvasLayer/Control/Score
@onready var play_button: TextureButton = $CanvasLayer/Control/VBoxContainer/PlayButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BgmPlayer.play_bgm(BgmPlayer.MENUTHEME)
	play_button.set_text("Play")
	update_score()

func update_score():
	var pb = ScoreSystem.pb_score
	var print_pb = ScoreSystem.get_score_string(pb)
	score.text = "BEST SCORE: " + print_pb
	pass

func _on_play_button_pressed() -> void:
	BgmPlayer.stop_bgm()
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
