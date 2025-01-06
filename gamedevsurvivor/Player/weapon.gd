extends Node2D  # Weapon2 sollte ein Node2D sein

@onready var player = get_parent()  # Spieler als Parent-Knoten
@onready var anim_sprite = $AnimatedSprite2D  # Verknüpft den AnimatedSprite2D in der Waffe
@export var arrow_scene: PackedScene  # Verweis auf die Arrow.tscn
@onready var weapon = $Weapon2  # oder ein relativer Pfad # Node, von dem der Pfeil gespawnt wird
@export var weapon_distance = 20  # Abstand der Waffe vom Spielerzentrum
@export var shoot_offset: Vector2 = Vector2(70, 20) 

func _ready():
	print($Weapon2) 

func shoot_arrow(direction: Vector2):
	# Pfeil instanziieren
	var arrow_instance = arrow_scene.instantiate()
	get_parent().add_child(arrow_instance)  # Füge den Pfeil zur Spielwelt hinzu

	# Pfeilposition und Richtung setzen
	var shoot_position = global_position + shoot_offset.rotated(global_rotation)
	arrow_instance.global_position = shoot_position  # Setze die Pfeilposition
	
	arrow_instance.rotation = direction.angle() - deg_to_rad(70)

	arrow_instance.direction = direction.normalized()

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
			anim_sprite.play("default")
			shoot_arrow(direction) # Name der Schussanimation
	else:
		anim_sprite.stop()  # Animation stoppen, wenn die Taste losgelassen wird
