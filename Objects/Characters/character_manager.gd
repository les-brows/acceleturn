class_name CharacterManager
extends Node2D

var curr_tile: Vector2i = Vector2i(-1, -1)

func _ready() -> void:
	Globals.state_started.connect(_on_state_started)
	#init_characters_positions()

func _on_state_started(state: Globals.StateTurn):
	if(state == Globals.StateTurn.ACTION_CHARACTER):
		process_character_turn()
		await get_tree().create_timer(0.2).timeout
		Globals.state_finished.emit(Globals.StateTurn.ACTION_CHARACTER)

func init_characters_positions():
	position=Vector2(0,0)
	for character in get_children():
		if character is Character:
			character.init_entity(get_parent())

func get_current_character_node() -> Node2D:
	match Globals.curr_character:
		Globals.CharacterClass.GUNNER:
			for child in get_children():
				if child is Gunner:
					return child
		
		Globals.CharacterClass.MAGE:
			for child in get_children():
				if child is Mage:
					return child
		
		Globals.CharacterClass.TRAPPER:
			for child in get_children():
				if child is Trapper:
					return child
	return null



func set_current_character(character : Globals.CharacterClass):
	Globals.curr_character = character
	
func set_current_action(action: Globals.CharacterAction):
	Globals.curr_action = action

func set_current_tile(tile: Vector2i):
	curr_tile = tile

func can_choose_tile(tile: Vector2i) -> bool:
	var typeCase: Globals.TypeCase = get_parent().get_type_case_from_position(tile.x, tile.y)
	var canChoose: bool = true
	print(typeCase)
	
	# Only entities
	if(Globals.curr_character == Globals.CharacterClass.GUNNER && Globals.curr_action == Globals.CharacterAction.ACTION1):
		if(!(typeCase == Globals.TypeCase.ENEMIES or typeCase == Globals.TypeCase.CHARACTER)):
			return false
			
	
	# Only horizontal
	if(Globals.curr_character == Globals.CharacterClass.GUNNER && Globals.curr_action == Globals.CharacterAction.ACTION1):
		# Check for the gunner
		if(tile.y != get_gunner().caseCoords.y):
			return false
	
	# Only vertical
	if(Globals.curr_character == Globals.CharacterClass.GUNNER && Globals.curr_action == Globals.CharacterAction.ACTION3):
		# Check for the gunner
		if(tile.x != get_gunner().caseCoords.x):
			return false

	return true

func action_needs_target() -> bool:
	match Globals.curr_character:
		Globals.CharacterClass.GUNNER:
			match Globals.curr_action:
				Globals.CharacterAction.ACTION1:
					return	true
				Globals.CharacterAction.ACTION2:
					return	true
				Globals.CharacterAction.ACTION3:
					return	true
				Globals.CharacterAction.ACTION4:
					return	true
		Globals.CharacterClass.MAGE:
			match Globals.curr_action:
				Globals.CharacterAction.ACTION1:
					return	true
				Globals.CharacterAction.ACTION2:
					return	false
				Globals.CharacterAction.ACTION3:
					return	false
				Globals.CharacterAction.ACTION4:
					return	false
		Globals.CharacterClass.TRAPPER:
			match Globals.curr_action:
				Globals.CharacterAction.ACTION1:
					return	true
				Globals.CharacterAction.ACTION2:
					return	true
				Globals.CharacterAction.ACTION3:
					return	true
				Globals.CharacterAction.ACTION4:
					return	true
	return false

func process_character_turn():
	if(action_needs_target() && curr_tile == Vector2i(-1, -1)):
		Globals.curr_action = Globals.CharacterAction.DEFAULT

	if(Globals.curr_action == Globals.CharacterAction.DEFAULT):
		Globals.timerDuration += 5
		return;

	if(Globals.curr_character == Globals.CharacterClass.GUNNER):
		get_gunner().act(Globals.curr_action, curr_tile)

	if(Globals.curr_character == Globals.CharacterClass.MAGE):
		get_mage().act(Globals.curr_action, curr_tile)

	if(Globals.curr_character == Globals.CharacterClass.TRAPPER):
		get_trapper().act(Globals.curr_action, curr_tile)
				
func get_gunner() -> Entity:
	for child in get_children():
		if child is Gunner:
			return child
	return null

func get_mage() -> Entity:
	for child in get_children():
		if child is Mage:
			return child
	return null

func get_trapper() -> Entity:
	for child in get_children():
		if child is Trapper:
			return child
	return null
				
func getEntityAtPos(tile : Vector2i) -> Entity:
	for child in get_children():
		if child is Entity:
			if(child.caseCoords == tile):
				return	child
	return null
