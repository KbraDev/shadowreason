extends CharacterBody2D

var health = 100
@export var max_health = 100

@onready var health_bar = $HealthBar

func _ready() -> void:
	health = max_health
	update_health_bar()

func take_damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, max_health)
	update_health_bar()
	health_bar.visible = true
	
	# Ocultar la barra después de un tiempo
	if health == 0:
		die()

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health

func die() -> void:
	print("Enemigo derrotado")
	queue_free()
