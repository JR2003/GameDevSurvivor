extends Control

func _on_play_button_pressed():
	print("ich will spielen")
	
	get_tree().change_scene_to_file("res://world_2d.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_character_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Customization/CharacterCreator.tscn")
