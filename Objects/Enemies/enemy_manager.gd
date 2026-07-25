class_name EnemyTurnManager
extends Node2D

func _ready() -> void:
	Globals.state_started.connect(_on_state_started)

func _on_state_started(state: Globals.StateTurn):
	if(state == Globals.StateTurn.DEPLACEMENT_ENEMIES):
		process_enemy_turn()
		Globals.state_finished.emit(Globals.StateTurn.DEPLACEMENT_ENEMIES)

func process_enemy_turn():
	print("Mes ennemis vont faire des trucs tkt")
	for enemy in get_children():
		if enemy is Enemy:
			enemy.act() 
	return true;
