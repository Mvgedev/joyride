extends Node


# Player
@onready var player_character: RigidBody2D = $"../PlayerCharacter"

# GUI
@onready var game_over: Control = $"../CanvasLayer/Game Over"
@onready var ground: Parallax2D = $"../Landscape/Ground"
@onready var score: Label = $"../CanvasLayer/Control/Score"
@onready var best_score: Label = $"../CanvasLayer/Control/Best Score"

# GUI HP
@onready var heart_bar: HBoxContainer = $"../CanvasLayer/Control/Heart Bar"

# Heart sprite
const HEART = preload("uid://cyy6p2tpe0pg4")
const EMPTY_HEART = preload("uid://nfdsab71iynd")


# Flashing damage
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"

# Spawners
@onready var border_right: Area2D = $"../Borders/BorderRight"

# Hazard Manager
@onready var hazard_manager: Node = $HazardManager
var zapper_speed = 70
var enemy_speed = 110
var missile_speed = 150
@onready var spawn_timer: Timer = $SpawnTimer
var spawn_delay = 2.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over.connect("retry", retry)
	player_character.connect("machine_gun_hit", machine_gun_hit)
	update_hp()
	color_rect.modulate.a = 0
	color_rect.visible = true
	spawn_timer.start(spawn_delay)

func spawn_hazard():
	var hazard = hazard_manager.rand_hazard()
	if hazard != null:
		hazard.game_manager = self
		get_tree().current_scene.get_node("Hazards").call_deferred("add_child", hazard)
		hazard.position.x = border_right.position.x

func rand_hazard() -> Node2D:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func damage():
	var defeated = player_character.damaged()
	if defeated == true:
		end_game()
	update_hp()

func end_game():
	player_character.explosion()
	spawn_timer.stop()
	zapper_speed = 0
	enemy_speed = 0
	missile_speed = 0
	# Stop BG moving
	ground.autoscroll = Vector2(0.0,0.0)
	game_over.visible = true

func retry():
	get_tree().reload_current_scene()


func update_hp():
	heart_bar.update_heart(player_character.health)

func screen_shake():
	color_rect.modulate.a = 1
	color_rect.create_tween().tween_property(color_rect, "modulate:a", 0.0, 0.2)

func _on_border_left_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()

func machine_gun_hit(body):
	if body != null:
		body.collision_shape_2d.disabled = true
		body.die()

func _on_spawn_timer_timeout() -> void:
	print("Timer off!")
	spawn_hazard()
	spawn_timer.start(spawn_delay)
