extends Node2D

@onready var enemyTurnManager: EnemyTurnManager = $EnemyTurnManager
@onready var characterManager: CharacterManager = $CharacterManager

var curr_state : Globals.StateTurn = Globals.StateTurn.CHOICE_CHARACTER
var characterChosen : Globals.CharacterClass = Globals.CharacterClass.NONE;

func _init() -> void:
	Globals.state_finished.connect(_on_state_finished)

func _process(_delta):
	pass


func _on_player_choose_character(character: Globals.CharacterClass):
	print("Choose player %d " % character)
	characterChosen = character
	characterManager.set_current_character(characterChosen)
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_CHARACTER)
	

func _on_player_choose_action(action: Globals.CHARACTER_ACTION):
	print("Choose action %d " % action)
	#Do action or ask input
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)

	
func _on_state_finished(state: Globals.StateTurn):
	print("State finished: %s" % state)
	assert(state == curr_state)
	
	match state:
		Globals.StateTurn.CHOICE_CHARACTER :
			curr_state=Globals.StateTurn.CHOICE_ACTION
		Globals.StateTurn.CHOICE_ACTION :
			if(0):
				curr_state=Globals.StateTurn.CHOICE_TARGET_CHARACTER
				#set ACTION 
			else:
				curr_state = Globals.StateTurn.ACTION_CHARACTER
				
		Globals.StateTurn.CHOICE_TARGET_CHARACTER :
			curr_state = Globals.StateTurn.ACTION_CHARACTER

		Globals.StateTurn.ACTION_CHARACTER :
			curr_state = Globals.StateTurn.ACTION_ENEMIES
		Globals.StateTurn.ACTION_ENEMIES :
			curr_state = Globals.StateTurn.CHOICE_CHARACTER 
	
	Globals.state_started.emit(curr_state)
	print("Send state %s" % curr_state)
