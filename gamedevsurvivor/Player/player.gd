extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Sprite-Node
@onready var xp_bar = $Control/ProgressBar# XP-Bar Referenz (Pfad anpassen)
@onready var exp_label = $Control/ProgressBar/Exp
@onready var hp_label = $Control/ProgressBar/Health
@onready var bow_sound = $Weapon2/ShotSound
@onready var damagesound = $DamageSound

var upgrademenuscene = preload("res://Menu/upgradeMenu/upgrade_menu.tscn")
var pausemenuscene = preload("res://Menu/pauseMenu/pause_menu.tscn")
@export var slime_killer : PackedScene
@export var slime_killermax : PackedScene
@export var skeleton_killer : PackedScene

@export var is_shooting = false
var excess_exp
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
	
	
func _process(delta: float) -> void:
	pause_game()
	if weapon.slimeupgrade1:
		show_slime_killer()
	if weapon.max_slimeupgrade:
		show_slime_killermax()
	if weapon.up_skeleton:
		show_skeleton_killer()

func _physics_process(delta):
	xp_bar.value = float(exp) / float(exp_to_next_level) * 100
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
	
	if exp >= exp_to_next_level:
		#show_upgrade_menu()
		excess_exp = exp - exp_to_next_level
		level_up()
		print(level)
		show_upgrade_menu()
		update_exp_label()
		
	else:
		update_exp_label()

func level_up() -> void:
	
	level += 1
	exp = excess_exp
	exp_to_next_level *= 1.5
	print("Level-Up! Neues Level: ", level)
	# XP-Bar zurücksetzen oder aktualisieren
	  # Setze die XP-Bar auf den neuen EXP-Wert

func update_exp_label() -> void:
	exp_label.text = "Level: " + str(level)  # Setze den Text im Label



func get_damage_by_projectile():
	damagesound.play()
	
	health -= 1
	
	 # Setze den Text im Label
		
	if health == 2:
		$Control/TextureRect2.visible = false
	if health == 1:
		$Control/TextureRect3.visible = false
	if health == 0:
		$Control/TextureRect.visible = false
	if health <= 0:
		die()
func get_damage(amount: int):
	damagesound.play()
	if damage_cd >= 1:
		health -= amount
		damage_cd = 0
	 # Setze den Text im Label
		
	if health == 2:
		$Control/TextureRect2.visible = false
	if health == 1:
		$Control/TextureRect3.visible = false
	if health == 0:
		$Control/TextureRect.visible = false
	if health <= 0:
		die()
	
func die():
	
	
	anim.play("die")
	await anim.animation_looped
	
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		
		get_damage(1)
		getting_damage = true
		



func show_upgrade_menu():
	var upgrade_menu = upgrademenuscene.instantiate()
	add_child(upgrade_menu)
	
	get_tree().current_scene.add_child(upgrade_menu)
	get_tree().paused = true
	
func pause_game():
	if Input.is_action_just_pressed("esc"):
		print("ich will pause menü öffnen")
		var pause_menu = pausemenuscene.instantiate()
		add_child(pause_menu)
		get_tree().current_scene.add_child(pause_menu)
		get_tree().paused = true

func show_slime_killer():
	var sk_instance = slime_killer.instantiate()
	add_child(sk_instance)
	sk_instance.position = Vector2(0, -400)
	
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	
	if sk_instance:
		sk_instance.queue_free()

func show_slime_killermax():
	var skm_instance = slime_killermax.instantiate()
	add_child(skm_instance)
	skm_instance.position = Vector2(0, -400)
	
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	
	
	if skm_instance:
		skm_instance.queue_free()

func show_skeleton_killer():
	var ssk_instance = skeleton_killer.instantiate()
	add_child(ssk_instance)
	ssk_instance.position = Vector2(0, -400)
	
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	
	if ssk_instance:
		ssk_instance.queue_free()
