extends Control

var player = null
var weapon = null

func _ready() -> void:
	player = get_parent().get_node("Player2")
	weapon = get_parent().get_node("Weapon2")
	
func close_upgrade_menu():
	get_tree().paused = false
	queue_free()


func _on_damage_pressed() -> void:
	print("ich will damage")
	weapon.upgrade_damage()
	close_upgrade_menu()


func _on_attackspeed_pressed() -> void:
	print("ich will attackspeed")
	weapon.upgrade_attack_speed()
	close_upgrade_menu()


func _on_pierce_pressed() -> void:
	print("ich will pierce")
	weapon.upgrade_pierce()
	close_upgrade_menu()
