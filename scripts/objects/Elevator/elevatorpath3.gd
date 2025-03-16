extends PathFollow2D

@export var speed: float = 50.0
var active: bool = false # si el jugador no esta en el elevador


func _process(delta: float) -> void:
	if active: 
		progress += speed * delta
	elif progress > 01: # Si no hay jugador y el elevador no esta en su punto de inicio debe bajar
		progress -= speed * delta
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		active = false
