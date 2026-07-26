class_name Trapper
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
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.TRAPPER_ACTION1_TIME_ADDED

		Globals.CharacterAction.ACTION2:
			# Set repulse trap
			_level.set_tile(tile, Globals.TypeCase.TRAP_REPULSE)
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.TRAPPER_ACTION2_TIME_ADDED

		Globals.CharacterAction.ACTION3:
			# Set tree
			_level.set_tile(tile, Globals.TypeCase.TREE)
			# TODO: Set if block pathfind
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.TRAPPER_ACTION3_TIME_ADDED
				
		Globals.CharacterAction.ACTION4:
			# Blackhole
			var zoneStart = tile - Vector2i(Globals.TRAPPER_ACTION4_RANGE, Globals.TRAPPER_ACTION4_RANGE)
			var zoneEnd = tile + Vector2i(Globals.TRAPPER_ACTION4_RANGE, Globals.TRAPPER_ACTION4_RANGE)
			for entity in _level.get_entities_in_zone(zoneStart, zoneEnd):
				var diff = tile - entity.caseCoords
				if(entity.is_push()):
					entity.move(diff.sign() * Globals.TRAPPER_ACTION4_PUSH_DISTANCE)
			
			if(!Globals.timeFreezeTurns):
				Globals.timerDuration += Globals.TRAPPER_ACTION4_TIME_ADDED


signal _on_choose_character(character: Globals.CharacterClass)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		#print('Clicked the trapper!')
		if(Globals.curr_state == Globals.StateTurn.CHOICE_CHARACTER):
			_on_choose_character.emit(Globals.CharacterClass.TRAPPER)
