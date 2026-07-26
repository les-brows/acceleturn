class_name CharacterManager
extends Node2D

var curr_action: Globals.CharacterAction = Globals.CharacterAction.DEFAULT
var curr_tile: Vector2i = Vector2i(-1, -1)

func _ready() -> void:
	Globals.state_started.connect(_on_state_started)
	init_characters_positions()

func _on_state_started(state: Globals.StateTurn):
	if(state == Globals.StateTurn.ACTION_CHARACTER):
		process_character_turn()
		Globals.state_finished.emit(Globals.StateTurn.ACTION_CHARACTER)

func init_characters_positions():
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
	curr_action = action

func set_current_tile(tile: Vector2i):
	curr_tile = tile

func can_choose_tile(tile: Vector2i) -> bool:
	return true;

func action_needs_target() -> bool:
	match Globals.curr_character:
		Globals.CharacterClass.GUNNER:
			match curr_action:
				Globals.CharacterAction.ACTION1:
					return	true
				Globals.CharacterAction.ACTION2:
					return	true
				Globals.CharacterAction.ACTION3:
					return	true
				Globals.CharacterAction.ACTION4:
					return	true
		Globals.CharacterClass.MAGE:
			match curr_action:
				Globals.CharacterAction.ACTION1:
					return	true
				Globals.CharacterAction.ACTION2:
					return	false
				Globals.CharacterAction.ACTION3:
					return	false
				Globals.CharacterAction.ACTION4:
					return	false
		Globals.CharacterClass.TRAPPER:
			match curr_action:
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
	if(curr_action == Globals.CharacterAction.DEFAULT):
		Globals.timerDuration += 5
		return;

	if(Globals.curr_character == Globals.CharacterClass.GUNNER):
		for child in get_children():
			if child is Gunner:
				child.act(curr_action)

	if(Globals.curr_character == Globals.CharacterClass.MAGE):
		for child in get_children():
			if child is Mage:
				child.act(curr_action)

	if(Globals.curr_character == Globals.CharacterClass.TRAPPER):
		for child in get_children():
			if child is Trapper:
				child.act(curr_action)
