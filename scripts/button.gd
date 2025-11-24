extends TextureButton

@onready var label: Label = $Label

var pressing = false
var initialpos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialpos = label.position.y
	pass # Replace with function body.

func set_text(text):
	label.text = text

func _on_button_down() -> void:
	pressing = true
	adjust_label_height(true)

func _on_button_up() -> void:
	pressing = false
	adjust_label_height(false)

func adjust_label_height(press):
	if press == true:
		label.position.y += 3
	else:
		if label.position.y != initialpos:
			label.position.y -= 3

func _on_mouse_entered() -> void:
	if pressing == true:
		adjust_label_height(true)


func _on_mouse_exited() -> void:
	if pressing == true:
		adjust_label_height(false)
