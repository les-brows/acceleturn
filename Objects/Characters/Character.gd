class_name Character
extends Entities


func act(action: Globals.CharacterAction):

	match action:
		Globals.CharacterAction.MOVE_LEFT:
			move(Vector2i(-1, 0))
		Globals.CharacterAction.MOVE_RIGHT:
			move(Vector2i(1, 0))
		Globals.CharacterAction.MOVE_UP:
			move(Vector2i(0, -1))
		Globals.CharacterAction.MOVE_DOWN:
			move(Vector2i(0, 1))
