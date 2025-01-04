extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
 # Falls der Bogen ein separater Sprite ist

var is_shooting = false
var last_direction = Vector2(0, 1)  # Standardmäßig nach unten

func _physics_process(delta):
	handle_input()
	move_and_slide()
	update_animation()

func handle_input():
	var axis = Vector2(
		int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft")),
		int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
	)

	if axis != Vector2.ZERO:
		last_direction = axis.normalized()  # Letzte Richtung speichern
		velocity = axis * 300  # Geschwindigkeit (anpassen nach Bedarf)
	else:
		velocity = Vector2.ZERO

	if Input.is_action_pressed("shoot"):
		is_shooting = true
	else:
		is_shooting = false

func update_animation():
	if is_shooting:
		play_shoot_animation()
	else:
		play_walk_animation()

func play_shoot_animation():
	if last_direction.x < 0:
		anim.flip_h = false
		anim.play("shootWalkLeft")  # Rechte Animation spiegeln
	elif last_direction.x > 0:
		anim.flip_h = true
		anim.play("shootWalkLeft")
	elif last_direction.y < 0:
		anim.play("shootWalkUp")
	elif last_direction.y > 0:
		anim.play("shootWalkDown")
	elif velocity == Vector2.ZERO:
		play_still_shoot_animation()

func play_still_shoot_animation():
	if last_direction.x != 0:
		anim.play("shootStillRight")
		anim.flip_h = last_direction.x < 0
	elif last_direction.y > 0:
		anim.play("shootStillDown")
	elif last_direction.y < 0:
		anim.play("shootStillUp")

func play_walk_animation():
	if velocity.x < 0:
		anim.flip_h = true
		anim.play("walkRight")
	elif velocity.x > 0:
		anim.flip_h = false
		anim.play("walkRight")
	elif velocity.y < 0:
		anim.play("walkUp")
	elif velocity.y > 0:
		anim.play("walkDown")
