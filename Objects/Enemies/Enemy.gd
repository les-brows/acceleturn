class_name Enemy
extends Entity

var isGhost=false
var turn =0 

func act():
	#print("case Initial caseCoords",caseCoords )
	if(isFreezedLeft==0):
		#epousse_act(): tout les 3 tours
		if(turn%3==0):
			repousse_act()
		turn+=1
		
		for i in range(varSpeed()):
			var result = _level.path_find(caseCoords,  true,  is_ghost()) 
			# if new position have enemies try other path ?
			if(result[1]!=0):
				
				move(result[0]-caseCoords)
			else :
				print("no path")

	
	else : 	
		#If freeze 
		isFreezedLeft-=1
		if(isFreezedLeft==0):
			#rmove freeze 
			_level.update_case(caseCoords.x, caseCoords.y, get_case_entity() )
			spriteIced.hide()
			sprite.show()
		
func get_case_entity() ->Globals.TypeCase:
	return Globals.TypeCase.ENEMIES

func repousse_act():
	pass
func obectif_game_over()->bool:
	return false

func varSpeed()-> int :
	return 1
