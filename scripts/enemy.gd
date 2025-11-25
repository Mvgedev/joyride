extends Hazard
class_name Enemy

var offset_enemy = 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D

var hit = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = get_tree().current_scene.get_node("Borders/Ground").position.y - offset_enemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hit == false:
		position.x -= game_manager.enemy_speed * delta
	else:
		position.x -= game_manager.zapper_speed * delta

func die():
	animation_player.play("death")
