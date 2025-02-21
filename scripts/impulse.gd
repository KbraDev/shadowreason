extends Area2D

@export var impulse_strength: float = 1300.00

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		print('entro en la zona de impuslo')
		body.velocity.y -= impulse_strength
