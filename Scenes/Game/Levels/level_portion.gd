extends Node2D

enum StateTurn  { CHOICE_CHARACTER, CHOICE_ACTION, ACTION_CHARACTER , DEPLACEMENT_ENEMIES}

signal input_received

var state : StateTurn = StateTurn.CHOICE_CHARACTER
var characterChosen : Globals.CharacterClass = Globals.CharacterClass.NONE;

func _process(_delta):
	match state:
		StateTurn.CHOICE_CHARACTER :
			state=StateTurn.CHOICE_ACTION
			#Choice Perso 
		StateTurn.CHOICE_ACTION :
			state=StateTurn.ACTION_CHARACTER
			#set ACTION 
		StateTurn.ACTION_CHARACTER :
			state = StateTurn.DEPLACEMENT_ENEMIES
			#emit ? 
			#player.ExecuteAction(nextAction) # Add Action  
			
		StateTurn.DEPLACEMENT_ENEMIES :
			state = StateTurn.CHOICE_CHARACTER 
			


func _on_player_choose_character(character: Globals.CharacterClass):
	print("Choose player %d " % character)
	characterChosen = characterChosen
	

func _on_player_choose_action(action: Globals.CHARACTER_ACTION):
	print("Choose action %d " % action)
	#Do action or ask input
