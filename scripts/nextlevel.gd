extends Area2D

@export var next_Level: String = "res://scenes/world/1cape1.tscn" # ruta del siguiente nivel

func _on_body_entered(body) -> void:
	if body.is_in_group("jugador"): 
		change_Level()

func change_Level(): 
	get_tree().change_scene_to_file(next_Level)
