extends CharacterBody2D
var attack_in_progress = false
var player = null
var speed = 100
var chase = true
var health = 100
var alive = true
var exp_reward = 75
var hurt = false
var weapon = null
var boneUpgrade = false
var spawned = false
var isDamaging = false
var bar = null
var damage: float = 0.0
var damageTime: float = 2
var playerArea = null
var isInsideAttack = false
@onready var attackHitBox = $attack_hitbox
@onready var attack_timer = $Timer
func _ready() -> void:
	
	player = get_parent().get_node("Player")
	player.updateBossBar(health)
	
	weapon = get_parent().get_node("Player/Weapon2")
	bar = get_parent().get_node("Player/Control/BossHP")
	bar.visible = true
	print("boss hp: ", health)
	
	

# deleted double scenes

func get_damage(amount: int):
	if alive:
		
		hurt = true
		health -= amount
		print("boss hp: ", health)
		$AnimatedSprite2D.play("hurt")
		await $AnimatedSprite2D.animation_looped
		hurt = false
		if health <= 0:
			die()

func _physics_process(delta: float) -> void:
	player.updateBossBar(health)
	var overlapping_bodies = $attack_hitbox.get_overlapping_areas()
	if playerArea in overlapping_bodies:
		print(damage)
		if damage >= 0.3:
			
			attack()
			
			
			
		damage += delta
	if !spawned:
		$AnimatedSprite2D.play("spawn")
		await $AnimatedSprite2D.animation_looped
		spawned = true
	if !alive or hurt or isDamaging:
		return
	if chase:
		var direction = (player.position - position).normalized()
		
		velocity = direction * speed
		move_and_slide()
		$AnimatedSprite2D.play("move")
		
		if player.position.x < position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

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
		print("method nicht geunden")
	if player and player.has_method("gain_exp"):
		player.gain_exp(exp_reward)
		
func increase_hp(amount: float):
	health *= amount
	
func attack():
	
	print("attack")
	
	
	if isInsideAttack:
		$AnimatedSprite2D.play("attack")
		
		await $AnimatedSprite2D.animation_looped
		player.get_damage_by_boss(2)
		attack_timer.start()
		damage = 0
func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		isInsideAttack = true
		
		isDamaging = true
		playerArea = area
		
		
		
		


func _on_attack_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		isInsideAttack = false
		isDamaging = false
		playerArea = null
