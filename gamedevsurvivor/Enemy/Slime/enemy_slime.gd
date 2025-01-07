extends CharacterBody2D

var chase = true
var player = null
var speed = 50
var health = 100
var alive = true
var exp_reward = 100  # EXP, die dieser Gegner gibt
var hurt = false

func _ready() -> void:
	player = get_parent().get_node("Player")
	
	

func _physics_process(delta: float) -> void:
	if !alive or hurt:
		return
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

func _on_damage_hitbox_area_entered(area: Area2D) -> void:
	
	
	if !area.is_in_group("slime_hitbox") and !area.is_in_group("player"):
		health -= 10
		hurt = true
		print("hit")
		$AnimatedSprite2D.play("hurt")
		await $AnimatedSprite2D.animation_looped
		
		hurt = false
		if health <= 0:
			die()
