extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"): 
		body.is_gravity_inverted = true
		var tween = get_tree().create_tween()
		tween.tween_property(body, "scale:y", -body.scale.y, 0.5) #1 segundo de rotacion
		print("gravedad invertida")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"): 
		body.is_gravity_inverted = false
		var tween = get_tree().create_tween()
		tween.tween_property(body, "scale:y", -body.scale.y, 0.2) #1 segundo de rotacion
		print("gravedad normal")
