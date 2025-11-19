extends HBoxContainer

var max_hp = 3
const EMPTY_HEART = preload("uid://nfdsab71iynd")
const HEART = preload("uid://cyy6p2tpe0pg4")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_heart(current_health):
	for i in range(max_hp):
		print("Value of i: " + str(i))
		var heart = get_child(i)
		heart.texture = HEART if i < current_health else EMPTY_HEART
	pass
	
