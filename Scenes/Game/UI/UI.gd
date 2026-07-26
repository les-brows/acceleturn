extends CanvasLayer

@onready var characterSelectionMenu = $CharacterSelection
@onready var actionSelectionMenu = $ActionSelection
@onready var timeBar = $%TimeBar
@onready var fireAnimation = $%FireAnimation
@onready var dialogAlly = $"Dialogue Ally"

@onready var CharacterButtons = [
	$CharacterSelection/VBox/BottomBackground/MarginContainer/CharacterButtonsContainer/CharacterBg1/CharacterButton,
	$CharacterSelection/VBox/BottomBackground/MarginContainer/CharacterButtonsContainer/CharacterBg2/CharacterButton,
	$CharacterSelection/VBox/BottomBackground/MarginContainer/CharacterButtonsContainer/CharacterBg3/CharacterButton
]

@onready var ActionButtons = [
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/HBoxContainer/ActionBg1/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/HBoxContainer/ActionBg2/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/HBoxContainer/ActionBg3/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/HBoxContainer/ActionBg4/ActionButtonUltimate
]

@onready var ActionButtonLabels = [
	$%ActionLabel1,
	$%ActionLabel2,
	$%ActionLabel3,
	$%ActionLabel4
]

@onready var allyDialogText = $%DialogueText
@onready var allyDialogName = $%CharacterName
@onready var allyDialogImage = $%DialogueImage

@onready var timer = $%Timer
@onready var timerText = $%TimerText

@onready var textModifier = $%ModifierText
@onready var actionPopup = $ActionPopup
@onready var actionPopupLabel = $%PopupLabel

@onready var victoryBackground = $GameOverOverlay/VictoryBackground
@onready var victoryImage: TextureRect = $GameOverOverlay/VictoryBackground/VictoryImage
@onready var victoryLabel = $%VictoryLabel

@onready var forbiddenImage = $%ForbiddenImage
@onready var actionButtonUltimate = $%ActionButtonUltimate

var trasitionDuration: float = 0.2

var initialFirePos: Vector2 = Vector2(0,0)
var timerStarted: bool = false
var timerEndTime: int = 0
var first_process_run: bool = true
var should_popup_follow_mouse: bool = false
var game_ended: bool = false
var muted_popups: bool = false

var tweenCharacter: Tween
var tweenAction: Tween
var tweenTimeBarColor: Tween
var tweenTimeBarSize: Tween
var tweenFirePosition: Tween
var tweenAllyDialog: Tween
var tweenVictoryImageScale: Tween
var tweenVictoryImageRotation: Tween

signal _on_choose_character(character: Globals.CharacterClass)
signal _on_choose_action(action: Globals.CharacterAction)
signal _on_timer_end()


func _ready() -> void:
	Globals.state_started.connect(_on_state_started_received)
	Globals.state_finished.connect(_on_state_finished_received)
	Globals.movement_hovered.connect(_on_hover_movement)
	Globals.open_popup.connect(show_ally_dialog)
	Globals.level_finished.connect(play_end_game)
	display_text_modifier(Globals.Operations.ADD, 5)
	timerText.text = str(Globals.INITIAL_TIME)


func _process(_delta) -> void:
	if first_process_run:
		timeBar.rotation_degrees = 180
		timeBar.position += timeBar.size
		fireAnimation.position.y -= 55 #fireAnimation.size.y doesnt work because blehhhhhhhhhhhhhhhhh
		initialFirePos = fireAnimation.position
		first_process_run = false
		
	if should_popup_follow_mouse and not muted_popups:
		actionPopup.global_position = get_viewport().get_mouse_position() + Vector2(-15, 15) - Vector2(0, actionPopup.size.y)
		
	if timerStarted:
		timerText.clear()
		
		var remaining_time: float = timer.time_left
		var sec: int = int(remaining_time)
		if(sec > 999):
			sec = 999
			
		if(sec > 99):
			timerText.append_text("%03d" % [sec])
		else:
			timerText.append_text("%02d" % [sec])


# ------------ State Machine functions -------------------


func _on_state_started_received(state: Globals.StateTurn) -> void:
	match state:
		Globals.StateTurn.CHOICE_CHARACTER:
			if tweenCharacter && tweenCharacter.is_running():
				await tweenCharacter.finished
			if Globals.curr_action != Globals.CharacterAction.CANCEL:
				reset_timer()
				start_timer(Globals.timerDuration)
			hide_action_menu()
			show_character_menu()
			display_text_modifier(Globals.Operations.ADD, 5)

		Globals.StateTurn.CHOICE_ACTION:
			hide_character_menu()
			show_action_menu()


func _on_state_finished_received(state: Globals.StateTurn) -> void:
	match state:
		Globals.StateTurn.CHOICE_CHARACTER:
			if(!timerStarted):
				start_timer(Globals.timerDuration)
		Globals.StateTurn.CHOICE_ACTION:
			hide_action_menu()


# ------------ Action & Character functions -------------------


func hide_character_menu():
	for button in CharacterButtons:
		button.disabled = true
		
	tweenCharacter = get_tree().create_tween()
	tweenCharacter.tween_property(characterSelectionMenu, "position", Vector2(0, 300), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	# If the two Selection Menus overlap, the click doesn't propagate through
	# We keep the tween at 300 for aesthetics, but then move it to 2000 to prevent overlap
	await tweenCharacter.finished
	characterSelectionMenu.position = Vector2(0, 2000)


func show_character_menu():		
	# Move the menu from 2000 to 300
	characterSelectionMenu.position = Vector2(0, 300)
	
	tweenCharacter = get_tree().create_tween()
	tweenCharacter.tween_property(characterSelectionMenu, "position", Vector2(0, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	await tweenCharacter.finished
	for button in CharacterButtons:
		button.disabled = false


func hide_action_menu():
	for button in ActionButtons:
		button.disabled = true
		
	tweenAction = get_tree().create_tween()
	tweenAction.tween_property(actionSelectionMenu, "position", Vector2(0, 300), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	# If the two Selection Menus overlap, the click doesn't propagate through
	# We keep the tween at 300 for aesthetics, but then move it to 2000 to prevent overlap
	await tweenAction.finished
	actionSelectionMenu.position = Vector2(0, 2000)


func show_action_menu():
	update_action_menu_labels()
	
	# Move the menu from 2000 to 300
	actionSelectionMenu.position = Vector2(0, 300)
	
	tweenAction = get_tree().create_tween()
	tweenAction.tween_property(actionSelectionMenu, "position", Vector2(0, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	await tweenAction.finished
	for button in ActionButtons:
		button.disabled = false

	if((Globals.curr_character == Globals.CharacterClass.GUNNER  and Globals.selected_level < Globals.ULTIMATE_UNLOCK_LEVEL_GUNNER) or
	   (Globals.curr_character == Globals.CharacterClass.MAGE    and Globals.selected_level < Globals.ULTIMATE_UNLOCK_LEVEL_MAGE) or
	   (Globals.curr_character == Globals.CharacterClass.TRAPPER and Globals.selected_level < Globals.ULTIMATE_UNLOCK_LEVEL_TRAPPER)):
		actionButtonUltimate.disabled = true
		forbiddenImage.visible = true
	else:
		actionButtonUltimate.disabled = false
		forbiddenImage.visible = false

func update_action_menu_labels():
	
	match Globals.curr_character:
		Globals.CharacterClass.GUNNER:
			ActionButtonLabels[0].text = "Scattering Shot"
			ActionButtonLabels[1].text = "Nuclear Bomb"
			ActionButtonLabels[2].text = "Teleportation"
			ActionButtonLabels[3].text = "Powerful Scattering Shot"
		Globals.CharacterClass.MAGE:
			ActionButtonLabels[0].text = "Magic Missile"
			ActionButtonLabels[1].text = "Time scramble"
			ActionButtonLabels[2].text = "Backtracking"
			ActionButtonLabels[3].text = "Time Warp"
		Globals.CharacterClass.TRAPPER:
			ActionButtonLabels[0].text = "Freeze, don't move"
			ActionButtonLabels[1].text = "Repulse Trap"
			ActionButtonLabels[2].text = "Tree Conjuring"
			ActionButtonLabels[3].text = "Black Hole"
	return false

# ------------ Timer functions -------------------


func reset_timer():
	timeBar.color = Color8(41, 198, 0)
	timeBar.scale = Vector2(1, 1)
	
	if(tweenTimeBarColor):
		tweenTimeBarColor.kill()
		tweenTimeBarColor = null
	if(tweenTimeBarSize):
		tweenTimeBarSize.kill()
		tweenTimeBarSize = null
	if(tweenFirePosition):
		tweenFirePosition.kill()
		tweenFirePosition = null
		
	timerStarted = false
	timer.stop()


func start_timer(timeToFinish: float):
	if(game_ended):
		return
		
	if(timeToFinish <= 0):
		timeToFinish = 0.25
	timer.wait_time = timeToFinish
	timer.start()
	if tweenTimeBarColor && tweenTimeBarSize && tweenFirePosition:
		tweenTimeBarColor.play()
		tweenTimeBarSize.play()
		tweenFirePosition.play()
	else:
		tweenTimeBarColor = get_tree().create_tween()
		tweenTimeBarSize = get_tree().create_tween()
		tweenFirePosition = get_tree().create_tween()

	# We want to keep the X size but set Y to 0
	fireAnimation.position.y = initialFirePos.y
	var targetPosition: Vector2 = Vector2(initialFirePos.x, fireAnimation.size.y + fireAnimation.position.y - 25)

	tweenTimeBarColor.tween_property(timeBar, "color", Color8(178, 0, 43), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenTimeBarSize.tween_property(timeBar, "scale", Vector2(1, 0), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenFirePosition.tween_property(fireAnimation, "position", targetPosition, timeToFinish).set_trans(Tween.TRANS_LINEAR)
	timerStarted = true


func stop_timer():
	tweenTimeBarColor.pause()
	tweenTimeBarSize.pause()
	tweenFirePosition.pause()

# ------------ Time Modificator functions -------------------

func _on_hover_movement(currently_hovering: bool):
	if currently_hovering:
		display_text_modifier(Globals.Operations.SUB, 3)
	else:
		hide_text_modifier()
		
	
func _on_hover_action(action: Globals.CharacterAction):
	match Globals.curr_character:
		Globals.CharacterClass.GUNNER:
			match action:
				Globals.CharacterAction.ACTION1:
					display_popup("Push an ally or an ennemy in a straight line in front of you two or four case on the right respectively")
					display_text_modifier(Globals.Operations.ADD, 0)
				Globals.CharacterAction.ACTION2:
					display_popup("Throw a bomb that repulse ennemies two tiles away from the point of impact!\n-5sec")
					display_text_modifier(Globals.Operations.SUB, 5)
				Globals.CharacterAction.ACTION3:
					display_popup("Teleport the gunner on any tile vertically, ideal for repositionning!\n-1sec")
					display_text_modifier(Globals.Operations.SUB, 1)
				Globals.CharacterAction.ACTION4:
					display_popup("Send an ennemies back to the rightmost available case! \n-20sec")
					display_text_modifier(Globals.Operations.SUB, 20)
					
		Globals.CharacterClass.MAGE:
			match action:
				Globals.CharacterAction.ACTION1:
					display_popup("Send a fireball that kill any ennemies 4 or less tiles away")
					display_text_modifier(Globals.Operations.ADD, 0)
				Globals.CharacterAction.ACTION2:
					display_popup("Create 1 tiles of bad time near the goal on the ally side \n+10 sec")
					display_text_modifier(Globals.Operations.ADD, 10)
				Globals.CharacterAction.ACTION3:
					display_popup("Move every allies and ennemies one tile on the left\nx2 sec")
					display_text_modifier(Globals.Operations.MUL, 2)
				Globals.CharacterAction.ACTION4:
					display_popup("The next three turn you will play will not apply the max timer modification \n ÷4sec")
					display_text_modifier(Globals.Operations.DIV, 4)
					
		Globals.CharacterClass.TRAPPER:
			match action:
				Globals.CharacterAction.ACTION1:
					display_popup("Create a freeze trap tha will froze an ennemy for 3 turns")
					display_text_modifier(Globals.Operations.ADD, 0)
				Globals.CharacterAction.ACTION2:
					display_popup("Create a trap that will push the ennemy/ally on it two tile on the right\n-2sec")
					display_text_modifier(Globals.Operations.SUB, 2)
				Globals.CharacterAction.ACTION3:
					display_popup("Create a tree tile \n-5sec")
					display_text_modifier(Globals.Operations.SUB, 5)
				Globals.CharacterAction.ACTION4:
					display_popup("Place a blackhole tile that pull every ennemy adjacent to it toward that tile \n-30sec")
					display_text_modifier(Globals.Operations.SUB, 30)

func display_text_modifier(operation: Globals.Operations, value: int):
	# Set color
	textModifier["theme_override_colors/default_color"] = Color8(242,0,15)
	
	if operation == Globals.Operations.ADD or operation == Globals.Operations.MUL:
		textModifier["theme_override_colors/default_color"] = Color8(26,255,15)
		
	if value == 0:
		textModifier["theme_override_colors/default_color"] = Color8(255,255,255)
		
		
	# Set operator
	var operator_text = ""
	match operation:
		Globals.Operations.ADD:
			operator_text = "+"
		Globals.Operations.SUB:
			operator_text = "-"
		Globals.Operations.MUL:
			operator_text = "x"
		Globals.Operations.DIV:
			operator_text = "/"
			
	textModifier.text = operator_text + str(value)


func hide_text_modifier():
	textModifier.text = ""


# ------------ Popup functions -------------------


func display_popup(text: String):
	if(muted_popups):
		return
	
	should_popup_follow_mouse = true
	actionPopup.visible = true
	actionPopupLabel.text = text


func hide_popup():
	should_popup_follow_mouse = false
	actionPopup.visible = false


# ------------ Dialogue functions -------------------


func show_ally_dialog(characterName: String, text: String, character: Globals.CharacterClass):
	allyDialogName.text = characterName
	allyDialogText.text = text
	
	match character:
		Globals.CharacterClass.GUNNER:
			allyDialogImage.texture = load("res://Assets/Sprite/Cowboy base.png")
		
		Globals.CharacterClass.MAGE:
			allyDialogImage.texture = load("res://Assets/Sprite/Mage.png")
		
		Globals.CharacterClass.TRAPPER:
			allyDialogImage.texture = load("res://Assets/Sprite/Traper.png")
	
	tweenAllyDialog = get_tree().create_tween()
	tweenAllyDialog.tween_property(dialogAlly, "position", Vector2(0, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	await sleep(3.0)
	hide_ally_dialog()


func hide_ally_dialog():
	tweenAllyDialog = get_tree().create_tween()
	tweenAllyDialog.tween_property(dialogAlly, "position", Vector2(-500, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)


func sleep(seconds: float)->void:
	await get_tree().create_timer(seconds).timeout


# ------------ Game Over/Victory functions -------------------


func play_end_game(victory: bool):
	if(game_ended):
		return
		
	reset_timer()
	game_ended = true
	victoryBackground.visible = true
	
	if(victory):
		victoryLabel.text = "Victory"
	else:
		victoryLabel.text = "Defeat"
	
	victoryImage.scale = Vector2(0,0)
	victoryImage.rotation_degrees = 0
	
	tweenVictoryImageScale = get_tree().create_tween()
	tweenVictoryImageRotation = get_tree().create_tween()

	tweenVictoryImageScale.tween_property(victoryImage, "scale", Vector2(1,1), 1.5).set_trans(Tween.TRANS_CUBIC)
	tweenVictoryImageRotation.tween_property(victoryImage, "rotation_degrees", 1800, 1.5).set_trans(Tween.TRANS_CUBIC)
	
	await sleep(3)
	
	await SceneTransition.close_circle()
	
	var levelSelector_scene = load("res://Scenes/MainMenu/LevelSelector.tscn")
	var levelSelector = levelSelector_scene.instantiate()
	get_parent().get_parent().add_child(levelSelector)
	
	get_parent().queue_free()
	await SceneTransition.open_circle()


# ------------ Button Callbacks functions -------------------


func _on_character_1_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.GUNNER)


func _on_character_2_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.MAGE)


func _on_character_3_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.TRAPPER)


func _on_action_1_button_pressed() -> void:
	hide_popup()
	_on_choose_action.emit(Globals.CharacterAction.ACTION1)


func _on_action_2_button_pressed() -> void:
	hide_popup()
	_on_choose_action.emit(Globals.CharacterAction.ACTION2)


func _on_action_3_button_pressed() -> void:
	hide_popup()
	_on_choose_action.emit(Globals.CharacterAction.ACTION3)


func _on_action_4_button_pressed() -> void:
	hide_popup()
	_on_choose_action.emit(Globals.CharacterAction.ACTION4)


func _on_local_timer_end() -> void:
	_on_timer_end.emit()


func _on_cancel_action_pressed() -> void:
	_on_choose_action.emit(Globals.CharacterAction.CANCEL)


func _on_action_1_button_mouse_entered() -> void:
	_on_hover_action(Globals.CharacterAction.ACTION1)


func _on_action_2_button_mouse_entered() -> void:
	_on_hover_action(Globals.CharacterAction.ACTION2)


func _on_action_3_button_mouse_entered() -> void:
	_on_hover_action(Globals.CharacterAction.ACTION3)


func _on_action_4_button_mouse_entered() -> void:
	_on_hover_action(Globals.CharacterAction.ACTION4)


func _on_action_1_button_mouse_exited() -> void:
	display_text_modifier(Globals.Operations.ADD, 5)
	hide_popup()


func _on_action_2_button_mouse_exited() -> void:
	display_text_modifier(Globals.Operations.ADD, 5)
	hide_popup()


func _on_action_3_button_mouse_exited() -> void:
	display_text_modifier(Globals.Operations.ADD, 5)
	hide_popup()


func _on_action_4_button_mouse_exited() -> void:
	display_text_modifier(Globals.Operations.ADD, 5)
	hide_popup()


func _on_skip_turn_pressed() -> void:
	_on_timer_end.emit()


func _on_mute_popups_toggled(toggled_on: bool) -> void:
	muted_popups = toggled_on
