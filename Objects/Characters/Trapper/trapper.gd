class_name Trapper
extends Character

func act(action: Globals.CharacterAction):
	if(action == Globals.CharacterAction.MOVE_LEFT or 
	   action == Globals.CharacterAction.MOVE_RIGHT or
	   action == Globals.CharacterAction.MOVE_UP or
	   action == Globals.CharacterAction.MOVE_DOWN):
		super(action)
		return

	match action:
		Globals.CharacterAction.ACTION1:
			Globals.timerDuration += 0
		Globals.CharacterAction.ACTION2:
			Globals.timerDuration -= 2
		Globals.CharacterAction.ACTION3:
			Globals.timerDuration -= 5
		Globals.CharacterAction.ACTION4:
			Globals.timerDuration -= 30
