extends Node2D

# Gegner-Szenen als PackedScene-Variablen
@export var enemy_slime_scene: PackedScene
@export var enemy_skeleton_scene: PackedScene
@export var enemy_wizard_scene: PackedScene

@onready var bridges = $TileMap/Bridges
# Bereich, in dem die Gegner gespawnt werden
@export var spawn_area: Rect2
@onready var spawnblock = $BlockArea

var spawn_timer = 0.0  # Timer zur Verfolgung der Zeit seit Beginn des Spiels
var print_timer = 0.0  # Timer zur Verfolgung der Zeit für den Print

func _process(delta: float) -> void:
	spawn_timer += delta  # Zeit seit Spielbeginn erhöhen
	print_timer += delta  # Zeit seit dem letzten Print erhöhen

	if print_timer >= 10.0:  # Alle 10 Sekunden
		print("Verstrichene Zeit: ", spawn_timer)
		print_timer = 0.0  # Timer zurücksetzen

func spawn_enemy():
	# Zufällige Auswahl zwischen den drei Gegnertypen, basierend auf der vergangenen Zeit
	var rand_value = randf()
	var enemy_scene: PackedScene
	
	if spawn_timer < 60.0:  # Innerhalb der ersten Minute
		if rand_value < 0.9:  # 90% Wahrscheinlichkeit für Slimes
			enemy_scene = enemy_slime_scene
		else:
			enemy_scene = enemy_skeleton_scene  # 10% Wahrscheinlichkeit für Skelette
	elif spawn_timer < 120.0:  # Nach einer Minute bis zwei Minuten
		if rand_value < 0.7:  # 70% Wahrscheinlichkeit für Slimes
			enemy_scene = enemy_slime_scene
		elif rand_value < 0.9:  # 20% Wahrscheinlichkeit für Skelette
			enemy_scene = enemy_skeleton_scene
		else:
			enemy_scene = enemy_wizard_scene  # 10% Wahrscheinlichkeit für Zauberer
	else:  # Nach zwei Minuten
		if rand_value < 0.4:  # 40% Wahrscheinlichkeit für Slimes
			enemy_scene = enemy_slime_scene
		elif rand_value < 0.8:  # 40% Wahrscheinlichkeit für Skelette
			enemy_scene = enemy_skeleton_scene
		else:
			enemy_scene = enemy_wizard_scene  # 20% Wahrscheinlichkeit für Zauberer

	# Einen neuen Gegner instanzieren
	var enemy_instance = enemy_scene.instantiate()

	# Zufällige Position innerhalb des Spawn-Bereichs berechnen
	var spawn_position = Vector2(
		randf_range(-1500, 1000),
		randf_range(-1000, 1500)
	)
	
	enemy_instance.position = spawn_position

	# Gegner in die Szene hinzufügen
	add_child(enemy_instance)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$Timer.timeout.connect(spawn_enemy)
		print("player entered spawn area")
		spawnblock.collision_layer = 1
