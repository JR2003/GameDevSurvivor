extends Control

func _on_play_button_pressed():
	
	get_tree().change_scene_to_file("res://world_2d.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
