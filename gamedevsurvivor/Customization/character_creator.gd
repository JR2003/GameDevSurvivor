extends Node2D


func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
