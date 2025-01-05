extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Sprite-Node
@export var is_shooting = false
var last_direction = Vector2(0, 1)  # Standardmäßig nach unten

func _physics_process(delta):
	handle_input()
	move_and_slide()
	update_animation()

func handle_input():
	# Bewegungslogik
	var axis = Vector2(
		int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft")),
		int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
	)

	if axis != Vector2.ZERO:
		velocity = axis * 150  # Geschwindigkeit (anpassen nach Bedarf)
	else:
		velocity = Vector2.ZERO

	# Richtung zur Maus aktualisieren
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	last_direction = mouse_direction

	# Schießen-Status
	is_shooting = Input.is_action_pressed("shoot")

func update_animation():
		if velocity == Vector2.ZERO:
			anim.play("idle")
		else:
			play_walk_animation(last_direction)





func play_walk_animation(direction: Vector2):
	if direction.x < -0.5:
		anim.flip_h = true
		anim.play("walkRight")
	elif direction.x > 0.5:
		anim.flip_h = false
		anim.play("walkRight")
	elif direction.y < -0.5:
		anim.play("walkUp")
	elif direction.y > 0.5:
		anim.play("walkDown")
