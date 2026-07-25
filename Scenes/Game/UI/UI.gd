extends CanvasLayer

@onready var characterSelectionMenu = $CharacterSelection
@onready var actionSelectionMenu = $ActionSelection
@onready var timeBar = $%TimeBar
@onready var fireAnimation = $%FireAnimation

var timerStarted: bool = false
var timerEndTime: int = 0

var tweenCharacter: Tween
var tweenAction: Tween
var tweenTimeBarColor: Tween
var tweenTimeBarSize: Tween
var tweenFirePosition: Tween


func _process(_delta) -> void:
	timeBar.rotation_degrees = 180
	timeBar.position += timeBar.size
	fireAnimation.position.y -= 90 #fireAnimation.size.y doesnt work because blehhhhhhhhhhhhhhhhh
	set_process(false)
		

signal _on_choose_character(character: Globals.CharacterClass)
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


func reset_timer():
	timeBar.color = Color8(41, 198, 0)
	timeBar.scale = Vector2(1, 1)
	tweenTimeBarColor.stop()
	tweenTimeBarSize.stop()
	tweenFirePosition.stop()
	timerStarted = false


func start_timer(timeToFinish: int):
	if tweenTimeBarColor && tweenTimeBarSize && tweenFirePosition:
		tweenTimeBarColor.play()
		tweenTimeBarSize.play()
		tweenFirePosition.play()
	else:
		tweenTimeBarColor = get_tree().create_tween()
		tweenTimeBarSize = get_tree().create_tween()
		tweenFirePosition = get_tree().create_tween()
		
	# We want to keep the X size but set Y to 0
	var targetPosition: Vector2 = Vector2(0, fireAnimation.size.y + fireAnimation.position.y)
	
	tweenTimeBarColor.tween_property(timeBar, "color", Color8(178, 0, 43), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenTimeBarSize.tween_property(timeBar, "scale", Vector2(1, 0), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenFirePosition.tween_property(fireAnimation, "position", targetPosition, timeToFinish).set_trans(Tween.TRANS_LINEAR)
	timerStarted = true


func stop_timer():
	tweenTimeBarColor.pause()
	tweenTimeBarSize.pause()
	tweenFirePosition.pause()


func _on_character_1_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.GUNNER)
	switch_to_action_menu()
	start_timer(10)


func _on_character_2_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.MAGE)
	switch_to_action_menu()
	reset_timer()


func _on_character_3_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.TRAPPER)
	switch_to_action_menu()


func _on_action_1_button_pressed() -> void:
	_on_choose_action.emit(1)
	switch_to_character_menu()
	stop_timer()


func _on_action_2_button_pressed() -> void:
	_on_choose_action.emit(2)
	switch_to_character_menu()


func _on_action_3_button_pressed() -> void:
	_on_choose_action.emit(3)
	switch_to_character_menu()


func _on_action_4_button_pressed() -> void:
	_on_choose_action.emit(4)
	switch_to_character_menu()
