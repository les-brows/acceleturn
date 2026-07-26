class_name Enemy
extends Entity

var isGhost=false
var turn =0 

func act():
	#print("case Initial caseCoords",caseCoords )
	#epousse_act(): tout les 3 tours
	if(turn%3==0):
		repousse_act()
	turn+=1
	var result = _level.path_find(caseCoords,  true,  is_ghost()) 
	#print("After ",result )
	#TODO if new position have enemies try other path ?
	if(result[1]!=0):
		move(result[0]-caseCoords)
	else :
		print("no path")
func get_case_entity() ->Globals.TypeCase:
	return Globals.TypeCase.ENEMIES

func repousse_act():
	pass
func obectif_game_over()->bool:
	return false
