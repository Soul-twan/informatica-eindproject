extends Node2D

var timer
var timerHUD
var player
var Dash
var WallJump
var DoubleJump

@onready var textBg = $Camera/Textbg
@onready var tutorialBg = $Camera/TutorialBg
@onready var tutorialHUDBottom = $Camera/TutorialHUDBottom
@onready var tutorialHUDTop = $Camera/TutorialHUDTop

const tutorialText = [
	"Press \"e\"  to continue through text boxes",
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("Timer")
	timerHUD = get_node("Camera/TimerHUD")
	player = get_node("Player")
	var healthHUD = get_node("Camera/HealthHUD")
	healthHUD.visible = true
	var HUDbg = get_node("Camera/HUDbg")
	HUDbg.visible = true
	
	if Dash in player.inventory:
		timer.wait_time = 30.0

	if "TutorialCompletion" in player.inventory:
		timer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.health == 0:
		loopReset()

	var displayTime = timer.wait_time
	if !timer.is_stopped():
		displayTime = int(timer.get_time_left())
		
	var secondsDisplay = int(displayTime) % 60
	if secondsDisplay < 10:
		secondsDisplay = "0" + str(secondsDisplay)
	var remainingTime = str(floor(int(displayTime / 60))) + ":" + str(secondsDisplay)
	timerHUD.set_text(str(remainingTime))
	
	if Input.is_action_just_pressed("ui_reset"):
		player.inventory.clear()
		loopReset()
		
	tutorial()

func _on_timer_timeout() -> void:
	loopReset()

func save():
	var saveFile = FileAccess.open("user://save.txt", FileAccess.WRITE)
	var jsonString = JSON.stringify(player.inventory)
		
	saveFile.store_line(jsonString)
	saveFile.close()

func loopReset():
	save()
	get_tree().reload_current_scene()
	
func tutorial():
	if !"TutorialPart" in player.inventory:
		player.inventory["TutorialPart"] = 0
	
	if Input.is_action_just_pressed("ui_pickup"):
		if player.inventory["TutorialPart"] < 7:
			player.inventory["TutorialPart"] += 1
		
	if !"TutorialCompletion" in player.inventory:
		match player.inventory["TutorialPart"]:
			0:
				textBg.visible = true
				tutorialHUDBottom.visible = true
				tutorialHUDBottom.text = tutorialText[0]
			1:
				textBg.visible = false
				tutorialBg.visible = true
				tutorialHUDTop.visible = true
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
				tutorialBg.visible = false
				tutorialHUDTop.visible = false
				tutorialHUDBottom.visible = false
				player.inventory["TutorialCompletion"] = 1
				loopReset()
