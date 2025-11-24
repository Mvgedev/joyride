extends Hazard

@onready var countdown_to_missile: Timer = $CountdownToMissile

var warning_speed = 2.0
var pos_x = 566.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = get_tree().current_scene.get_node("PlayerCharacter").position.y
	position.x = pos_x
	countdown_to_missile.start(4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_tree().current_scene.get_node_or_null("PlayerCharacter")
	if player != null:
		var target_y = player.position.y
		position.y = lerp(global_position.y, target_y, delta * warning_speed)


func _on_countdown_to_missile_timeout() -> void:
	game_manager.shoot_missile(position.y)
	queue_free()
