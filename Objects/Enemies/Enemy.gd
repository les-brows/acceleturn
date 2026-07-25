class_name Enemy
extends Entities


func act():
	#print("case Initial caseCoords",caseCoords )
	
	var result = _level.path_find(caseCoords,  false,  false) 
	#print("After ",result )
	# TODO update position with trap 
	if(result[1]!=0):
		move(result[0]-caseCoords)
