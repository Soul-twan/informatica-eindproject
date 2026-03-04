extends Node2D

var timer
var timerHUD
var player
var Dash
var WallJump
var DoubleJump

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
	
	if "TutorialCompletion" in player.inventory:
		timer.start()

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
	player.inventory["TutorialCompletion"] = 1
	if !"TutorialPart" in player.inventory:
		player.inventory["TutorialPart"] = 1
	match player.inventory["TutorialPart"]:
		0:
			print("nothing")
