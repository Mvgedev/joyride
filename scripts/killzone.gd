extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Ouch" + str(body.get_parent()))                   
	get_tree().current_scene.get_node("GameManager").damage()
				
