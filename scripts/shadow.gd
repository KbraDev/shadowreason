extends CharacterBody2D

const speed = 400.0
const jump_velocity = -400.0

# Variables de ataques
var attack_state = 0
var attack_cooldown = 0.1 # Duración entre ataques
var can_attack = true
var is_attacking = false
var attack_reset_time = 2.0 # Tiempo de inactividad para reiniciar ataques

@onready var attack_area = $AttackArea2D
@onready var attack_area_shape = attack_area.get_node("CollisionShape2D")

@onready var animation = $AnimatedSprite2D
@onready var reset_attack_timer = Timer.new()

# Diccionario con la duración de cada animación
var animation_durations = {
	"attack1": 0.5,
	"attack2": 0.3,
	"attack3": 0.4
}

func _ready() -> void:
	animation.play("idle")
	
	# Configurar el temporizador para reiniciar ataques
	add_child(reset_attack_timer)
	reset_attack_timer.one_shot = true
	reset_attack_timer.wait_time = attack_reset_time
	reset_attack_timer.connect("timeout", Callable(self, "_on_reset_attack_timer_timeout"))
	
	# conectar la senal body_entered del Area2D
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_2d_body_entered"))


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement()
	if not is_attacking:
		handle_animation()
	if Input.is_action_just_pressed("attack") and can_attack:
		handle_attack()
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_movement() -> void:
	# Saltos
	if Input.is_action_just_pressed("jump") and not is_attacking:
		velocity.y = jump_velocity

	# Movimiento horizontal
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	velocity.x = direction * speed if direction != 0 else move_toward(velocity.x, 0, speed)

	# Voltear el sprite según la dirección
	if direction != 0:
		animation.flip_h = direction < 0

func handle_animation() -> void:
	if not is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")

func handle_attack() -> void:
	can_attack = false
	is_attacking = true

	# Reproducir la animación basada en el estado de ataque actual
	var current_animation = ""
	match attack_state:
		0:
			current_animation = "attack1"
		1:
			current_animation = "attack2"
		2:
			current_animation = "attack3"
	animation.play(current_animation)
	
	#activar el area2d
	attack_area.monitoring = true
	
	if attack_area.monitoring == false:
		print("desactivada")
	else: 
		print("ataque activa la area2d")

	# Incrementar el estado de ataque
	attack_state = (attack_state + 1) % 3

	# Reiniciar el temporizador de inactividad de ataques
	reset_attack_timer.start()

	# Obtener la duración de la animación
	var animation_duration = animation_durations.get(current_animation, 0.5)

	# Iniciar un temporizador para finalizar el ataque y reactivar el ataque
	await get_tree().create_timer(animation_duration).timeout
	
	# desactivar el area2d
	attack_area.monitoring = false
	
	is_attacking = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_reset_attack_timer_timeout() -> void:
	# Reiniciar el estado de ataque si no se usa en el tiempo definido
	attack_state = 0


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		print("ataque al enemigo: ", body.name)
