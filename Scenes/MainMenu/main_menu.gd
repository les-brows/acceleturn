extends MarginContainer

const level_selection_scene = preload("res://Scenes/MainMenu/LevelSelector.tscn")

@onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector
@onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector

var current_selection = -1
const MAX_SELECTION = 2

func _ready() -> void:
	set_current_selection(current_selection)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func set_current_selection(_current_selection):
	print(_current_selection)
	selector_one.text = ""
	selector_two.text = ""
	
	if _current_selection == 0:
		selector_one.text = "> "
	if _current_selection == 1:
		selector_two.text = "> "

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_parent().add_child(level_selection_scene.instantiate())
		queue_free()
		
	if _current_selection == 1:
		await SceneTransition.close_circle()
		get_tree().quit()


func _on_button_1_mouse_entered() -> void:
	print("hi")
	set_current_selection(0)


func _on_button_1_mouse_exited() -> void:
	set_current_selection(-1)


func _on_button_2_mouse_entered() -> void:
	set_current_selection(1)


func _on_button_2_mouse_exited() -> void:
	set_current_selection(-1)


func _on_button_1_pressed() -> void:
	handle_selection(0)


func _on_button_2_pressed() -> void:
	handle_selection(1)
