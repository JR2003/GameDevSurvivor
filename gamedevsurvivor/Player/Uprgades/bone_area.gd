extends Node2D

var timer: float = 0.0  # Zeit-Tracker
var duration: float = 3.0  # Dauer in Sekunden, nach der die Szene entfernt wird

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Überprüfen, ob die Szene bereits 3 Sekunden aktiv ist
	if timer < duration:
		timer += delta  # Zeit erhöhen
	else:
		queue_free()  # Entferne die Szene nach 3 Sekunden

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.get_damage(10)
		print("enemy entered bones")
