extends CanvasLayer

@onready var characterSelectionMenu = $CharacterSelection
@onready var actionSelectionMenu = $ActionSelection

signal _on_choose_player(playerIndex: int)
signal _on_choose_action(action: Globals.ACTION_PERSO )

var tweenCharacter: Tween
var tweenAction: Tween


func switch_to_character_menu():
	tweenCharacter = get_tree().create_tween()
	tweenAction = get_tree().create_tween()
	
	# Move the menu from 2000 to 300 (See comment below)
	characterSelectionMenu.position = Vector2(0, 300)
	tweenCharacter.tween_property(characterSelectionMenu, "position", Vector2(0, 0), 1.5).set_trans(Tween.TRANS_BACK)
	tweenAction.tween_property(actionSelectionMenu, "position", Vector2(0, 300), 1.5).set_trans(Tween.TRANS_BACK)
	
	# If the two Selection Menus overlap, the click doesn't propagate through
	# We keep the tween at 300 for aesthetics, but then move it to 2000 to prevent overlap
	await tweenAction.finished
	actionSelectionMenu.position = Vector2(0, 2000)


func switch_to_action_menu():
	tweenCharacter = get_tree().create_tween()
	tweenAction = get_tree().create_tween()
	
	# Move the menu from 2000 to 300 (See comment below)
	actionSelectionMenu.position = Vector2(0, 300)
	tweenCharacter.tween_property(characterSelectionMenu, "position", Vector2(0, 300), 1.5).set_trans(Tween.TRANS_BACK)
	tweenAction.tween_property(actionSelectionMenu, "position", Vector2(0, 0), 1.5).set_trans(Tween.TRANS_BACK)
	
	# If the two Selection Menus overlap, the click doesn't propagate through
	# We keep the tween at 300 for aesthetics, but then move it to 2000 to prevent overlap
	await tweenCharacter.finished
	characterSelectionMenu.position = Vector2(0, 2000)


func _on_character_1_button_pressed() -> void:
	switch_to_action_menu()
	_on_choose_player.emit(1)
	
func _on_character_2_button_pressed() -> void:
	switch_to_action_menu()
	_on_choose_player.emit(2)
	
func _on_character_3_button_pressed() -> void:
	switch_to_action_menu()
	_on_choose_player.emit(3)
	
func _on_action_1_button_pressed() -> void:
	switch_to_character_menu()
	_on_choose_action.emit( Globals.ACTION_PERSO.ACTION1)
	
func _on_action_2_button_pressed() -> void:
	switch_to_character_menu()
	_on_choose_action.emit( Globals.ACTION_PERSO.ACTION2)

func _on_action_3_button_pressed() -> void:
	switch_to_character_menu()
	_on_choose_action.emit( Globals.ACTION_PERSO.ACTION3)

func _on_action_4_button_pressed() -> void:
	switch_to_character_menu()
	_on_choose_action.emit( Globals.ACTION_PERSO.ACTION4)
