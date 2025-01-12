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

var inBossHit = false
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
@onready var anim = $AnimatedSprite2D  # Sprite-Node

@onready var damagesound = $DamageSound
@onready var bossHpBar = $Control/BossHP
var menudie = preload("res://Menu/menu.tscn")

var pausemenuscene = preload("res://Menu/pauseMenu/pause_menu.tscn")
@export var slime_killer : PackedScene
@export var slime_killermax : PackedScene
@export var menu: PackedScene

var excess_exp

var damage_cd_boss = 1.0
var alive = true
@onready var dtimer = $DeathTimer



func _ready():
	weapon = get_node("Weapon2")
	arrow = get_node("Arrow")
	
	update_exp_label()
	initialize()
	update_exp_label()
	

func initialize():
	body.texture = Global.bodies[Global.selectBody]
	body.modulate = Global.selectBodyColor
	
	outfit.texture = Global.outfits[Global.selectOutfit]
	outfit.modulate = Global.selectOutfitColor
	
	hair.texture = Global.hairs[Global.selectHair]
	hair.modulate = Global.selectHairColor
	
	accessory.texture = Global.accessories[Global.selectAccessory]
	accessory.modulate = Global.selectAccessoryColor
		

func _process(delta: float) -> void:
	pause_game()
	if weapon.slimeupgrade1:
		show_slime_killer()
	if weapon.max_slimeupgrade:
		show_slime_killermax()

func _physics_process(delta):
	
	xp_bar.value = float(exp) / float(exp_to_next_level) * 100
	handle_input()
	move_and_slide()
	update_animation()
	
	if getting_damage:
		damage_cd += delta
	damage_cd_boss += delta

func updateBossBar(amount: float):
	bossHpBar.value = amount / 2000 * 100

func handle_input():
	var axis = Vector2(
		int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft")),
		int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"))
	)
	
	velocity = axis * 150  


	if not axis.is_equal_approx(Vector2.ZERO):
		last_direction = axis

func update_animation():
	if health <= 0 :
		get_tree().change_scene_to_file("res://Menu/menu.tscn")
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

func update_exp_label() -> void:
	exp_label.text = "Level: " + str(level)   # Setze den Text im Label

func get_damage_by_projectile(amount: int):
	damagesound.play()
	
	health -= amount
	
	 # Setze den Text im Label
		
	if health == 2:
		$Control/TextureRect2.visible = false
	if health == 1:
		$Control/TextureRect2.visible = false
		$Control/TextureRect3.visible = false
	if health == 0:
		$Control/TextureRect3.visible = false
		$Control/TextureRect2.visible = false
		$Control/TextureRect.visible = false
	if health <= 0:
		alive = false

func get_damage(amount: int):
	damagesound.play()
	if damage_cd >= 1:
		health -= amount
		damage_cd = 0
	 # Setze den Text im Label
		
	if health == 2:
		$Control/TextureRect2.visible = false
	if health == 1:
		$Control/TextureRect2.visible = false
		$Control/TextureRect3.visible = false
	if health == 0:
		$Control/TextureRect3.visible = false
		$Control/TextureRect2.visible = false
		$Control/TextureRect.visible = false
	if health <= 0:
		print("dead to hitbox")
		alive = false
		
func get_damage_by_boss(amount: int):
	if inBossHit:
		damagesound.play()
		if damage_cd_boss >= 1:
			health -= amount
			damage_cd_boss = 0
	 	# Setze den Text im Label
		
		if health == 2:
			$Control/TextureRect2.visible = false
		if health == 1:
			$Control/TextureRect2.visible = false
			$Control/TextureRect3.visible = false
		if health == 0:
			$Control/TextureRect3.visible = false
			$Control/TextureRect2.visible = false
			$Control/TextureRect.visible = false
		if health <= 0:
		
			alive = false
	
func die():
	print("dead")
	update_animation()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		print("normal hit")
		get_damage(1)
		getting_damage = true
	if area.is_in_group("boss_hit"):
		inBossHit = true
		


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


func _on_hitbox_area_exited(area: Area2D) -> void:
	inBossHit = false
