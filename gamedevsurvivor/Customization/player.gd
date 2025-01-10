extends CharacterBody2D

@onready var body = $Skeleton/Body
@onready var hair = $Skeleton/Hair
@onready var outfit = $Skeleton/Outfit
@onready var accessory = $Skeleton/Accessory
@onready var animationPlayer = $AnimationPlayer
@onready var xp_bar = $Control/ProgressBar# XP-Bar Referenz (Pfad anpassen)
@export var is_shooting = false

@onready var exp_label = $Control/ProgressBar/Exp
@onready var hp_label = $Control/ProgressBar/Health

@onready var bow_sound = $Weapon2/ShotSound

var upgrademenuscene = preload("res://Menu/upgradeMenu/upgrade_menu.tscn")

var last_direction = Vector2(0, 1)  # Standardmäßig nach unten
var exp = 0
var level = 1
var exp_to_next_level = 100
var weapon = null
var arrow = null
var health = 3
var damage_cd = 1.0
var getting_damage = true

func _ready():
	initialize()
	update_exp_label()
	update_hp_label()

func initialize():
	body.texture = Global.bodies[Global.selectBody]
	body.modulate = Global.selectBodyColor
	
	outfit.texture = Global.outfits[Global.selectOutfit]
	outfit.modulate = Global.selectOutfitColor
	
	hair.texture = Global.hairs[Global.selectHair]
	hair.modulate = Global.selectHairColor
	
	accessory.texture = Global.accessories[Global.selectAccessory]
	accessory.modulate = Global.selectAccessoryColor
		

func _physics_process(delta):
	handle_input()
	move_and_slide()
	update_animation()
	if getting_damage:
		damage_cd += delta

func handle_input():
	var axis = Vector2(
		int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft")),
		int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
	)
	
	velocity = axis * 150  


	if not axis.is_equal_approx(Vector2.ZERO):
		last_direction = axis

func update_animation():
	if velocity.is_equal_approx(Vector2.ZERO):
		if last_direction.x < 0:
			animationPlayer.play("idleLeft")
		elif last_direction.x > 0:
			animationPlayer.play("idleRight")
		elif last_direction.y < 0:
			animationPlayer.play("idleUp")
		elif last_direction.y > 0:
			animationPlayer.play("idleDown")
	else:
		play_walk_animation(last_direction)

func play_walk_animation(direction: Vector2):
	if direction.x != 0:
		if direction.x < 0:
			animationPlayer.play("walkLeft")
		else:
			animationPlayer.play("walkRight")
	elif direction.y != 0:
		if direction.y < 0:
			animationPlayer.play("walkUp")
		else:
			animationPlayer.play("walkDown")
			
func gain_exp(amount: int) -> void:
	exp += amount
	print("EXP erhalten: ", amount, "| Gesamte EXP: ", exp)

	# XP-Bar aktualisieren
	xp_bar.value = exp
	
	if exp >= exp_to_next_level:
		#show_upgrade_menu()
		update_exp_label()
		level_up()
		print(level)
		show_upgrade_menu()
		
	else:
		update_exp_label()

func level_up() -> void:
	level += 1
	exp = 0
	exp_to_next_level *= 1.5
	print("Level-Up! Neues Level: ", level)
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
		

	
func show_upgrade_menu():
	var upgrade_menu = upgrademenuscene.instantiate()
	add_child(upgrade_menu)
	
	get_tree().current_scene.add_child(upgrade_menu)
	get_tree().paused = true
