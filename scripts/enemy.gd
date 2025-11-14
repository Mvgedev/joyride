extends Hazard

var offset_enemy = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = get_tree().current_scene.get_node("Borders/Ground").position.y - offset_enemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= game_manager.enemy_speed * delta
