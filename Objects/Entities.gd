class_name Entities
extends Node2D

var caseCoords: Vector2i = Vector2(0,0)
var _level: Level = null

func init_entity(level: Level):
	_level = level	
	caseCoords = _level.getCoordinatesFromPostionAbsolute(position)
	update_visual()

func update_visual():
	position = _level.getPostionAbsoluteFromCoordinates(caseCoords.x, caseCoords.y)

func move(move_direction: Vector2i):
	caseCoords += move_direction
	update_visual()
