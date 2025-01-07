extends Node2D
var damage = 10
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
		print("arrow hit enemy")
		body.give_exp_to_player()
		queue_free()
