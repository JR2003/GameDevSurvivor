extends CharacterBody2D

var chase = false
var player = null
var speed = 60
var health = 100
var alive = true
var exp_reward = 100  # EXP, die dieser Gegner gibt

func _ready() -> void:
	player = get_parent().get_node("Player")
	if player:
		print("player gefunden")

func _on_detection_range_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		chase = true

func _on_detection_range_body_exited(body: CharacterBody2D) -> void:
	
	chase = false

func _physics_process(delta: float) -> void:
	if !alive:
		return
	if chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("move")
		if (player.position.x - position.x) < 0:
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
	
	
	if !area.is_in_group("slime_hitbox"):
		
		health -= 10
		print(health)
		if health <= 0:
			die()
