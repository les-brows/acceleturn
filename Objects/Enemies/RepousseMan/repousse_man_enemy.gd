extends Enemy

func repousse_act():
	
	var  column :int=caseCoords.x
	var case= Globals.TypeCase.EMPTY
	while (column>=0 && case!=Globals.TypeCase.TREE and 
		 case!=Globals.TypeCase.ENEMIES and case!=Globals.TypeCase.CHARACTER && case!=Globals.TypeCase.ICE):
		
		column -=1
		case=_level.get_type_case_from_position(column, caseCoords.y )
		
		
	if(case==Globals.TypeCase.CHARACTER):
		print("Repoosse Char ",Vector2i(column,caseCoords.y ))
		var entity: Entity =_level.get_entity_at_pos(Vector2i(column,caseCoords.y ))
		var pushDistance: int =  Globals.GUNNER_ACTION1_PUSH_DISTANCE_CHARACTER
		entity.move(Vector2i(-1 * pushDistance, 0))
