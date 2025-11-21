extends Node2D

@onready var label_1 = $sol/label_1
@onready var label_2 = $sol/label_2
@onready var anim = $umacoin/AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	anim.play("coin_animation")
	label_1.modulate.a = 0.0 
	label_2.modulate.a = 0.0 


func _on_area_2d_body_entered(body: Node2D) -> void:
	if  body.name == "sol":
		audio_stream_player.play()
		var tween = create_tween()
		tween.tween_property(label_1, "modulate:a", 1.0, 0.5) 
		tween.tween_property(label_1, "modulate:a", 0.0, 1.0)
		
