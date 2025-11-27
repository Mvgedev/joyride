extends Node


# Player
@onready var player_character: RigidBody2D = $"../PlayerCharacter"

# GUI
@onready var game_over: Control = $"../CanvasLayer/Game Over"
@onready var ground: Parallax2D = $"../Landscape/Ground"
@onready var wall: Parallax2D = $"../Landscape/Wall"
@onready var pipes_lights: Parallax2D = $"../Landscape/Pipes_lights"
@onready var shadows: Parallax2D = $"../Landscape/Shadows"


@onready var score: Label = $"../CanvasLayer/Control/Score"
@onready var best_score: Label = $"../CanvasLayer/Control/Best Score"

# GUI HP
@onready var heart_bar: HBoxContainer = $"../CanvasLayer/Control/Heart Bar"

# Heart sprite
const HEART = preload("uid://cyy6p2tpe0pg4")
const EMPTY_HEART = preload("uid://nfdsab71iynd")

# Scoring
var time_accumulator = 0 # Cumuled time from delta
var increment_rate = 5 # Scoring event per second
var game_ended = false

# Flashing damage
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"

# Spawners
@onready var border_right: Area2D = $"../Borders/BorderRight"

# Hazard Manager
@onready var hazard_manager: Node = $HazardManager
var zapper_speed = 70
var enemy_speed = 110
var missile_speed = 200
@onready var spawn_timer: Timer = $SpawnTimer
var spawn_delay = 2.3

@onready var gameover_sound: AudioStreamPlayer2D = $"../gameover_sound"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreSystem.cur_score = 0
	update_score()
	update_pb()
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

func shoot_missile(pos_y):
	var missile = hazard_manager.get_hazard(hazard_manager.HAZARD_TYPE.MISSILE)
	missile.game_manager = self
	get_tree().current_scene.get_node("Hazards").call_deferred("add_child", missile)
	missile.position.x = border_right.position.x
	missile.position.y = pos_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_accumulator += delta
	
	var interval = 1.0 / increment_rate
	var gained_score = false
	if game_ended == true:
		return
	while time_accumulator >= interval:
		time_accumulator -= interval
		gain_score()
		gained_score = true
	if gained_score == true:
		update_score()
		if ScoreSystem.cur_score % 500 == 0:
			increase_gamespeed()
	

func damage():
	var defeated = player_character.damaged()
	if defeated == true:
		end_game()
	update_hp()

func increase_gamespeed():
	# Score speed increase
	increment_rate = increment_rate * 1.25
	# Parallax speed increase
	ground.autoscroll = Vector2(ground.autoscroll.x * 1.25, 0.0)
	wall.autoscroll = Vector2(wall.autoscroll.x * 1.25, 0.0)
	shadows.autoscroll = Vector2(shadows.autoscroll.x * 1.25, 0.0)
	pipes_lights.autoscroll = Vector2(pipes_lights.autoscroll.x * 1.25, 0.0)
	
	# Hazard speed increase
	zapper_speed = zapper_speed * 1.25
	enemy_speed = enemy_speed * 1.25
	missile_speed = missile_speed * 1.25
	# Hazard spawn increase
	if spawn_delay > 0.5:
		if spawn_delay * 0.8 >= 0.5:
			spawn_delay = spawn_delay * 0.8
		else:
			spawn_delay = 0.5

func gain_score():
	ScoreSystem.cur_score += 1

func update_score():
	var sc = ScoreSystem.cur_score
	var print_score = ScoreSystem.get_score_string(sc)
	score.text = print_score

func update_pb():
	var pb = ScoreSystem.pb_score
	var print_pb = ScoreSystem.get_score_string(pb)
	best_score.text = "BEST: " + print_pb

func end_game():
	gameover_sound.play()
	game_ended = true
	player_character.explosion()
	stop_hazard()
	stop_parallax()
	if ScoreSystem.cur_score > ScoreSystem.pb_score:
		ScoreSystem.pb_score = ScoreSystem.cur_score
		update_pb()
		ScoreSystem.save_score()
	game_over.update_gameover()
	game_over.visible = true

func stop_hazard():
	spawn_timer.stop()
	zapper_speed = 0
	enemy_speed = 0
	missile_speed = 0

func stop_parallax():
	ground.autoscroll = Vector2(0.0,0.0)
	wall.autoscroll = Vector2(0.0,0.0)
	pipes_lights.autoscroll = Vector2(0.0,0.0)
	shadows.autoscroll = Vector2(0.0,0.0)

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
