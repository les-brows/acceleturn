class_name Gunner
extends Character

func act(action: Globals.CharacterAction, tile: Vector2i):
	if(action == Globals.CharacterAction.MOVE_LEFT or 
	   action == Globals.CharacterAction.MOVE_RIGHT or
	   action == Globals.CharacterAction.MOVE_UP or
	   action == Globals.CharacterAction.MOVE_DOWN):
		super(action, tile)
		return

	match action:
		Globals.CharacterAction.ACTION1:
			# Shoot and move
			Globals.timerDuration += Globals.GUNNER_ACTION1_TIME_ADDED
		Globals.CharacterAction.ACTION2:
			Globals.timerDuration += Globals.GUNNER_ACTION2_TIME_ADDED
		Globals.CharacterAction.ACTION3:
			Globals.timerDuration += Globals.GUNNER_ACTION3_TIME_ADDED
		Globals.CharacterAction.ACTION4:
			Globals.timerDuration += Globals.GUNNER_ACTION4_TIME_ADDED

signal _on_choose_character(character: Globals.CharacterClass)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('Clicked the gunner!')
		if(Globals.curr_state == Globals.StateTurn.CHOICE_CHARACTER):
			_on_choose_character.emit(Globals.CharacterClass.GUNNER)
