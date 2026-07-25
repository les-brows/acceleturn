extends Node2D

@onready var uiMenu = $UI
@onready var level = $Level
@onready var trapper = $Level/CharacterManager/Trapper
@onready var mage = $Level/CharacterManager/Mage
@onready var gunner = $Level/CharacterManager/Gunner

func _ready() -> void:
	trapper._on_choose_character.connect(level._on_player_choose_character)
	mage._on_choose_character.connect(level._on_player_choose_character)
	gunner._on_choose_character.connect(level._on_player_choose_character)
	uiMenu._on_choose_character.connect(level._on_player_choose_character)
	uiMenu._on_choose_action.connect(level._on_player_choose_action)
	uiMenu._on_timer_end.connect(level._on_level_timer_end)
