extends Node

signal move_update(move_x : Array, move_y : Array)
signal click_update(position : Array)
#signal shoot_update()
#signal dash_update()
#signal slow_end_update()
#signal slow_begin_update()
#signal shoot_direction_update(shoot_x:float,shoot_y:float)


static var move_directions_x:float = 0
static var move_directions_y:float = 0
static var player_dead: bool = false
static var game_paused: bool = false
static var can_pass_end_level: bool = false

static var shoot_directions_x:float = 0
static var shoot_directions_y:float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_move()
	update_click()
	
	
func _init() -> void:
	
	player_dead = false
	game_paused = false
	
#func _on_player_death():
	#player_dead = true
	#
#func _on_end_level_reached():
	#if not can_pass_end_level:
		#return
	#can_pass_end_level = false
	#game_paused = true
#
#func _on_middle_level_reached() -> void:
	#can_pass_end_level = true
	#
#func _on_augment_selected():
	#game_paused = false
	
	

func update_move():
	# Block inputs if player is dead
	if player_dead or game_paused:
		move_update.emit(0, 0)
		return
		
	# Horizontal input
	if Input.is_action_pressed("player1_left"):
		move_directions_x = -Input.get_action_strength("player1_left")
	else:
		if Input.is_action_pressed("player1_right"):
			move_directions_x = Input.get_action_strength("player1_right")
		else:
			move_directions_x = 0
			
	# Vertical input
	if Input.is_action_pressed("player1_up"):
		move_directions_y = -Input.get_action_strength("player1_up")
	else:
		if Input.is_action_pressed("player1_down"):
			move_directions_y = Input.get_action_strength("player1_down")
		else:
			move_directions_y = 0
	

	move_update.emit(move_directions_x, move_directions_y)
	
func update_click(): 	
	var mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("player1_click"):
		#move_click.emit(mouse_position)
		var o=0
#
#func update_shoot_input() -> void:
	#if Input.is_action_just_pressed("player1_shoot"):
		#shoot_update.emit()
#
#func update_dash_input() -> void:
	#if Input.is_action_just_pressed("player1_dash"):
		#dash_update.emit()
		#
#func update_slow_input() -> void:
	#if Input.is_action_just_pressed("player1_slow"):
		#slow_begin_update.emit()
	#if Input.is_action_just_released("player1_slow"):
		#slow_end_update.emit()

	

#func update_shoot_direction():
	## Horizontal input
	#if Input.is_action_pressed("player1_shoot_left"):
		#shoot_directions_x = -1
	#else:
		#if Input.is_action_pressed("player1_shoot_right"):
			#shoot_directions_x = 1
		#else:
			#shoot_directions_x = 0
			#
	## Vertical input
	#if Input.is_action_pressed("player1_shoot_up"):
		#shoot_directions_y = -1
	#else:
		#if Input.is_action_pressed("player1_shoot_down"):
			#shoot_directions_y = 1
		#else:
			#shoot_directions_y = 0
	#
#
	#shoot_direction_update.emit(shoot_directions_x, shoot_directions_y)
