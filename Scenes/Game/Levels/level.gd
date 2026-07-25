extends Node2D

@onready var enemyTurnManager: EnemyTurnManager = $EnemyTurnManager
@onready var characterManager: CharacterManager = $CharacterManager

var curr_state : Globals.StateTurn = Globals.StateTurn.CHOICE_CHARACTER
var characterChosen : Globals.CharacterClass = Globals.CharacterClass.NONE;


var caseContent : Array[Array]=[]


func _init() -> void:
	Globals.state_finished.connect(_on_state_finished)
	create_initial_map()
	
	
func _process(_delta):
	var clicked = false
	if(!clicked && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT )==true):
		var position: Vector2 = get_map_position_from_mouse()
		var test= get_type_case_from_position(position.y, position.x)
		print(test)
		clicked = true
	else :
		clicked = false
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
	
	var signal_to_send = curr_state
	Globals.state_started.emit(signal_to_send)


func get_map_position_from_mouse() -> Vector2:
	var mouse_position = get_global_mouse_position()
	var current_tile = get_node("TileMapGround").local_to_map(mouse_position)
	var tile_position: Vector2
	tile_position =  get_node("TileMapGround").map_to_local(current_tile)
	var result : Vector2  

	#print("Position_Click x=", tile_position.x," y=", tile_position.y , "Size tile",Globals.SIZE_CELL_X )
	result.x= int(tile_position.x/float(64))
	result.y= int(tile_position.y/float( 64))
	
	print("Position_Click x=", result.x," y=", result.y)
	
	return result
	
func create_initial_map():
	#TODO 
	var line :Array
	for i in range(Globals.NUMBER_CELL_Y):
		for j in range(Globals.NUMBER_CELL_X):
			if(j==3):
				line.append(Globals.TypeCase.BUSH)
			elif (i==2 && j==4) :
				line.append(Globals.TypeCase.TREE)
			else :
				line.append(Globals.TypeCase.EMPTY)
		caseContent.append(line)
	pass 
	
	
func get_type_case_from_position(lineIndex : int , columnIndex : int) -> Globals.TypeCase :
	if(caseContent.size()<lineIndex):
		print("Line INVALID !!!")
		return  Globals.TypeCase.EMPTY
	else :
		var lineContent : Array = caseContent[lineIndex]
		if(lineContent.size()<columnIndex):
			print("COLUMN INVALID !!!")
			return  Globals.TypeCase.EMPTY
		else :
			return lineContent[columnIndex]
	
	
