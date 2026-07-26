class_name Character
extends Entity


func act(action: Globals.CharacterAction, tile: Vector2i):
	print("act:", action)
	Globals.timerDuration += -3
	match action:
		Globals.CharacterAction.MOVE_LEFT:
			move(Vector2i(-1, 0))
		Globals.CharacterAction.MOVE_RIGHT:
			move(Vector2i(1, 0))
		Globals.CharacterAction.MOVE_UP:
			move(Vector2i(0, -1))
		Globals.CharacterAction.MOVE_DOWN:
			move(Vector2i(0, 1))

func is_character() -> bool:
	return true

func get_case_entity() ->Globals.TypeCase:
	return Globals.TypeCase.CHARACTER

func obectif_game_over()->bool:
	return true
