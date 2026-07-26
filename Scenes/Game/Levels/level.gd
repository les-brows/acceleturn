class_name Level
extends Node2D

@onready var TileMapGround: TileMapLayer = $TileMapGround
@onready var TileMapDecor: TileMapLayer = $TileMapDecor
@onready var CharacterSelectionAnimation: AnimatedSprite2D = $MovementUI/CharacterSelection
@onready var TargetSelectionAnimation: AnimatedSprite2D = $TargetChoiceUI/TargetSelection

@onready var enemyTurnManager: EnemyTurnManager = $EnemyTurnManager
@onready var characterManager: CharacterManager = $CharacterManager

var characterChosen : Globals.CharacterClass = Globals.CharacterClass.NONE;
var clicked : bool = false

var caseContent : Array[Array]=[]


func _init() -> void:
	Globals.state_finished.connect(_on_state_finished)
	create_initial_map()
	await SceneTransition.open_circle()
	
	
func _ready()-> void :
	create_initial_map_from_scene()

func _process(_delta):
	if(TargetSelectionAnimation.visible):
		var characterTileCoordinates = get_map_position_from_mouse()
		TargetSelectionAnimation.position = TileMapGround.map_to_local(characterTileCoordinates) + TileMapGround.get_parent().position
		if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT )==true):
			if(!clicked):
				var positionmouse: Vector2i = get_map_position_from_mouse()
				get_type_case_from_position(positionmouse.x, positionmouse.y)
				getPostionAbsoluteFromCoordinates(positionmouse.x, positionmouse.y)
				print("absolute , ", positionmouse)
				clicked = true
				if(characterManager.can_choose_tile(positionmouse)):
					characterManager.set_current_tile(positionmouse)
					Globals.state_finished.emit(Globals.StateTurn.CHOICE_TARGET_CHARACTER)
		else :
			clicked = false
	pass


func _on_player_choose_character(character: Globals.CharacterClass):
	print("Choose player %d " % character)
	characterChosen = character
	characterManager.set_current_character(characterChosen)
	show_player_move_ui(characterManager.get_current_character_node())
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_CHARACTER)
	
func show_player_move_ui(player_node: Node2D):
	var characterTileCoordinates = TileMapGround.local_to_map(player_node.position)
	CharacterSelectionAnimation.position = TileMapGround.map_to_local(characterTileCoordinates) + TileMapGround.get_parent().position
	CharacterSelectionAnimation.visible = true
	CharacterSelectionAnimation.play("default")
	
	var neighbooringCoordinates: Array[Vector2] = [
		Vector2(characterTileCoordinates.x + 1, characterTileCoordinates.y), #Right
		Vector2(characterTileCoordinates.x - 1, characterTileCoordinates.y), #Left
		Vector2(characterTileCoordinates.x, characterTileCoordinates.y + 1), #Down
		Vector2(characterTileCoordinates.x, characterTileCoordinates.y - 1), #Up
	]
	
	var neighbooringNodes: Array[Node2D] = [
		$MovementUI/TileSelectionSpriteRight,
		$MovementUI/TileSelectionSpriteLeft,
		$MovementUI/TileSelectionSpriteDown,
		$MovementUI/TileSelectionSpriteUp,
	]
	
	for neighboorIndex in range(4):
		var nodeToShow = neighbooringNodes[neighboorIndex]
		if can_player_move_to_coordinates(neighbooringCoordinates[neighboorIndex]):
			nodeToShow.position = TileMapGround.map_to_local(neighbooringCoordinates[neighboorIndex]) + TileMapGround.get_parent().position
			nodeToShow.visible = true

func can_player_move_to_coordinates(coordinates: Vector2):
	if(coordinates.x < 0 or coordinates.y < 0):
		return false
	if(coordinates.x >= Globals.NUMBER_CELL_X or coordinates.y >= Globals.NUMBER_CELL_Y):
		return false
		
	var tileType: Globals.TypeCase = get_type_case_from_position(int(coordinates.x), int(coordinates.y))
	if(tileType != Globals.TypeCase.EMPTY and tileType != Globals.TypeCase.ENEMIES):
		# EXTREMELY INCORRECT !!! We're waiting for get_type_case_from_position to be fixed
		return true
	
	return true


func hide_player_move_ui():
	CharacterSelectionAnimation.visible = false
	
	var neighbooringNodes: Array[Node2D] = [
		$MovementUI/TileSelectionSpriteRight,
		$MovementUI/TileSelectionSpriteLeft,
		$MovementUI/TileSelectionSpriteDown,
		$MovementUI/TileSelectionSpriteUp,
	]
	
	for node in neighbooringNodes:
		node.visible = false

func show_target_choice_ui():
	TargetSelectionAnimation.visible = true
	
func hide_target_choice_ui():
	TargetSelectionAnimation.visible = false


func _on_player_choose_action(action: Globals.CharacterAction):
	print("Choose action %d " % action)
	characterManager.set_current_action(action)
	Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)

	
func _on_state_finished(state: Globals.StateTurn):
	assert(state == Globals.curr_state)
	
	match state:
		Globals.StateTurn.CHOICE_CHARACTER :
			Globals.curr_state=Globals.StateTurn.CHOICE_ACTION
		Globals.StateTurn.CHOICE_ACTION :
			hide_player_move_ui()
			if(characterManager.action_needs_target()):
				show_target_choice_ui()
				Globals.curr_state = Globals.StateTurn.CHOICE_TARGET_CHARACTER
			else:
				characterManager.set_current_tile(Vector2i(-1, -1))
				Globals.curr_state = Globals.StateTurn.ACTION_CHARACTER
				
		Globals.StateTurn.CHOICE_TARGET_CHARACTER :
			hide_target_choice_ui()
			Globals.curr_state = Globals.StateTurn.ACTION_CHARACTER

		Globals.StateTurn.ACTION_CHARACTER :
			Globals.curr_state = Globals.StateTurn.ACTION_ENEMIES
		Globals.StateTurn.ACTION_ENEMIES :
			Globals.curr_state = Globals.StateTurn.CHOICE_CHARACTER 
	
	var signal_to_send = Globals.curr_state
	Globals.state_started.emit(signal_to_send)


func get_map_position_from_mouse() -> Vector2i:
	return TileMapGround.local_to_map(get_global_mouse_position() - TileMapGround.get_parent().position)

func create_initial_map_from_scene():
	var initial_pos:Vector2
	var line :Array 
	for i in range(Globals.NUMBER_CELL_Y):
		initial_pos.y=i
		for j in range(Globals.NUMBER_CELL_X):
			initial_pos.x=j
			#var nodeDecor = get_node("TileMapDecor") # : TileMapLayer
			
			var IdTile = TileMapDecor.get_cell_atlas_coords(initial_pos)
			
			if (IdTile==Vector2i(0,3)):
				line.append(Globals.TypeCase.TRAP_REPULSE)
			elif (IdTile==Vector2i(0,1)) :
				line.append(Globals.TypeCase.TIME_PLUS)
			elif (IdTile==Vector2i(0,2)) :
				line.append(Globals.TypeCase.MIDDLE)
			elif (IdTile==Vector2i(0,0)) :
				line.append(Globals.TypeCase.TIME_MINUS)
			elif (IdTile==Vector2i(4,3)) :
				line.append(Globals.TypeCase.BUSH)
			elif (IdTile==Vector2i(4,4)) :
				line.append(Globals.TypeCase.TREE)
			elif (IdTile==Vector2i(4,2)) :
				line.append(Globals.TypeCase.MUD)
			else :
				line.append(Globals.TypeCase.EMPTY)
				
		caseContent.append(line)
		line=[]
	print(caseContent)

	
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
		line=[]
		
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
			#if(newType==Globals.TypeCase.ENEMIES):
				#print("update case", columnIndex, "...  ", lineIndex   )
				#print(caseContent)
			lineContent[columnIndex] = newType
			#real update
			
	return success 


func _on_level_timer_end():
	match Globals.curr_state:
		Globals.StateTurn.ACTION_CHARACTER:
			return
		Globals.StateTurn.ACTION_ENEMIES:
			return

	characterManager.set_current_character(characterChosen)
	characterManager.set_current_action(Globals.CharacterAction.DEFAULT)
	Globals.curr_state = Globals.StateTurn.ACTION_CHARACTER
	Globals.state_started.emit(Globals.StateTurn.ACTION_CHARACTER)
	hide_player_move_ui()
	hide_target_choice_ui()
	
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
				#print("ignore Env ",point)
				astar_grid.set_point_solid(point, true)
			if(line[j]==Globals.TypeCase.ICE):
				astar_grid.set_point_solid(point, true)
				#print("ignoreICe",point)
			if(!withEnemies && (line[j]==Globals.TypeCase.ENEMIES ) && point!=positionInit ):
				astar_grid.set_point_solid(point, true)
				#print("ignoreenemies ",point)
		line=[]
	
	#Path finding for all case after the line 
	var path:Array
	point.x=Globals.COLUMN_MAX_ENEMIES
	for i in range(Globals.NUMBER_CELL_Y):
		point.y=i
		path = astar_grid.get_id_path(positionInit, point)
		#print("Point",point,"positionInit", positionInit , "Path", path)
		#Keep the best 
		if(path.size() > 1 && path.size()<sizePath):
			sizePath=path.size()
			nextPosition=path[1]
			
			
	#default if there are no path 
	if(sizePath==50):
		sizePath=0
	return  [nextPosition,sizePath ]



func _on_right_movement_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('clicked right!')
		characterManager.set_current_action(Globals.CharacterAction.MOVE_RIGHT)
		Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)

func _on_left_movement_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('clicked left!')
		characterManager.set_current_action(Globals.CharacterAction.MOVE_LEFT)
		Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)

func _on_down_movement_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('clicked down!')
		characterManager.set_current_action(Globals.CharacterAction.MOVE_DOWN)
		Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)
		
func _on_top_movement_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		print('clicked up!')
		characterManager.set_current_action(Globals.CharacterAction.MOVE_UP)
		Globals.state_finished.emit(Globals.StateTurn.CHOICE_ACTION)
