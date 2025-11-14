extends Node

# Spawners
@onready var border_right: Area2D = $"../Borders/BorderRight"

# Hazard Manager
@onready var hazard_manager: Node = $HazardManager
var zapper_speed = 70
var enemy_speed = 110
var missile_speed = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_hazard()
	await get_tree().create_timer(1.3).timeout
	spawn_hazard()
	await get_tree().create_timer(1.3).timeout
	spawn_hazard()
	await get_tree().create_timer(1.3).timeout
	spawn_hazard()

func spawn_hazard():
	var hazard = hazard_manager.rand_hazard()
	if hazard != null:
		hazard.game_manager = self
		get_tree().current_scene.get_node("Hazards").call_deferred("add_child", hazard)
		hazard.position.x = border_right.position.x

func rand_hazard() -> Node2D:
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_border_left_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	spawn_hazard()
