class_name CharacterManager
extends Node2D

var curr_character: Globals.CharacterClass = Globals.CharacterClass.NONE
var curr_action: Globals.CharacterAction = Globals.CharacterAction.DEFAULT

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



func set_current_character(character : Globals.CharacterClass):
	curr_character = character
	
func set_current_action(action: Globals.CharacterAction):
	curr_action = action
	
func action_needs_target() -> bool:
	return false

func process_character_turn():
	if(curr_action == Globals.CharacterAction.DEFAULT):
		Globals.timerDuration += 5
		return;

	print("Mes persos vont faire des trucs tkt")
	if(curr_character == Globals.CharacterClass.GUNNER):
		for child in get_children():
			if child is Gunner:
				child.act()
		print("Je suis le gunner, mon gun est délicieux")
	else:
		print("Le personnage choisi n'a AUCUN BUZZ")
