extends Node2D
@export var damage = 10
@export var speed: float = 500.0  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt
var hit_count = 0
var pierce = 1
func _ready():
	add_to_group("player_projectiles")
func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta

	# Rotation des Pfeils anpassen (soll mit Flugrichtung übereinstimmen)
	rotation = direction.angle()

func set_damage(amount: int):
	damage = amount
	
func set_pierce(amount: int):
	pierce = amount


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		
		body.get_damage(damage)
		hit_count += 1
		if hit_count == pierce:
			queue_free()
