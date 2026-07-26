extends Node

var INITIAL_TIME: int = 30


var GUNNER_ACTION1_TIME_ADDED: int = 0
var GUNNER_ACTION1_PUSH_DISTANCE_CHARACTER: int = 2
var GUNNER_ACTION1_PUSH_DISTANCE_ENNEMY: int = 4

var GUNNER_ACTION2_TIME_ADDED: int = -5
var GUNNER_ACTION2_RANGE: int = 1
var GUNNER_ACTION2_PUSH_DISTANCE: int = 2

var GUNNER_ACTION3_TIME_ADDED: int = -1
var GUNNER_ACTION4_TIME_ADDED: int = -20


var MAGE_ACTION1_TIME_ADDED: int = 0
var MAGE_ACTION1_RANGE: int = 3

var MAGE_ACTION2_TIME_ADDED: int = 10
var MAGE_ACTION3_TIME_MULT: int = 2

var MAGE_ACTION4_TIME_MULT: float = 4
var MAGE_ACTION4_DURATION: float = 3 + 1


var TRAPPER_ACTION1_TIME_ADDED: int = 0
var TRAPPER_ACTION2_TIME_ADDED: int = -2
var TRAPPER_ACTION3_TIME_ADDED: int = -5

var TRAPPER_ACTION4_TIME_ADDED: int = -30
var TRAPPER_ACTION4_RANGE: int = 1
var TRAPPER_ACTION4_PUSH_DISTANCE: int = 1



var NUMBER_CELL_X = 15
var NUMBER_CELL_Y = 6
var COLUMN_MAX_ENEMIES = 7
var SIZE_CELL_X :int = 64
var SIZE_CELL_Y :int = 64

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
@warning_ignore("unused_signal")
signal movement_hovered(currently_hovering: bool)
@warning_ignore("unused_signal")
signal open_popup(characterName: String, text: String, character: Globals.CharacterClass)
@warning_ignore("unused_signal")
signal level_finished( game_over: bool)

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
	CANCEL
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

enum Operations
{
	ADD,
	SUB,
	MUL,
	DIV
}

var curr_state : Globals.StateTurn = Globals.StateTurn.CHOICE_CHARACTER
var curr_character: Globals.CharacterClass = Globals.CharacterClass.NONE
var curr_action: Globals.CharacterAction = Globals.CharacterAction.DEFAULT
var timerDuration: float = INITIAL_TIME
var timeFreezeTurns = 0
