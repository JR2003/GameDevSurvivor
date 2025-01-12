extends Node2D

var timer: float = 0.0 
var damage: float = 0.0 # Zeit-Tracker

var duration: float = 3.0  # Dauer in Sekunden, nach der die Szene entfernt wird
var damageTime: float = 0.5
var inZone = false
var irgendwas = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inZone and irgendwas:
		
		if damage >= damageTime:
			irgendwas.get_damage(10)
			
			damage = 0
	# Überprüfen, ob die Szene bereits 3 Sekunden aktiv ist
	if timer < duration:
		damage += delta
		timer += delta  # Zeit erhöhen
	else:
		queue_free()  # Entferne die Szene nach 3 Sekunden

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("enemies"):
		irgendwas = body
		inZone = true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		inZone = false
