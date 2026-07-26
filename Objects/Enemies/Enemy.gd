class_name Enemy
extends Entity

var isGhost=false

func act():
	#print("case Initial caseCoords",caseCoords )
	
	var result = _level.path_find(caseCoords,  false,  false) 
	#print("After ",result )
	# TODO update position with trap 
	if(result[1]!=0):
		move(result[0]-caseCoords)
	else :
		print("no path")
func get_case_entity() ->Globals.TypeCase:
	return Globals.TypeCase.ENEMIES
