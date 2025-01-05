extends Node2D  # Weapon2 sollte ein Node2D sein

@onready var player = get_parent()  # Spieler als Parent-Knoten
@onready var anim_sprite = $AnimatedSprite2D  # Verknüpft den AnimatedSprite2D in der Waffe

@export var weapon_distance = 20  # Abstand der Waffe vom Spielerzentrum

func _process(delta):
	# Spielerposition als Rotationszentrum
	var player_position = player.global_position
	var mouse_position = get_global_mouse_position()

	# Richtung zur Maus berechnen
	var direction = (mouse_position - player_position).normalized()

	# Position der Waffe relativ zum Spieler setzen
	global_position = player_position + direction * weapon_distance

	# Rotation zur Maus setzen
	global_rotation = direction.angle()

	# Animation abspielen, wenn die Schusstaste gedrückt wird
	if Input.is_action_pressed("shoot"):
		if anim_sprite.animation != "default" or not anim_sprite.is_playing():
			anim_sprite.play("default")  # Name der Schussanimation
	else:
		anim_sprite.stop()  # Animation stoppen, wenn die Taste losgelassen wird
