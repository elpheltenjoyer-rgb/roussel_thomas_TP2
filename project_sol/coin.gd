extends Area2D

signal collected

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "sol":
		emit_signal("collected")  # tell main scene a coin was collected
		queue_free()  # remove this coin
