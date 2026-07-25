extends Node

enum StateTurn
{
	CHOICE_CHARACTER,
	CHOICE_ACTION,
	ACTION_CHARACTER,
	DEPLACEMENT_ENEMIES
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
	TRAPPER,
	GUNNER,
	MAGE
}
