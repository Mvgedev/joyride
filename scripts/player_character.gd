extends RigidBody2D

@onready var game_manager: Node = %GameManager

#jetpack values
var max_velocity = -300
var max_downfall = 400
@onready var gpu_particles_2d: CPUParticles2D = $CPUParticles2D

# MachineGun Handling
@onready var machine_gun_ray_cast: RayCast2D = $MachineGunRayCast
signal machine_gun_hit(body)

# Animations
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


enum EQUIPMENT {JETPACK, CLOUD, MOTO}
var cur_equip = EQUIPMENT.JETPACK

# Ground detector
var on_ground = false
var jetpack = false

# Character stats
var health = 3
var shield = false
var intangible = false
var dead = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if machine_gun_ray_cast.is_colliding():
		if  machine_gun_ray_cast.get_collider() != null:
			var collider = machine_gun_ray_cast.get_collider().get_parent()
			if collider.hit == false:
				emit_signal("machine_gun_hit", collider)
				collider.hit = true



func _physics_process(_delta: float) -> void:
	if dead == false:
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
		jetpack = true
		machine_gun_ray_cast.enabled = true
		gpu_particles_2d.emitting = true
		if linear_velocity.y > 70:
			linear_velocity.y = linear_velocity.y / 2 # Cut down linear velocity for downfall
		update_anim()
	elif Input.is_action_just_released("ui_accept"):
		jetpack = false
		machine_gun_ray_cast.enabled = false
		gpu_particles_2d.emitting = false
		if linear_velocity.y < -70:
			linear_velocity.y = linear_velocity.y / 2
		update_anim()
	if Input.is_action_pressed("ui_accept"):
		if linear_velocity.y > max_velocity:
			strength = -650
	apply_force(Vector2(0, strength))
	if linear_velocity.y < max_velocity:
		linear_velocity.y = max_velocity
	elif linear_velocity.y > max_downfall:
		linear_velocity.y = max_downfall

func damaged() -> bool:
	if intangible == false and dead == false:
		if shield == true:
			shield = false
		else:
			health -= 1
			game_manager.screen_shake()
		if health < 1:
			dead = true
			return true # Player is defeated
		else:
			animation_player.play("Intangibility")
	return false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	on_ground = true
	if dead == false:
		update_anim()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	on_ground = false
	if dead == false:
		update_anim()


func update_anim():
	if jetpack:
			animated_sprite_2d.animation = "Hurricane"
	else:
		if on_ground:
			animated_sprite_2d.animation = "Running"
		else:
			animated_sprite_2d.animation = "Flying"

func explosion():
	animated_sprite_2d.play("Explosion")

func intangibility_on():
	intangible = true
	
func intangibility_over():
		intangible = false


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
