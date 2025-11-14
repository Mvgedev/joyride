extends RigidBody2D

#jetpack values
var max_velocity = -300
var max_downfall = 400
@onready var gpu_particles_2d: CPUParticles2D = $CPUParticles2D

enum EQUIPMENT {JETPACK, CLOUD, MOTO}

var cur_equip = EQUIPMENT.JETPACK

var on_ground = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	match cur_equip:
		EQUIPMENT.JETPACK:
			process_jetpack()
		EQUIPMENT.CLOUD:
			pass
		EQUIPMENT.MOTO:
			pass
	

func process_jetpack():
	var strength = 0
	if Input.is_action_just_pressed("ui_accept"):
		gpu_particles_2d.emitting = true
		if linear_velocity.y > 70:
			linear_velocity.y = linear_velocity.y / 2 # Cut down linear velocity for downfall
	elif Input.is_action_just_released("ui_accept"):
		gpu_particles_2d.emitting = false
		if linear_velocity.y < -70:
			linear_velocity.y = linear_velocity.y / 2
	if Input.is_action_pressed("ui_accept"):
		if linear_velocity.y > max_velocity:
			strength = -650
	apply_force(Vector2(0, strength))
	if linear_velocity.y < max_velocity:
		linear_velocity.y = max_velocity
	elif linear_velocity.y > max_downfall:
		linear_velocity.y = max_downfall


func _on_area_2d_body_entered(_body: Node2D) -> void:
	on_ground = true
	pass # Replace with function body.

func _on_area_2d_body_exited(_body: Node2D) -> void:
	on_ground = false
	pass # Replace with function body.
