extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	print("Ouch")
	get_tree().current_scene.get_node("GameManager").damage()
