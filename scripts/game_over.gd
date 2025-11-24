extends Control

signal retry()
@onready var retry_button: TextureButton = $TextureRect/VBoxContainer/Retry
@onready var quit_button: TextureButton = $TextureRect/VBoxContainer/Quit
@onready var label_2: Label = $TextureRect/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_button.set_text("Try Again")
	quit_button.set_text("Quit to menu")
	pass # Replace with function body.

func update_gameover():
	var cur = ScoreSystem.cur_score
	var pb = ScoreSystem.pb_score
	label_2.text = "Your score is: " + ScoreSystem.get_score_string(cur) + "\n" + "Your best score is: " + ScoreSystem.get_score_string(pb)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	emit_signal("retry")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
