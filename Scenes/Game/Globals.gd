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


enum CharacterAction
{
	DEFAULT,
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
	ACTION1,
	ACTION2,
	ACTION3,
	ACTION4,
}

enum CharacterClass
{
	NONE,
	GUNNER,
	MAGE,
	TRAPPER,
}


enum TypeCase
{
	EMPTY,
	ENEMIES,
	CHARACTER,
	BUSH,
	MIDDLE,
	TREE,
	ICE,
	TRAP_ICE,
	TRAP_REPULSE,
	TIME_PLUS,
	TIME_MINUS,
	MUD
}

var curr_state : Globals.StateTurn = Globals.StateTurn.CHOICE_CHARACTER

var NUMBER_CELL_X = 15
var NUMBER_CELL_Y = 6
var COLUMN_MAX_ENEMIES = 7
var SIZE_CELL_X :int = 64
var SIZE_CELL_Y :int = 64

var timerDuration: int = 10
