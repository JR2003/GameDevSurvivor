extends Node2D

@export var speed: float = 500.0  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt
func _ready():
	add_to_group("player_projectiles")
func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta

	# Rotation des Pfeils anpassen (soll mit Flugrichtung übereinstimmen)
	rotation = direction.angle()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		print("arrow pierced enemy")
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		print("arrow pierced enemyss")
		queue_free()
