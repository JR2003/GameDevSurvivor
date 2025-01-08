extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Sprite-Node
@onready var xp_bar = $Control/ProgressBar# XP-Bar Referenz (Pfad anpassen)
@export var is_shooting = false

@onready var exp_label = $Control/ProgressBar/Exp
@onready var hp_label = $Control/ProgressBar/Health

@onready var bow_sound = $Weapon2/ShotSound

@onready var upgrade_popup = $Camera2D/LevelUpMenu
@onready var up_damage_button = $Camera2D/LevelUpMenu/Damage
@onready var up_attack_speed_button = $Camera2D/LevelUpMenu/AttackSpeed
@onready var up_pierce_button = $Camera2D/LevelUpMenu/Pierce



var last_direction = Vector2(0, 1)  # Standardmäßig nach unten
var exp = 0
var level = 1
var exp_to_next_level = 100
var weapon = null
var arrow = null
var health = 3
var damage_cd = 1.0
var getting_damage = false

func _ready() -> void:
	weapon = get_node("Weapon2")
	arrow = get_node("Arrow")
	update_exp_label()
	update_hp_label()
	

func _physics_process(delta):
	handle_input()
	move_and_slide()
	update_animation()
	if getting_damage:
		damage_cd += delta
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
	if health <= 0:
		anim.play("die")
		await anim.animation_looped
		
		
		
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
	level += 1
	exp = 0
	exp_to_next_level *= 1.5
	print("Level-Up! Neues Level: ", level)
	get_tree().paused = true
	upgrade_popup.show()
	upgrade_popup.popup_centered()
	# XP-Bar zurücksetzen oder aktualisieren
	xp_bar.value = exp  # Setze die XP-Bar auf den neuen EXP-Wert

func update_exp_label() -> void:
	exp_label.text = str(exp) + " / " + str(exp_to_next_level)  # Setze den Text im Label

func update_hp_label() -> void:
	hp_label.text = str(health) + " / " + str(3) 

func get_damage(amount: int):
	if damage_cd >= 1:
		health -= amount
		damage_cd = 0
	update_hp_label()  # Setze den Text im Label
	if health <= 0:
		die()
	
func die():
	
	update_animation()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		get_damage(1)
		getting_damage = true
		

	
func resume_game() -> void:
	upgrade_popup.hide()
	get_tree().paused = false


func _on_damage_pressed() -> void:
	print("DAMAGE")


func _on_attack_speed_pressed() -> void:
	pass # Replace with function body.


func _on_pierce_pressed() -> void:
	pass # Replace with function body.
