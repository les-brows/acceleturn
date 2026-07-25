extends CanvasLayer

@onready var characterSelectionMenu = $CharacterSelection
@onready var actionSelectionMenu = $ActionSelection

var tweenCharacter: Tween
var tweenAction: Tween

signal _on_choose_character(playerIndex: int)
signal _on_choose_action(action: Globals.CHARACTER_ACTION)


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
	_on_choose_character.emit(1)
	switch_to_action_menu()


func _on_character_2_button_pressed() -> void:
	_on_choose_character.emit(2)
	switch_to_action_menu()


func _on_character_3_button_pressed() -> void:
	_on_choose_character.emit(3)
	switch_to_action_menu()


func _on_action_1_button_pressed() -> void:
	_on_choose_action.emit(1)
	switch_to_character_menu()


func _on_action_2_button_pressed() -> void:
	_on_choose_action.emit(2)
	switch_to_character_menu()


func _on_action_3_button_pressed() -> void:
	_on_choose_action.emit(3)
	switch_to_character_menu()


func _on_action_4_button_pressed() -> void:
	_on_choose_action.emit(4)
	switch_to_character_menu()
