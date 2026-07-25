class_name Level
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
	#if(!clicked && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT )==true):
		#var positionmouse: Vector2i = get_map_position_from_mouse()
		#get_type_case_from_position(positionmouse.x, positionmouse.y)
		##print(result )
		#getPostionAbsoluteFromCoordinates(positionmouse.x, positionmouse.y)
		##print("absolute , ", absoluteposition)
		#clicked = true
	#else :
		#clicked = false
	pass


func _on_player_choose_character(character: Globals.CharacterClass):
	print("Choose player %d " % character)
	characterChosen = character
	characterManager.set_current_character(characterChosen)
	set_player_move_ui(characterManager.get_current_character_node())
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_CHARACTER)
	
func set_player_move_ui(player_node: Node2D):
	pass

func _on_player_choose_action(action: Globals.CharacterAction):
	print("Choose action %d " % action)
	characterManager.set_current_action(action)
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)

	
func _on_state_finished(state: Globals.StateTurn):
	assert(state == curr_state)
	
	match state:
		Globals.StateTurn.CHOICE_CHARACTER :
			curr_state=Globals.StateTurn.CHOICE_ACTION
		Globals.StateTurn.CHOICE_ACTION :
			if(characterManager.action_needs_target()):
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


func get_map_position_from_mouse() -> Vector2i:
	var mouse_position = get_global_mouse_position()
	var current_tile = get_node("TileMapGround").local_to_map(mouse_position)
	var tile_position: Vector2
	tile_position =  get_node("TileMapGround").map_to_local(current_tile)
	var result : Vector2  

	#print("Position_Click x=", tile_position.x," y=", tile_position.y , "Size tile",Globals.SIZE_CELL_X )
	@warning_ignore("integer_division")
	result.x= tile_position.x/Globals.SIZE_CELL_X
	@warning_ignore("integer_division")
	result.y= tile_position.y/Globals.SIZE_CELL_Y 
	
	#print("Position_Click x=", result.x," y=", result.y)
	return result


func getCoordinatesFromPostionAbsolute(initial_pos: Vector2) -> Vector2i:
	var current_tile = get_node("TileMapGround").local_to_map(initial_pos)
	var tile_position: Vector2
	tile_position =  get_node("TileMapGround").map_to_local(current_tile)
	var result : Vector2  

	result.x = tile_position.x / Globals.SIZE_CELL_X
	result.y = tile_position.y / Globals.SIZE_CELL_Y 

	return result

func getPostionAbsoluteFromCoordinates( columnIndex : int ,lineIndex : int ) -> Vector2i:
	var postion = Vector2(columnIndex*64,lineIndex*64)
	var current_tile = get_node("TileMapGround").local_to_map(postion)
	var tile_position: Vector2
	tile_position =  get_node("TileMapGround").map_to_local(current_tile)	
	
	#print("Position_tile x=", tile_position.x," y=", tile_position.y)
	
	return tile_position
	
	
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
	
	
func get_type_case_from_position( columnIndex : int, lineIndex : int ) -> Globals.TypeCase :
	if(lineIndex>=caseContent.size()):
		#print("Line INVALID !!!")
		return  Globals.TypeCase.EMPTY
	else :
		var lineContent : Array = caseContent[lineIndex]
		if(columnIndex>=lineContent.size()):
			#print("COLUMN INVALID !!!")
			return  Globals.TypeCase.EMPTY
		else :
			return lineContent[columnIndex]
			
func update_case( columnIndex : int, lineIndex : int , newType: Globals.TypeCase ) ->bool :
	var success : bool =true
	if(lineIndex>=caseContent.size()):
		#print("Line INVALID !!!")
		success=false
	else :
		var lineContent : Array = caseContent[lineIndex]
		if(columnIndex>=lineContent.size()):
			#print("COLUMN INVALID !!!")
			success = false
		else :
			lineContent[columnIndex] = newType
			#real update
	return success 


func _on_level_timer_end():
	# TODO : kill yourself here
	print("Game over!!!!! Timer is done!!!!!!!!!!!!")
	pass
	
#return next position and sizePath 
func path_find( positionInit :Vector2i,  withEnemies : bool,  withEnvironement : bool) ->Array :
	var nextPosition :Vector2i 
	nextPosition.x=0
	nextPosition.y=0
	var sizePath=50
	
	var astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, Globals.NUMBER_CELL_X,Globals.NUMBER_CELL_Y)
	astar_grid.cell_size = Vector2(1, 1)
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	var line :Array
	var point:Vector2i
	#Remove Obstacle and enemies 
	for i in range(Globals.NUMBER_CELL_Y):
		line = caseContent[i]
		for j in range(Globals.NUMBER_CELL_X):
			point.y=i
			point.x=j
			if(!withEnvironement && (line[j]==Globals.TypeCase.TREE || line[j]==Globals.TypeCase.BUSH)):
				astar_grid.set_point_solid(point, true)
			if(line[j]==Globals.TypeCase.ICE):
				astar_grid.set_point_solid(point, true)
			if(!withEnemies && (line[j]==Globals.TypeCase.ENEMIES )):
				astar_grid.set_point_solid(point, true)
				
	astar_grid.update()
	
	#Path finding for all case after the line 
	var Path:Array
	point.x=Globals.COLUMN_MAX_ENEMIES
	for i in range(Globals.NUMBER_CELL_Y):
		point.y=i
		Path = astar_grid.get_id_path(positionInit, point)
		#Keep the best 
		if(Path.size() > 1 && Path.size()<sizePath):
			sizePath=Path.size()
			nextPosition=Path[1]
			
			
	#default if there are no path 
	if(sizePath==50):
		sizePath=0
	return  [nextPosition,sizePath ]
 
