class_name Mage
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
			# U should kill yourself, NOW
			var entity: Entity = _level.get_entity_at_pos(tile)
			_level.update_case(entity.caseCoords.x, entity.caseCoords.y, Globals.TypeCase.EMPTY)
			entity.queue_free()
			
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.MAGE_ACTION1_TIME_ADDED

		Globals.CharacterAction.ACTION2:
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.MAGE_ACTION2_TIME_ADDED

		Globals.CharacterAction.ACTION3:
			# Move everyone to gain time
			for entity in _level.get_all_entities():
				entity.move(Vector2i(-1, 0))
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration *= Globals.MAGE_ACTION3_TIME_MULT

		Globals.CharacterAction.ACTION4:
			Globals.timeFreezeTurns = Globals.MAGE_ACTION4_DURATION
			Globals.timerDuration /= Globals.MAGE_ACTION4_TIME_MULT


signal _on_choose_character(character: Globals.CharacterClass)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		#print('Clicked the mage!')
		if(Globals.curr_state == Globals.StateTurn.CHOICE_CHARACTER):
			_on_choose_character.emit(Globals.CharacterClass.MAGE)
