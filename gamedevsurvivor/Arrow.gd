extends Node2D

@export var speed: float = 500.0  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt

func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta

	# Rotation des Pfeils anpassen (soll mit Flugrichtung übereinstimmen)
	rotation = direction.angle()

func _on_Area2D_body_entered(body):
	# Logik bei Treffer (z. B. Schaden zufügen)
	if body.is_in_group("enemies"):
		body.take_damage(10)  # Beispiel: 10 Schaden zufügen
	queue_free()  # Pfeil entfernen
