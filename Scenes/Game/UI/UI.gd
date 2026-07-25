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
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/ActionBg1/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/ActionBg2/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/ActionBg3/ActionButton,
	$ActionSelection/VBox/BottomBackground/MarginContainer/ActionSelectionButtons/ActionBg4/ActionButton
]

@onready var allyDialogText = $%DialogueText
@onready var allyDialogName = $%CharacterName
@onready var allyDialogImage = $%DialogueImage

var trasitionDuration: float = 0.2

var initialFirePos: int = 0
var timerStarted: bool = false
var timerEndTime: int = 0

var tweenCharacter: Tween
var tweenAction: Tween
var tweenTimeBarColor: Tween
var tweenTimeBarSize: Tween
var tweenFirePosition: Tween
var tweenAllyDialog: Tween

signal _on_choose_character(character: Globals.CharacterClass)
signal _on_choose_action(action: Globals.CharacterAction)


func _ready() -> void:
	Globals.state_started.connect(_on_state_started_received)
	Globals.state_finished.connect(_on_state_finished_received)


func _process(_delta) -> void:
	timeBar.rotation_degrees = 180
	timeBar.position += timeBar.size
	fireAnimation.position.y -= 90 #fireAnimation.size.y doesnt work because blehhhhhhhhhhhhhhhhh
	initialFirePos = fireAnimation.position.y
	set_process(false)


# ------------ State Machine functions -------------------


func _on_state_started_received(state: Globals.StateTurn) -> void:
	match state:
		Globals.StateTurn.CHOICE_CHARACTER:
			if tweenCharacter && tweenCharacter.is_running():
				await tweenCharacter.finished

			reset_timer()
			start_timer(Globals.timerDuration)
			hide_action_menu()
			show_character_menu()

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
	# Move the menu from 2000 to 300
	actionSelectionMenu.position = Vector2(0, 300)
	
	tweenAction = get_tree().create_tween()
	tweenAction.tween_property(actionSelectionMenu, "position", Vector2(0, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)
	
	await tweenAction.finished
	for button in ActionButtons:
		button.disabled = false


# ------------ Timer functions -------------------


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
	fireAnimation.position.y = initialFirePos
	var targetPosition: Vector2 = Vector2(0, fireAnimation.size.y + fireAnimation.position.y)
	
	tweenTimeBarColor.tween_property(timeBar, "color", Color8(178, 0, 43), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenTimeBarSize.tween_property(timeBar, "scale", Vector2(1, 0), timeToFinish).set_trans(Tween.TRANS_LINEAR)
	tweenFirePosition.tween_property(fireAnimation, "position", targetPosition, timeToFinish).set_trans(Tween.TRANS_LINEAR)
	timerStarted = true


func stop_timer():
	tweenTimeBarColor.pause()
	tweenTimeBarSize.pause()
	tweenFirePosition.pause()


# ------------ Dialogue functions -------------------


func show_ally_dialog(name: String, text: String, character: Globals.CharacterClass):
	allyDialogName = name
	allyDialogText = text
	
	match character:
		Globals.CharacterClass.GUNNER:
			allyDialogImage = "res://Assets/UI/artworks-byEI1Ks9SQr13Gn3-zZIJGw-t1080x1080.jpg"
		
		Globals.CharacterClass.MAGE:
			allyDialogImage = "res://Assets/UI/artworks-byEI1Ks9SQr13Gn3-zZIJGw-t1080x1080.jpg"
		
		Globals.CharacterClass.TRAPPER:
			allyDialogImage = "res://Assets/UI/artworks-byEI1Ks9SQr13Gn3-zZIJGw-t1080x1080.jpg"
	
	tweenAllyDialog = get_tree().create_tween()
	tweenAllyDialog.tween_property(dialogAlly, "position", Vector2(0, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)

func hide_ally_dialog():
	tweenAllyDialog = get_tree().create_tween()
	tweenAllyDialog.tween_property(dialogAlly, "position", Vector2(-500, 0), trasitionDuration).set_trans(Tween.TRANS_BACK)


# ------------ Button Callbacks functions -------------------


func _on_character_1_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.GUNNER)


func _on_character_2_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.MAGE)


func _on_character_3_button_pressed() -> void:
	_on_choose_character.emit(Globals.CharacterClass.TRAPPER)


func _on_action_1_button_pressed() -> void:
	_on_choose_action.emit(1)


func _on_action_2_button_pressed() -> void:
	_on_choose_action.emit(2)


func _on_action_3_button_pressed() -> void:
	_on_choose_action.emit(3)


func _on_action_4_button_pressed() -> void:
	_on_choose_action.emit(4)
