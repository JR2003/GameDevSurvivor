extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		resume_game()

func _on_resume_pressed() -> void:
	print("resume")
	resume_game()

func _on_quit_pressed() -> void:
	print("quit")
	get_tree().quit()

func resume_game():
	get_tree().paused = false
	queue_free()
