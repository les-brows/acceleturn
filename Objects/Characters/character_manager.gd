class_name CharacterManager
extends Node2D

var curr_character: Globals.CharacterClass = Globals.CharacterClass.NONE

func _ready() -> void:
	Globals.state_started.connect(_on_state_started)

func _on_state_started(state: Globals.StateTurn):
	if(state == Globals.StateTurn.ACTION_CHARACTER):
		process_character_turn()
		Globals.state_finished.emit(Globals.StateTurn.ACTION_CHARACTER)

func set_current_character(character : Globals.CharacterClass):
	curr_character = character

func process_character_turn():
	print("Mes persos vont faire des trucs tkt")
	if(curr_character == Globals.CharacterClass.GUNNER):
		for child in get_children():
			if child is Gunner:
				child.act()
		print("Je suis le gunner, mon gun est délicieux")
	else:
		print("Le personnage choisi n'a AUCUN BUZZ")
