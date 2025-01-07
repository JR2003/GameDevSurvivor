extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Sprite-Node
@onready var xp_bar = $Control/ProgressBar# XP-Bar Referenz (Pfad anpassen)
@export var is_shooting = false
@onready var label = $Control/ProgressBar/Label
var last_direction = Vector2(0, 1)  # Standardmäßig nach unten
var exp = 0
var level = 1
var exp_to_next_level = 100
var weapon = null

func _ready() -> void:
	weapon = get_node("Weapon2")
	update_exp_label()

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
		
func gain_exp(amount: int) -> void:
	exp += amount
	print("EXP erhalten: ", amount, "| Gesamte EXP: ", exp)

	# XP-Bar aktualisieren
	xp_bar.value = exp
	
	if exp >= exp_to_next_level:
		level_up()
		update_exp_label()
	else:
		update_exp_label()

func level_up() -> void:
	weapon.upgrade()
	level += 1
	exp -= exp_to_next_level
	exp_to_next_level *= 1.5
	print("Level-Up! Neues Level: ", level)

	# XP-Bar zurücksetzen oder aktualisieren
	xp_bar.value = exp  # Setze die XP-Bar auf den neuen EXP-Wert

func update_exp_label() -> void:
	label.text = str(exp) + " / " + str(exp_to_next_level)  # Setze den Text im Label
