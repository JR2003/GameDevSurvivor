extends Node2D
@export var damage = 10
@export var speed: float = 500.0
@export var bonearea: PackedScene  # Geschwindigkeit des Pfeils
var direction = Vector2.ZERO  # Richtung, in die der Pfeil fliegt
var hit_count = 0
var pierce = 1
var elapsed_time: float = 0.0 
@export var lifetime: float = 1
var boneUpgrade = false

	
	
func _physics_process(delta):
	# Bewegung des Pfeils
	position += direction * speed * delta
	rotation = direction.angle()
	elapsed_time += delta
	if elapsed_time >= lifetime:
		queue_free()
func set_bone(value: bool):
	boneUpgrade = value

func set_damage(amount: int):
	damage = amount
	
func set_pierce(amount: int):
	pierce = amount


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		
		if boneUpgrade:
			print("ich habe das boneupgrade")
			var boneinstance = bonearea.instantiate()
			boneinstance.global_position = body.global_position
			get_tree().root.add_child(boneinstance)
		body.get_damage(damage)
		hit_count += 1
		if hit_count == pierce:
			queue_free()
