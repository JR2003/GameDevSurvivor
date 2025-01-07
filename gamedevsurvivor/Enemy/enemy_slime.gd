extends CharacterBody2D

var chase = true
var player = null
var speed = 50  # Geschwindigkeit in Pixeln pro Sekunde
var health = 100
var alive = true
var exp_reward = 50  # EXP, die dieser Gegner gibt
var hurt = false

func _ready() -> void:
	player = get_parent().get_node("Player")




func _physics_process(delta: float) -> void:
	if !alive or hurt:
		return
	
	# Bewegung mit `move_and_slide`
	if chase:
		var direction = (player.position - position).normalized() 
		 # Richtung zum Spieler normalisiert
		velocity = direction * speed 
		print(velocity) # Geschwindigkeit basierend auf Richtung und Geschwindigkeit
		move_and_slide()
		
		$AnimatedSprite2D.play("move")
		
		# Flip der Animation basierend auf der Richtung
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity = Vector2.ZERO  # Keine Bewegung
		move_and_slide()  # Bewegung stoppen
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
		print("method nicht gefunden")
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
