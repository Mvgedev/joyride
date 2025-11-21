extends Node

# Hazard management
enum HAZARD_TYPE {NONE, ZAPPER, ENEMY, MISSILE}
var last_hazard = HAZARD_TYPE.NONE
var missile_launched = false

# Hazard resources
var ZAPPER = preload("res://scenes/zapper.tscn")
var ENEMY = preload("res://scenes/enemy.tscn")
var MISSILE = preload("res://scenes/missile.tscn")
var MISSILE_WARNING = preload("res://scenes/missile_warning.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func rand_hazard() -> Node2D:
	var rand_hzrd = randi_range(1, HAZARD_TYPE.size() - 1)
	print("Print hazard: " + str(rand_hzrd) + " And missile launched = " + str(missile_launched))
	if (rand_hzrd != last_hazard and rand_hzrd != HAZARD_TYPE.MISSILE) or (rand_hzrd == HAZARD_TYPE.MISSILE and missile_launched == false):
		if rand_hzrd == HAZARD_TYPE.MISSILE and missile_launched == false:
			missile_launched = true
		return get_hazard(rand_hzrd)
	else:
		return get_hazard(HAZARD_TYPE.ZAPPER)

func get_hazard(hazard_type : HAZARD_TYPE) -> Node2D:
	var ret = null
	match hazard_type:
		HAZARD_TYPE.NONE:
			pass
		HAZARD_TYPE.ZAPPER:
			ret = ZAPPER.instantiate()
		HAZARD_TYPE.ENEMY:
			ret = ENEMY.instantiate()
		HAZARD_TYPE.MISSILE:
			ret = MISSILE_WARNING.instantiate()
	last_hazard = hazard_type
	return ret
