extends Node2D  # Weapon2 sollte ein Node2D sein

@onready var player = get_parent()  # Spieler als Parent-Knoten
@onready var anim_sprite = $AnimatedSprite2D  # Verknüpft den AnimatedSprite2D in der Waffe
@export var arrow_scene: PackedScene  # Verweis auf die Arrow.tscn
@onready var weapon = $Weapon2  # oder ein relativer Pfad # Node, von dem der Pfeil gespawnt wird
@export var weapon_distance = 20  # Abstand der Waffe vom Spielerzentrum
@export var shoot_offset: Vector2 = Vector2(70, 20)
@onready var bow_timer = $Timer
var is_drawing_bow = false  # Zustand: Bogen wird gespannt
var shoot_time = 0.0
@export var shoot_cd = 0.0
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
	
	print("Ladezeit ", shoot_time)
	# Schusslogik
	
	if Input.is_action_pressed("shoot"):
		
		if not is_drawing_bow:
			
			is_drawing_bow = true
			anim_sprite.speed_scale = 1  # Animationsgeschwindigkeit aktivieren
			anim_sprite.play("default")
			shoot_time = 0.0  # Starte die Spannanimation
		shoot_time += delta
		if anim_sprite.frame == anim_sprite.sprite_frames.get_frame_count("default") - 1:
			anim_sprite.speed_scale = 0  # Animation pausieren, wenn der Bogen vollständig gespannt ist

	elif Input.is_action_just_released("shoot"):
		# Nur schießen, wenn der Bogen zuvor gespannt wurde
		if is_drawing_bow and shoot_time >= shoot_cd:
			is_drawing_bow = false
			anim_sprite.speed_scale = 1  # Animationsgeschwindigkeit zurücksetzen
			shoot_arrow(direction)  # Pfeil abschießen
			anim_sprite.stop()  # Animation stoppen
		else:
			# Wenn die Schusstaste losgelassen wurde, ohne den Bogen zu spannen
			anim_sprite.stop()  # Animation stoppen und auf Anfang zurücksetzen
			anim_sprite.frame = 0
			is_drawing_bow = false
