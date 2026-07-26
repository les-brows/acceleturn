class_name EnemyTurnManager
extends Node2D

func _ready() -> void:
	Globals.state_started.connect(_on_state_started)
	init_enemies_positions()


func _on_state_started(state: Globals.StateTurn):
	if(state == Globals.StateTurn.ACTION_ENEMIES):
		process_enemy_turn()
		Globals.state_finished.emit(Globals.StateTurn.ACTION_ENEMIES)
		
func init_enemies_positions():
	for enemy in get_children():
		if enemy is Enemy:
			enemy.init_entity(get_parent())

func process_enemy_turn():
	for enemy in get_children():
		if enemy is Enemy:
			enemy.act()

func getEntityAtPos(tile : Vector2i) -> Entity:
	for child in get_children():
		if child is Entity:
			if(child.caseCoords == tile):
				return	child
	return null
