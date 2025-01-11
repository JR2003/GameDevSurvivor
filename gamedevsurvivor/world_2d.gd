extends Node2D

# Gegner-Szenen als PackedScene-Variablen
@export var enemy_slime_scene: PackedScene
@export var enemy_skeleton_scene: PackedScene
@export var enemy_wizard_scene: PackedScene

@onready var bridges = $TileMap/Bridges
# Bereich, in dem die Gegner gespawnt werden
@export var spawn_area: Rect2
@onready var block = $BlockArea/Block

func _ready():
	# Verbinde das Signal des Timers
	$Timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	# Zufällige Auswahl zwischen den drei Gegnertypen
	var rand_value = randf()
	var enemy_scene: PackedScene
	
	if rand_value < 0.33:
		enemy_scene = enemy_slime_scene
	elif rand_value < 0.66:
		enemy_scene = enemy_skeleton_scene
	else:
		enemy_scene = enemy_wizard_scene

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
		print(block.disabled)
		block.disabled = false
		bridges.collision_enabled = false
		print(block.disabled)
