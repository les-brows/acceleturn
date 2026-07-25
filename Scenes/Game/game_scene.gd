extends Node2D

@onready var uiMenu = $UI
@onready var level = $Level

func _ready() -> void:
	uiMenu._on_choose_character.connect(level._on_player_choose_character)
	uiMenu._on_choose_action.connect(level._on_player_choose_action)
	uiMenu._on_timer_end.connect(level._on_level_timer_end)
