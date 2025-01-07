extends CharacterBody2D

var player = null
var speed = 50
var chase = false
var health = 150
var alive = true
# var exp_reward = xx
var hurt = false

func _ready() -> void:
	player = get_parent().get_node("Player")

func _on_detection_range_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		chase = true


func _on_detection_range_body_exited(body: Node2D) -> void:
	chase = false


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

func _physics_process(delta: float) -> void:
	if !alive or hurt:
		return
	if chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("move")
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func die():
	# give_exp_to_player()
	alive = false
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_looped
	
	queue_free()
