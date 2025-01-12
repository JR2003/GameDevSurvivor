extends CharacterBody2D


var boneUpgrade = false
var chase = true
var player = null
var weapon = null
var speed = 40
var health = 100
var alive = true
var exp_reward = 100  # EXP, die dieser Gegner gibt
var hurt = false
var shoot_timer = 0.0  # Timer für den Schuss

@export var shoot_offset: Vector2 = Vector2(75, 40)
@export var fireball: PackedScene
@export var shoot_interval: float = 5.0  # Zeit in Sekunden zwischen Schüssen

func _ready() -> void:
	player = get_parent().get_node("Player")
	weapon = get_parent().get_node("Player/Weapon2")

func _physics_process(delta: float) -> void:
	if !alive or hurt:
		return
	
	shoot_timer -= delta  # Reduziere den Timer basierend auf der Delta-Zeit
	
	if shoot_timer <= 0.0:
		shoot_fireball()  # Schieße einen Feuerball
		shoot_timer = shoot_interval  # Setze den Timer zurück
	
	if chase:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
		$AnimatedSprite2D.play("move")
		
		if player.position.x < position.x:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")

func get_damage(amount: int):
	if alive:
		hurt = true
		health -= amount
	
		$AnimatedSprite2D.play("hurt")
		await $AnimatedSprite2D.animation_looped
		hurt = false
		if health <= 0:
			die()


func deleteThis(value: bool):
	if value:
		queue_free()

func die():
	give_exp_to_player()
	alive = false
	$AnimatedSprite2D.play("death")
	
	await $AnimatedSprite2D.animation_looped
	queue_free()

func give_exp_to_player() -> void:
	if player == null:
		print("player nicht da")
	elif !player.has_method("gain_exp"):
		print("method nicht gefunden")
	if player and player.has_method("gain_exp"):
		player.gain_exp(exp_reward)

func shoot_fireball():
	var fireball_instance = fireball.instantiate()
	var direction = (player.position - position).normalized()
	get_tree().root.add_child(fireball_instance)  # Füge den Feuerball zur Spielwelt hinzu
	
	# Feuerballposition und Richtung setzen
	var shoot_position = global_position + shoot_offset.rotated(global_rotation)
	fireball_instance.global_position = shoot_position  # Setze die Feuerballposition
	
	fireball_instance.rotation = direction.angle() - deg_to_rad(70)
	fireball_instance.direction = direction.normalized()
	
func increase_hp(amount: float):
	health *= amount
	
