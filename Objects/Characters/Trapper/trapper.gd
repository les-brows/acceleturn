class_name Trapper
extends Character

func act(action: Globals.CharacterAction):
	if(action == Globals.CharacterAction.MOVE_LEFT or 
	   action == Globals.CharacterAction.MOVE_RIGHT or
	   action == Globals.CharacterAction.MOVE_UP or
	   action == Globals.CharacterAction.MOVE_DOWN):
		super(action)
		return

	match action:
		Globals.CharacterAction.ACTION1:
			Globals.timerDuration += 0
		Globals.CharacterAction.ACTION2:
			Globals.timerDuration -= 2
		Globals.CharacterAction.ACTION3:
			Globals.timerDuration -= 5
		Globals.CharacterAction.ACTION4:
			Globals.timerDuration -= 30
signal _on_choose_character(character: Globals.CharacterClass)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('Clicked the trapper!')
		if(Globals.curr_state == Globals.StateTurn.CHOICE_CHARACTER):
			_on_choose_character.emit(Globals.CharacterClass.TRAPPER)
