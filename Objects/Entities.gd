class_name Entity
extends Node2D

var caseCoords: Vector2i = Vector2(0,0)
var _level: Level = null
var lastCaseGhost=Globals.TypeCase.EMPTY
var isFreezedLeft :int =0 
@onready var sprite: Sprite2D = $Sprite2D

func init_entity(level: Level):
	_level = level
	
	caseCoords = _level.getCoordinatesFromPostionAbsolute(position)
	_level.update_case(caseCoords.x, caseCoords.y,get_case_entity())
	update_visual()
	print("Init entities ", caseCoords)
	
func update_visual():
	position = _level.getPostionAbsoluteFromCoordinates(caseCoords.x, caseCoords.y)


func move(move_direction: Vector2i): 
	var move_after: bool = true 
	#print("Move Global  : ", move_direction)
	while move_direction.x != 0 && move_after :
		if(move_direction.x >= 0 ):
			move_after = _move(Vector2i(1,0))
		
			move_direction.x -= 1
		else : 
			move_after = _move(Vector2i(-1,0))
			move_direction.x += 1
	while move_direction.y != 0  && move_after :
		if(move_direction.y >= 0 ):
			move_after = _move(Vector2i(0, 1))
		
			move_direction.y -= 1
		else : 
			move_after = _move(Vector2i(0, -1))
			move_direction.y += 1

#move after 
func _move(move_direction: Vector2i)-> bool : 
	#print("Move  : ", move_direction)
	var newCoords = caseCoords+ move_direction
	#print("caseCoords", caseCoords, "newCoords", newCoords)
	
	var move_after=true
	#TODO test merge enemies 
	
	#Outside Map 
	if(newCoords.x >= 0 && newCoords.y >= 0 && newCoords.x < Globals.NUMBER_CELL_X && newCoords.y < Globals.NUMBER_CELL_Y ):
		var case :Globals.TypeCase= _level.get_type_case_from_position(newCoords.x, newCoords.y)
		
		if(case == Globals.TypeCase.MIDDLE):
			print("END !!!! obectif_game_over()", obectif_game_over())
			Globals.level_finished.emit(obectif_game_over())
		# if possible
		if(case != Globals.TypeCase.ICE && case != Globals.TypeCase.CHARACTER ):
			if(is_ghost() || (case != Globals.TypeCase.TREE && case != Globals.TypeCase.BUSH)):
				
				
				
				_level.update_case(caseCoords.x, caseCoords.y,lastCaseGhost )
				
				if(is_ghost()):
					lastCaseGhost=get_case_entity()
					
				_level.update_case(newCoords.x, newCoords.y, get_case_entity() )
				caseCoords = newCoords
				#print("after compute ", caseCoords)
				update_visual()
				
				
				if(!is_ghost() && case == Globals.TypeCase.TRAP_ICE ): 
					#effet d' arrivée 
					#print("ICe trap  ")
					put_ice_on_entity()
				if(!is_ghost() && !is_push() &&  case ==Globals.TypeCase.TRAP_REPULSE):
					#print("TRAP_REPULSE trap  ")
					move(Vector2i(2,0)) #2 case  on the right 
			else :
				#print("Not move block")
				move_after=false
		else :
			
			#print("Not move block")
			move_after=false
	else :
		#print("Limit map ")
		move_after=true
	return move_after

func place_to_pos(tile: Vector2i):
	if(is_ghost()):
		lastCaseGhost=get_case_entity()
	_level.update_case(caseCoords.x, caseCoords.y, lastCaseGhost)
	caseCoords = tile
	update_visual()
	if(is_character()):
		_level.update_case(tile.x, tile.y, Globals.TypeCase.CHARACTER)
	else:
		_level.update_case(tile.x, tile.y, Globals.TypeCase.ENEMIES)
	
func is_ghost():
	return false 
func is_push():
	return true 
	

func put_ice_on_entity():
	isFreezedLeft=4
	#Put Ice on casContent 
	_level.update_case(caseCoords.x, caseCoords.y, Globals.TypeCase.ICE)
	
	#change Icone 
	#Sprite2D.mas
	
	
func is_character() -> bool:
	return false


func obectif_game_over()->bool:
	return false
func get_case_entity() ->Globals.TypeCase:
	print("Default get_case_entity :: ERROR !!!!")
	return  Globals.TypeCase.ENEMIES
