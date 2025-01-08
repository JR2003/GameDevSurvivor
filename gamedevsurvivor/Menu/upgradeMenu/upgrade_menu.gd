extends Control

var player = null

func _ready() -> void:
	player = get_parent().get_node("Player")

	
func close_upgrade_menu():
	get_tree().paused = false
	queue_free()

func _on_up_damage_pressed() -> void:
	print("ich will damage")
	close_upgrade_menu()

func _on_up_attackspeed_pressed() -> void:
	print("ich will attackspeed")
	close_upgrade_menu()

func _on_up_pierce_pressed() -> void:
	print("ich will pierce")
	close_upgrade_menu()
