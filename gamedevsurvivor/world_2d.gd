extends Node2D

# Gegner-Szenen als PackedScene-Variablen
@export var enemy_slime_scene: PackedScene
@export var enemy_skeleton_scene: PackedScene

# Bereich, in dem die Gegner gespawnt werden
@export var spawn_area: Rect2

func _ready():
	# Verbinde das Signal des Timers
	$Timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	# Zufällig zwischen den beiden Gegnertypen wählen
	var enemy_scene = enemy_slime_scene if randf() < 0.5 else enemy_skeleton_scene

	# Einen neuen Gegner instanzieren
	var enemy_instance = enemy_scene.instantiate()

	# Zufällige Position innerhalb des Spawn-Bereichs berechnen
	var spawn_position = Vector2(
		randf_range(-1000, 1000),
		randf_range(0,500)
	)
	print(spawn_position)
	
	enemy_instance.position = spawn_position

	# Gegner in die Szene hinzufügen
	add_child(enemy_instance)
