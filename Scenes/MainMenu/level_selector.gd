extends MarginContainer

@onready var selector_1 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect
@onready var selector_2 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect2
@onready var selector_3 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect3
@onready var selector_4 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect4
@onready var selector_5 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect5
@onready var selector_6 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/ReferenceRect6
@onready var selector_7 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect
@onready var selector_8 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect2
@onready var selector_9 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect3
@onready var selector_10 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect4
@onready var selector_11 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect5
@onready var selector_12 = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/ReferenceRect6

@onready var selectors = [selector_1,selector_2,selector_3,selector_4,selector_5,selector_6,selector_7,selector_8,selector_9,selector_10,selector_11,selector_12]

const game_scene = preload("res://Scenes/Game/GameScene.tscn")
const level_1_scene = preload("res://Scenes/Game/Levels/Level_1.tscn")
const level_2_scene = preload("res://Scenes/Game/Levels/Level_2.tscn")
const level_3_scene = preload("res://Scenes/Game/Levels/Level_3.tscn")
const level_4_scene = preload("res://Scenes/Game/Levels/Level_4.tscn")
const level_5_scene = preload("res://Scenes/Game/Levels/Level_5.tscn")
const level_6_scene = preload("res://Scenes/Game/Levels/Level_6.tscn")
const level_7_scene = preload("res://Scenes/Game/Levels/Level_7.tscn")
const level_8_scene = preload("res://Scenes/Game/Levels/Level_8.tscn")
const level_9_scene = preload("res://Scenes/Game/Levels/Level_9.tscn")
const level_10_scene = preload("res://Scenes/Game/Levels/Level_10.tscn")
const level_11_scene = preload("res://Scenes/Game/Levels/Level_11.tscn")
const level_12_scene = preload("res://Scenes/Game/Levels/Level_12.tscn")


var selected_level = -1
var current_selection = 0
var previous_selection = 0
const NUM_OF_LEVELS = 12

var max_unlocked_level = 12


func _ready() -> void:
	hide_unlocked_levels(max_unlocked_level)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	previous_selection = current_selection
	
	if Input.is_action_just_pressed("ui_cancel"):
		var main_menu_scene = load("res://Scenes/MainMenu/main_menu.tscn")
		get_parent().add_child(main_menu_scene.instantiate())
		queue_free()
	
	if Input.is_action_just_pressed("input_right"):
		# If level is unselectable
		if current_selection + 1 >= max_unlocked_level:
			return
			
		# If selected level is on the border
		if current_selection % 6 == 5:
			return
			
		current_selection += 1
		set_selected_level(previous_selection, current_selection)
		
	if Input.is_action_just_pressed("input_left"):
		# If selected level is on the border
		if current_selection % 6 == 0:
			return
			
		current_selection -= 1
		set_selected_level(previous_selection, current_selection)
		
	if Input.is_action_just_pressed("input_down"):
		# If level is unselectable
		if current_selection + 6 >= max_unlocked_level:
			return
			
		# if selected level is on the border
		if current_selection + 6 >= NUM_OF_LEVELS:
			return
			
		current_selection += 6
		set_selected_level(previous_selection, current_selection)
		
	if Input.is_action_just_pressed("input_up"):
		# if selected level is on the border
		if current_selection - 6 < 0:
			return
			
		current_selection -= 6
		set_selected_level(previous_selection, current_selection)
		
	if Input.is_action_just_pressed("ui_accept"):
		handle_level_selection(current_selection)
		
func set_selected_level(previous_level: int, level: int) -> void:
	unset_selected_level(previous_level)
	
	var selector = selectors[level]
	selector.get_node("Selected").visible = true


func unset_selected_level(level: int) -> void:
	var selector = selectors[level]
	selector.get_node("Selected").visible = false


func handle_level_selection(level: int) -> void:
	var level_node
	var game_scene_node = game_scene.instantiate()
	
	await SceneTransition.close_circle()
	
	Globals.selected_level = level
	
	if level == 0:
		level_node = level_1_scene.instantiate()
	if level == 1:
		level_node = level_2_scene.instantiate()
	if level == 2:
		level_node = level_3_scene.instantiate()
	if level == 3:
		level_node = level_4_scene.instantiate()
	if level == 4:
		level_node = level_5_scene.instantiate()
	if level == 5:
		level_node = level_6_scene.instantiate()
	if level == 6:
		level_node = level_7_scene.instantiate()
	if level == 7:
		level_node = level_8_scene.instantiate()
	if level == 8:
		level_node = level_9_scene.instantiate()
	if level == 9:
		level_node = level_10_scene.instantiate()
	if level == 10:
		level_node = level_11_scene.instantiate()
	if level == 11:
		level_node = level_12_scene.instantiate()
	
	game_scene_node.add_child(level_node)
	get_parent().add_child(game_scene_node)
	queue_free()
		
func hide_unlocked_levels(max_level: int) -> void:
	for i in range(0, NUM_OF_LEVELS):
		var selector = selectors[i]
		if ( i >= max_level ):
			selector.get_node("Option").text = ""
			selector.get_node("Locked").visible = true
			selector.get_node("Button").disabled = true
		else :
			selector.get_node("Option").text = "%d" % (i+1)
			selector.get_node("Locked").visible = false
			selector.get_node("Button").disabled = false


func _on_button_1_mouse_entered() -> void:
	set_selected_level(previous_selection, 0)


func _on_button_1_mouse_exited() -> void:
	unset_selected_level(0)


func _on_button_1_pressed() -> void:
	handle_level_selection(0)


func _on_button_2_mouse_entered() -> void:
	set_selected_level(previous_selection, 1)


func _on_button_2_mouse_exited() -> void:
	unset_selected_level(1)


func _on_button_2_pressed() -> void:
	handle_level_selection(1)


func _on_button_3_mouse_entered() -> void:
	set_selected_level(previous_selection, 2)


func _on_button_3_mouse_exited() -> void:
	unset_selected_level(2)


func _on_button_3_pressed() -> void:
	handle_level_selection(2)


func _on_button_4_mouse_entered() -> void:
	set_selected_level(previous_selection, 3)


func _on_button_4_mouse_exited() -> void:
	unset_selected_level(3)


func _on_button_4_pressed() -> void:
	handle_level_selection(3)


func _on_button_5_mouse_entered() -> void:
	set_selected_level(previous_selection, 4)


func _on_button_5_mouse_exited() -> void:
	unset_selected_level(4)


func _on_button_5_pressed() -> void:
	handle_level_selection(4)


func _on_button_6_mouse_entered() -> void:
	set_selected_level(previous_selection, 5)


func _on_button_6_mouse_exited() -> void:
	unset_selected_level(5)


func _on_button_6_pressed() -> void:
	handle_level_selection(5)


func _on_button_7_mouse_entered() -> void:
	set_selected_level(previous_selection, 6)


func _on_button_7_mouse_exited() -> void:
	unset_selected_level(6)


func _on_button_7_pressed() -> void:
	handle_level_selection(6)


func _on_button_8_mouse_entered() -> void:
	set_selected_level(previous_selection, 7)


func _on_button_8_mouse_exited() -> void:
	unset_selected_level(7)


func _on_button_8_pressed() -> void:
	handle_level_selection(7)


func _on_button_9_mouse_entered() -> void:
	set_selected_level(previous_selection, 8)


func _on_button_9_mouse_exited() -> void:
	unset_selected_level(8)


func _on_button_9_pressed() -> void:
	handle_level_selection(8)


func _on_button_10_mouse_entered() -> void:
	set_selected_level(previous_selection, 9)


func _on_button_10_mouse_exited() -> void:
	unset_selected_level(9)


func _on_button_10_pressed() -> void:
	handle_level_selection(9)


func _on_button_11_mouse_entered() -> void:
	set_selected_level(previous_selection, 10)


func _on_button_11_mouse_exited() -> void:
	unset_selected_level(10)


func _on_button_11_pressed() -> void:
	handle_level_selection(10)


func _on_button_12_mouse_entered() -> void:
	set_selected_level(previous_selection, 11)


func _on_button_12_mouse_exited() -> void:
	unset_selected_level(11)


func _on_button_12_pressed() -> void:
	handle_level_selection(11)
