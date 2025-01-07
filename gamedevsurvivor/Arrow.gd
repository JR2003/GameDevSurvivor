extends Node2D

@export var speed: float = 500.0  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt

func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta

	# Rotation des Pfeils anpassen (soll mit Flugrichtung übereinstimmen)
	rotation = direction.angle()


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
