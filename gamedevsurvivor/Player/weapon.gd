extends Node2D  # Weapon2 sollte ein Node2D sein

@onready var player = get_parent()  # Spieler als Parent-Knoten
@onready var anim_sprite = $AnimatedSprite2D  # Verknüpft den AnimatedSprite2D in der Waffe
@export var arrow_scene: PackedScene  # Verweis auf die Arrow.tscn
@onready var weapon = $Weapon2  # oder ein relativer Pfad # Node, von dem der Pfeil gespawnt wird
@export var weapon_distance = 20  # Abstand der Waffe vom Spielerzentrum
@export var shoot_offset: Vector2 = Vector2(75, 40)
@onready var bow_timer = $Timer
@onready var shot_sound = $ShotSound
@onready var draw_sound = $drawSound
@export var shoot_cd = 0.0

var is_drawing_bow = false  # Zustand: Bogen wird gespannt
var shoot_time = 1.0
var damage = 50
var pierce = 1
var slime_upgrade = 0
var skeleton_upgrade = 0
var readybow = true

func shoot_arrow(direction: Vector2):
	# Pfeil instanziieren
	if(slime_upgrade < 10):
		var arrow_instance = arrow_scene.instantiate()
		arrow_instance.set_damage(damage)
		arrow_instance.set_pierce(pierce)
		get_tree().root.add_child(arrow_instance)  # Füge den Pfeil zur Spielwelt hinzu
	
	# Pfeilposition und Richtung setzen
		var shoot_position = global_position + shoot_offset.rotated(global_rotation)
		arrow_instance.global_position = shoot_position  # Setze die Pfeilposition
		shot_sound.play()
	
		arrow_instance.rotation = direction.angle() - deg_to_rad(70)
		arrow_instance.direction = direction.normalized()
	elif (slime_upgrade >= 10 and slime_upgrade <= 25):
		var arrow_instance = arrow_scene.instantiate()
		
		var arrow_instance2 = arrow_scene.instantiate()
		
		arrow_instance.set_damage(damage)
		arrow_instance.set_pierce(pierce)
		
		arrow_instance2.set_damage(damage)
		arrow_instance2.set_pierce(pierce)
		
		get_tree().root.add_child(arrow_instance)  # Füge den Pfeil zur Spielwelt hinzu
		get_tree().root.add_child(arrow_instance2)
	# Pfeilposition und Richtung setzen
		
		var offset = direction.normalized()
		var shoot_position = global_position + shoot_offset.rotated(global_rotation)
		
		
		arrow_instance.global_position = shoot_position - offset
		arrow_instance2.global_position = shoot_position + offset  # Setze die Pfeilposition
		shot_sound.play()
		var spread_angle = deg_to_rad(10)
		arrow_instance.rotation = direction.angle() - deg_to_rad(70)
		arrow_instance.direction = direction.rotated(-spread_angle).normalized()
		
		arrow_instance2.rotation = arrow_instance2.direction.angle() 
		arrow_instance2.direction = direction.rotated(spread_angle).normalized()
	elif(slime_upgrade <= 25):
	# Drei Pfeile instanziieren
		var arrow_instance = arrow_scene.instantiate()
		var arrow_instance2 = arrow_scene.instantiate()
		var arrow_instance3 = arrow_scene.instantiate()

	# Schaden und Durchschlagskraft für alle Pfeile setzen
		arrow_instance.set_damage(damage)
		arrow_instance.set_pierce(pierce)

		arrow_instance2.set_damage(damage)
		arrow_instance2.set_pierce(pierce)
	
		arrow_instance3.set_damage(damage)
		arrow_instance3.set_pierce(pierce)

	# Pfeile zur Spielwelt hinzufügen
		get_tree().root.add_child(arrow_instance)
		get_tree().root.add_child(arrow_instance2)
		get_tree().root.add_child(arrow_instance3)

	# Position und Versatz berechnen
		var offset = direction.normalized()
		var shoot_position = global_position + shoot_offset.rotated(global_rotation)

	# Positionen setzen
		arrow_instance.global_position = shoot_position - offset  # Links
		arrow_instance2.global_position = shoot_position + offset  # Rechts
		arrow_instance3.global_position = shoot_position          # Mitte

	# Sound abspielen
		shot_sound.play()

	# Rotationswinkel für die seitlichen Pfeile
		var spread_angle = deg_to_rad(10)

	# Pfeilrichtungen und Rotation setzen
		arrow_instance.direction = direction.rotated(-spread_angle).normalized()
		arrow_instance.rotation = arrow_instance.direction.angle()

		arrow_instance2.direction = direction.rotated(spread_angle).normalized()
		arrow_instance2.rotation = arrow_instance2.direction.angle()
		
		arrow_instance3.direction = direction.normalized()
		arrow_instance3.rotation = direction.angle()


func upgrade_damage():
	damage += 10
	print("upgraded damage:  ", damage)
	
func upgrade_attack_speed():
	shoot_time -= 0.1

func upgrade_pierce():
	pierce += 1
		
	

func _process(delta):
	# Spielerposition als Rotationszent
	var player_position = player.global_position
	var mouse_position = get_global_mouse_position()
	
	# Richtung zur Maus berechnen
	var direction = (mouse_position - player_position).normalized()
	
	# Position der Waffe relativ zum Spieler setzen
	global_position = player_position + direction * weapon_distance

	# Rotation zur Maus setzen
	global_rotation = direction.angle()
	
	
	# Schusslogik
	
	if Input.is_action_pressed("shoot"):
		if is_drawing_bow and shoot_time >= shoot_cd:
			if readybow:
				$BowReady.visible = true
				print("ready")
				$BowReady.play("ready")
				
				readybow = false
		if not is_drawing_bow:
			draw_sound.play()
			is_drawing_bow = true
			anim_sprite.speed_scale = 1  # Animationsgeschwindigkeit aktivieren
			anim_sprite.play("default")
			shoot_time = 0.0  # Starte die Spannanimation
		shoot_time += delta
		if anim_sprite.frame == anim_sprite.sprite_frames.get_frame_count("default") - 1:
		
			anim_sprite.speed_scale = 0  # Animation pausieren, wenn der Bogen vollständig gespannt ist

	elif Input.is_action_just_released("shoot"):
		# Nur schießen, wenn der Bogen zuvor gespannt wurde
		$BowReady.visible = false
		readybow = true
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

func increase_skeleton_count():
	skeleton_upgrade += 1

func increase_slime_count():
	slime_upgrade += 1
	print("slimes gekillt: ",slime_upgrade)
