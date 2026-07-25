extends Node

enum StateTurn
{
	CHOICE_CHARACTER,
	CHOICE_ACTION,
	CHOICE_TARGET_CHARACTER,
	ACTION_CHARACTER,
	ACTION_ENEMIES
}

@warning_ignore("unused_signal")
signal state_finished(state: StateTurn)
@warning_ignore("unused_signal")
signal state_started(state: StateTurn)


enum CHARACTER_ACTION
{ 
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
	ACTION1,
	ACTION2,
	ACTION3,
	ACTION4,
	DEFAULT
}

enum CharacterClass
{
	NONE,
	GUNNER,
	MAGE,
	TRAPPER,
}

var NUMBER_CELL_X = 14
var NUMBER_CELL_Y = 6
var SIZE_CELL_X :int = 64
var SIZE_CELL_Y :int = 64
