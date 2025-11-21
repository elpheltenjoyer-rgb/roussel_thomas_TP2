extends Control

func _ready():
	await get_tree().create_timer(2.0).timeout  # fake loading time
	get_tree().change_scene_to_file("res://porject/main.tscn")
