extends Hazard

var warning_speed = 2.0
var pos_x = 566.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = get_tree().current_scene.get_node("PlayerCharacter").position.y
	position.x = pos_x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_y = get_tree().current_scene.get_node("PlayerCharacter").position.y
	position.y = lerp(global_position.y, target_y, delta * warning_speed)
