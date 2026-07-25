extends Node2D

func _on_player_choose_character(playerIndex: int):
	print("Choose player %d " % playerIndex)

func _on_player_choose_action(action: Globals.CHARACTER_ACTION):
	print("Choose action %d " % action)
