extends CharacterBody2D

var health = 100

func _ready() -> void:
	print("Enemigo listo con vida: ", health)

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemigo recibió daño. Vida restante: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("Enemigo derrotado")
	queue_free()
