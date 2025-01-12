extends Node2D
@export var damage = 10
@export var speed: float = 500.0  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt
var hit_count = 0
var pierce = 1
func _ready():
	add_to_group("enemy_projectiles")
func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta

	# Rotation des Pfeils anpassen (soll mit Flugrichtung übereinstimmen)
	rotation = direction.angle()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		body.get_damage_by_projectile()
		queue_free()
