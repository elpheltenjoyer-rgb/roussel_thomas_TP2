

extends CharacterBody2D
const JUMP_FORCE = 1000
const SPEED = 600
const GRAVITY=1200
const SPRINT_MULTIPLIER = 2.0
const DASH_SPEED = 1500
const DASH_DURATION = 0.2 

var is_dashing = false
var dash_direction = Vector2.ZERO
var dash_timer = 0.0
var dash_use =1

var side= 1 

func _physics_process(delta):
	
	var direction = Vector2.ZERO
	var current_speed = SPEED
	if not is_playing_special:
		if is_on_floor():
			dash_use=1
		
		if is_dashing:
			dash_timer -= delta
			if dash_timer <= 0:
				end_dash()
			else:
				velocity = dash_direction * DASH_SPEED
				move_and_slide()
				return 

		velocity.y += GRAVITY * delta 	
		$"hitbox#1".set_deferred("disabled",false)
		$"hitbox#2".set_deferred("disabled",true)
		if Input.is_action_pressed("move_right") :
			direction.x += 1
			$AnimatedSprite2D.flip_h=false
			side=1
			
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
			$AnimatedSprite2D.flip_h=true
			side=0
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -JUMP_FORCE
			$AnimatedSprite2D.play("jump")
			
			
		if  Input.is_action_pressed("sprint") and Input.is_action_pressed("move_left") and is_on_floor(): 
			current_speed *= SPRINT_MULTIPLIER
			$"hitbox#1".set_deferred("disabled",true)
			$"hitbox#2".set_deferred("disabled",false)
		if  Input.is_action_pressed("sprint") and Input.is_action_pressed("move_right") and is_on_floor() : 
			current_speed *= SPRINT_MULTIPLIER
			$"hitbox#1".set_deferred("disabled",true)
			$"hitbox#2".set_deferred("disabled",false)
			
		#if Input.is_action_just_pressed("dash") and not is_dashing and direction.x != 0 and dash_use ==1:
			#$AnimatedSprite2D.play("dash")
			#start_dash(direction)
			#dash_use=0

			
		velocity.x = direction.x * current_speed
		move_and_slide()
		
		update_animation(direction) 
		

		
func start_dash(dir: Vector2):
	if is_playing_special:
		return
	is_dashing = true
	dash_direction = dir.normalized()
	dash_timer = DASH_DURATION
	$AnimatedSprite2D.play("dash") 
		
func end_dash():
	is_dashing = false
	velocity.x = 0

var is_playing_special=false
	
func update_animation(direction: Vector2):
	if is_dashing or is_playing_special:
		return 
	
	if not is_on_floor():
		if velocity.y >0:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.play("fall")	
			
	elif direction.x !=0 and is_on_floor():
		if Input.is_action_pressed("sprint"):
			$AnimatedSprite2D.play("run") 
		else:
			$AnimatedSprite2D.play("walk")
	else:
		if Input.is_action_pressed("down") and is_on_floor():
			$AnimatedSprite2D.play("crouch")
		else: 
			$AnimatedSprite2D.play("idle")
var last_dir := 5
var input_buffer: Array = []
var buffer_limit := 7  
var input_timer := 0.0
var input_timeout := 1.0  
		
func _process(delta):
	input_timer+=delta
	var punch= 0
	
	var x= 0
	var y= 0
	
	if Input.is_action_pressed("move_right") :
		x = 1
	elif Input.is_action_pressed("move_left"):
		x=-1
	
	if Input.is_action_pressed("down") :
		y= 1
		
	elif Input.is_action_pressed("jump"):
		y=-1
	
	var numpad = get_numpad_direction(x,y)
	if side == 0:  
		numpad = mirror_numpad(numpad)
	if numpad != last_dir and numpad != 5:
		record_input(numpad)
		last_dir = numpad
		input_timer = 0.0
	elif numpad == 5:
		last_dir = 5
		
	if Input.is_action_just_pressed("punch"):
		record_attack("p")
		input_timer = 0.0
		
	if Input.is_action_just_pressed("slash"):
		record_attack("s")
		input_timer = 0.0
		
	if Input.is_action_just_pressed("kick"):
		record_attack("k")
		input_timer = 0.0
		
	if Input.is_action_just_pressed("heavy_slash"):
		record_attack("h")
		input_timer = 0.0
		
		
	if input_timer > input_timeout and input_buffer.size() > 0:
		input_buffer.clear()
		
	
	
func get_numpad_direction(x,y):
	match [x,y]:
		[-1, -1]:return 7
		[0, -1]: return 8
		[1, -1]: return 9
		[-1, 0]: return 4
		[0, 0]: return 5 
		[1, 0]: return 6
		[-1, 1]: return 1
		[0, 1]: return 2
		[1, 1]: return 3
		_: return 5 
func mirror_numpad(numpad: int) -> int:
	match numpad:
		1: return 3
		3: return 1
		4: return 6
		6: return 4
		7: return 9
		9: return 7
		_: return numpad 

var combo_list = [
	{"sequence": "236s", "anim": "special_1", "duration": 1, "name": "slide"},
	{"sequence": "236h", "anim": "special_2", "duration": 1, "name": "famenir"},
	{"sequence": "s", "anim": "slash_1", "duration": 0.5, "name": "slash_1"},
	{"sequence": "p", "anim": "punch_1", "duration": 0.25, "name": "punch_1"},
	{"sequence": "k", "anim": "kick_1", "duration": 0.5, "name": "punch_1"},
	{"sequence": "h", "anim": "heavy_slash_1", "duration": 0.5, "name": "hs1"},
]
var combo_crouch=[
	
	{"sequence": "s", "anim": "slash_2", "duration": 0.5, "name": "slash_2"},
	{"sequence": "p", "anim": "punch_2", "duration": 0.5, "name": "punch_2"},
	{"sequence": "k", "anim": "kick_2", "duration": 0.5, "name": "punch_2"},
	{"sequence": "h", "anim": "heavy_slash_2", "duration": 0.5, "name": "hs2"},
]
var combo_in_air=[
	{"sequence": "22h", "anim": "volcanic", "duration": 1, "name": "volcnic"},
]


func record_input(n):
	if is_playing_special:
		return
	input_buffer.append(n)
	if input_buffer.size() > buffer_limit:
		input_buffer.pop_front()
	print("Inputs:", input_buffer)
	check_special_moves()
	
func record_attack(button):
	if is_playing_special:
		return

		if last_dir != 5:
			record_input(last_dir)
	record_input(button)

func consume_sequence(sequence: String) -> bool:
	var str_input = ""
	for numpad in input_buffer:
		str_input += str(numpad)
	if str_input.ends_with(sequence):
		input_buffer = input_buffer.slice(0, input_buffer.size()-sequence.length())
		return true
	return false
	
func check_special_moves():
	if is_playing_special:
		return
		
	if not is_on_floor():
		for combo in combo_in_air:
			if consume_sequence(combo["sequence"]):
				await play_special_move(combo["anim"], combo["duration"])
				print(combo["name"])
				return
				
	elif Input.is_action_pressed("down"):
		for combo in combo_crouch:
			if consume_sequence(combo["sequence"]) and is_on_floor():
				await play_special_move(combo["anim"], combo["duration"])
				print(combo["name"])
				return
	else:
		for combo in combo_list:
			if consume_sequence(combo["sequence"]) and is_on_floor():
				await play_special_move(combo["anim"], combo["duration"])
				print(combo["name"])
				return
				
func play_special_move(anim_name: String, duration: float):
	if is_playing_special:
		return
	is_playing_special = true
	$AnimatedSprite2D.play(anim_name)

	await get_tree().create_timer(duration).timeout
	is_playing_special = false
