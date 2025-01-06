extends CharacterBody2D

var chase = false
var player = null
var speed = 60

# ben ist hier

func _on_detection_range_body_entered(body: CharacterBody2D) -> void:
	player = body
	chase = true

func _on_detection_range_body_exited(body: CharacterBody2D) -> void:
	player = null
	chase = false
	
func _physics_process(delta: float) -> void:
	if chase:
		position += (player.position - position) / speed
		
		$AnimatedSprite2D.play("move")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")
		
