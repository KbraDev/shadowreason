extends CharacterBody2D


var health = 10

func take_damage(amount: int) -> void: 
	health -= amount
	if health <= 0:
		die()
		
func die() -> void:
	queue_free() 
	
