extends Node2D

enum StateTurn  { CHOICE_CHARACTER, CHOICE_ACTION, ACTION_CHARACTER , DEPLACEMENT_ENEMIES}

signal state_finished(state: StateTurn)

var curr_state : StateTurn = StateTurn.CHOICE_CHARACTER
var characterChosen : Globals.CharacterClass = Globals.CharacterClass.NONE;

func _init() -> void:
	state_finished.connect(_on_state_finished)

func _process(_delta):
	pass



func _on_player_choose_character(character: Globals.CharacterClass):
	print("Choose player %d " % character)
	characterChosen = characterChosen
	state_finished.emit(StateTurn.CHOICE_CHARACTER)
	

func _on_player_choose_action(action: Globals.CHARACTER_ACTION):
	print("Choose action %d " % action)
	#Do action or ask input
	state_finished.emit(StateTurn.CHOICE_ACTION)

	
func _on_state_finished(state: StateTurn):
	print("State finished: %s" % state)
	assert(state == curr_state)
	
	match state:
		StateTurn.CHOICE_CHARACTER :
			curr_state=StateTurn.CHOICE_ACTION
		StateTurn.CHOICE_ACTION :
			if(1):
				curr_state=StateTurn.ACTION_CHARACTER
			else:
				curr_state = StateTurn.DEPLACEMENT_ENEMIES
			#set ACTION 
		StateTurn.ACTION_CHARACTER :
			curr_state = StateTurn.DEPLACEMENT_ENEMIES
			#emit ? 
			#player.ExecuteAction(nextAction) # Add Action  
			
		StateTurn.DEPLACEMENT_ENEMIES :
			curr_state = StateTurn.CHOICE_CHARACTER 
