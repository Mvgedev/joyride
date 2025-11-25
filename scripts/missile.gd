extends Hazard

var hit = false

@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hit == false:
		position.x -= game_manager.missile_speed * delta
	else:
		position.x -= game_manager.zapper_speed * delta

func die():
	print("Should die")
	queue_free()
