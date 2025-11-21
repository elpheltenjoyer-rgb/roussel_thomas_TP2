extends Node2D

@onready var button: Button = $Button


func _ready() -> void:
	button.connect("pressed", Callable(self, "_on_start_button_pressed"))

func _on_start_button_pressed() -> void:
	print("Button pressed!")
	get_tree().change_scene_to_file("res://porject/loading_1.tscn")
