extends Node2D

@export var inputManagerNode  :Node 

enum StateTurn  { CHOICE_PERSO, CHOICE_ACTION, ACTION_PERSO , DEPLACEMENT_ENEMIES}




var state=StateTurn.CHOICE_PERSO
signal input_received
var wait
var persoIndex=0;
var nextAction=Globals.ACTION_PERSO.DEFAULT

func _ready():
	var b =0
#inputManagerNode.move_update.connect(_on_player_move)
# inputManagerNode.click_update.connect(_on_player_click) When the perso click sur un perso

func _process(_delta):
	var Endlevel = false
	while(!Endlevel):
		match state:
			StateTurn.CHOICE_PERSO :
				state=StateTurn.CHOICE_ACTION
				#Choice Perso 
				InputWait()
			StateTurn.CHOICE_ACTION :
				state=StateTurn.ACTION_PERSO
				#set ACTION 
				InputWait()
				
			StateTurn.ACTION_PERSO :
				state=StateTurn.DEPLACEMENT_ENEMIES
				#emit ? 
				#player.ExecuteAction(nextAction) # Add Action  
				
			StateTurn.DEPLACEMENT_ENEMIES :
				state=StateTurn.CHOICE_PERSO 
				# Enemies turn TOOD 
	# TODO test end of level 

func InputWait():
	await input_received	

func _on_player_time_out():
	input_received.emit()
	
	
#func _on_player_move_left():
	#nextAction=ACTION_PERSO.MOVE_LEFT
	##TODO Appel UI 
	#input_received.emit()
#func _on_player_choose_perso( perso: int  ):
	#persoIndex=perso
	#input_received.emit()
#func _on_player_choose_perso_2( ):
	#persoIndex=1
	#input_received.emit()	
#func _on_player_choose_perso_3( ):
	#persoIndex=1
	#input_received.emit()	
func _on_player_choose_action(action : Globals.ACTION_PERSO ):
	nextAction = action
	input_received.emit()	
#func _on_player_choose_action2( ):
	#nextAction=Globals.ACTION_PERSO.MOVE_LEFT
	#input_received.emit()	
#func _on_player_choose_action3( ):
	#nextAction=Globals.ACTION_PERSO.MOVE_LEFT
	#input_received.emit()	
#func _on_player_choose_action4( ):
	#nextAction=Globals.ACTION_PERSO.MOVE_LEFT
	#input_received.emit()
