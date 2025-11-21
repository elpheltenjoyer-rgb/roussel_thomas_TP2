extends Node2D


@export var required_coins: int = 16      
@export var show_time: float = 3.0         
@export var next_level_path: String = "res://scenes/NextLevel.tscn"  


@onready var gate = $Gate                   
@onready var coin_bag = $coin_bag         
@onready var level_label = $LevelLabel     
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2



var coins_collected: int = 0

func _ready() -> void:
	
	for coin in coin_bag.get_children():
		if coin is Area2D and coin.has_signal("collected"):
			coin.connect("collected", Callable(self, "_on_coin_collected"))




func _on_coin_collected() -> void:
	audio_stream_player.play()
	coins_collected += 1
	
	print("Coins collected: %d / %d" % [coins_collected, required_coins])
	
	if coins_collected >= required_coins:
		open_gate_and_next_level()

func open_gate_and_next_level() -> void:
	audio_stream_player_2.play()
	if gate:
		var collider = gate.get_node_or_null("CollisionShape2D")
		if collider:
			collider.disabled = true
		gate.visible = false
		print("Gate opened!")

	await get_tree().create_timer(5.0).timeout

	if next_level_path != "":
		print("Loading next level:", next_level_path)
		get_tree().change_scene_to_file("res://porject/loading_3.tscn")
