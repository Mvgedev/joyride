extends Hazard

func _ready() -> void:
	rotation_spawn()

func rotation_spawn():
	var rot = 0
	var i = randi_range(0,3)
	print("Valeur de i: " + str(i))
	match i:
		0:
			pass
		1:
			rot = -35
		2:
			rot = 90
		3:
			rot = 35
	print("Valeur de rot: " + str(rot))
	global_rotation_degrees = rot
	position.y = randf_range(45, 250)

func _process(delta: float) -> void:
	position.x -= game_manager.zapper_speed * delta
	
