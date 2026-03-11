extends Node2D

# Variables
var timer
var timerHUD
var player
var Dash
var WallJump
var DoubleJump
var resetting

# Saves nodes into variables
@onready var textBg = $Camera/Textbg
@onready var tutorialBg = $Camera/TutorialBg
@onready var tutorialHUDBottom = $Camera/TutorialHUDBottom
@onready var tutorialHUDTop = $Camera/TutorialHUDTop
@onready var portrait = $Camera/Portrait
@onready var music = $BackgroundMusic

# Static variable
const tutorialText = [
	"Press \"e\" to continue through text boxes",
	"It seems I got myself stuck in a time loop.",
	"I'll have to find time crystals to",
	"recharge my time watch and get back", 
	"home.",
	"I can move around with the left and",
	"right arrow keys and jump with \"c\".",
	"I can look up and down with the up and",
	"down arrow keys.",
	"I could wall jump, double jump and",
	"dash with \"x\" or \"v\" , but I think I need",
	"to recharge my time watch for that too.",
	""
]

func _ready() -> void:
	# Saves nodes into variables and changes visibility
	timer = get_node("Timer")
	timerHUD = get_node("Camera/TimerHUD")
	player = get_node("Player")
	var healthHUD = get_node("Camera/HealthHUD")
	healthHUD.visible = true
	var HUDbg = get_node("Camera/HUDbg")
	HUDbg.visible = true
	
	# Starts the timer if the player has completed the tutorial
	if "TutorialCompletion" in player.inventory:
		timer.start()
		
func _process(_delta: float) -> void:
	# Resets the level if the player dies
	if player.health == 0:
		loopReset()

	# Displays the time left in the current loop
	var displayTime = timer.wait_time
	if !timer.is_stopped():
		displayTime = int(timer.get_time_left())
		
	var secondsDisplay = int(displayTime) % 60
	if secondsDisplay < 10:
		secondsDisplay = "0" + str(secondsDisplay)
	var remainingTime = str(floor(int(displayTime / 60))) + ":" + str(secondsDisplay)
	timerHUD.set_text(str(remainingTime))
	
	# Resets the game upon pressing backspace
	if Input.is_action_just_pressed("ui_reset"):
		player.inventory.clear()
		loopReset()
		
	tutorial()
	backgroundMusic()

# Resets the level when the timer runs out
func _on_timer_timeout() -> void:
	loopReset()

# Saves the current inevntory to a file
func save():
	var saveFile = FileAccess.open("user://save.txt", FileAccess.WRITE)
	var jsonString = JSON.stringify(player.inventory)
		
	saveFile.store_line(jsonString)
	saveFile.close()

# Resets the level with some necessary precautions
func loopReset():
	resetting = true
	music.stop()
	save()
	get_tree().reload_current_scene()
	
# Plays music based on the items in the inventory
func backgroundMusic():
	if !music.playing and!resetting:
		if !"TutorialCompletion" in player.inventory:
			music.stream = load("res://Music/fullSong.mp3")
		elif "Dash" in player.inventory and "WallJump" in player.inventory and "DoubleJump" in player.inventory:
			music.stream = load("res://Music/120sec.mp3")
		elif "Dash" in player.inventory and "WallJump" in player.inventory:
			music.stream = load("res://Music/110sec.mp3")
		elif "WallJump" in player.inventory:
			music.stream = load("res://Music/80sec.mp3")
		else:
			music.stream = load("res://Music/30sec.mp3")
		music.play()

# Plays a tutorial if it hasn't been completed
# Changes HUD visibility and text when required
func tutorial():
	if !"TutorialPart" in player.inventory:
		player.inventory["TutorialPart"] = 0
	
	if Input.is_action_just_pressed("ui_pickup"):
		if player.inventory["TutorialPart"] < 7:
			player.inventory["TutorialPart"] += 1
		
	if !"TutorialCompletion" in player.inventory:
		match player.inventory["TutorialPart"]:
			0:
				tutorialHUDBottom.horizontal_alignment = 1
				tutorialHUDBottom.size = Vector2(1280, 80)
				tutorialHUDBottom.position = Vector2(-640, 280)
				
				textBg.visible = true
				tutorialHUDBottom.visible = true
				
				tutorialHUDBottom.text = tutorialText[0]
			1:
				portrait.visible = true
				textBg.visible = false
				tutorialBg.visible = true
				tutorialHUDTop.visible = true
				
				tutorialHUDBottom.horizontal_alignment = 0
				tutorialHUDBottom.size = Vector2(1085, 80)
				tutorialHUDBottom.position = Vector2(-445, 280)
				
				tutorialHUDTop.text = tutorialText[1]
				tutorialHUDBottom.text = tutorialText[2]
			2:
				tutorialHUDTop.text = tutorialText[3]
				tutorialHUDBottom.text = tutorialText[4]
			3:
				tutorialHUDTop.text = tutorialText[5]
				tutorialHUDBottom.text = tutorialText[6]
			4:
				tutorialHUDTop.text = tutorialText[7]
				tutorialHUDBottom.text = tutorialText[8]
			5:
				tutorialHUDTop.text = tutorialText[9]
				tutorialHUDBottom.text = tutorialText[10]
			6:
				tutorialHUDTop.text = tutorialText[11]
				tutorialHUDBottom.text = tutorialText[12]
			7:
				portrait.visible = false
				tutorialBg.visible = false
				tutorialHUDTop.visible = false
				tutorialHUDBottom.visible = false
				player.inventory["TutorialCompletion"] = 1
				loopReset()
