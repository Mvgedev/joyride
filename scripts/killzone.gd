extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	get_tree().current_scene.get_node("GameManager").damage()
	var parent = get_parent()
	if parent is Enemy or parent is Missile:
		parent.die()
