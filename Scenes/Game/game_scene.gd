extends Node2D

@onready var uiMenu = $UI
@onready var level = $level

func _on_ready():
	uiMenu._on_choose_player.conect(level._on_player_choose_perso())
	uiMenu._on_choose_action.conect(level._on_player_choose_action())
