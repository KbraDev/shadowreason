extends PathFollow2D

@export var speed: float = 50.0
var active: bool = false # si el jugador no esta en el elevador

@onready var animation = $Elevator/AnimatedSprite2D # se accede al nodo de animaciones

func _process(delta: float) -> void:
	if active: 
		progress += speed * delta
	elif progress > 01: # Si no hay jugador y el elevador no esta en su punto de inicio debe bajar
		progress -= speed * delta
		if progress <= 0.1: 
			animation.play("idle")


func _on_path_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		active = true
		animation.play("ascended")


func _on_path_start_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		active = false
		animation.play("idle")
