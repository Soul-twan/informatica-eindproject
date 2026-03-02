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
		$Timer.wait_time = 30.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.health == 0:
		loopReset()
	
	var secondsDisplay = int(timer.get_time_left()) % 60
	if secondsDisplay < 10:
		secondsDisplay = "0" + str(secondsDisplay)
	var remainingTime = str(floor(int(timer.get_time_left() / 60))) + ":" + str(secondsDisplay)
	timerHUD.set_text(str(remainingTime))
	
	if Input.is_action_just_pressed("ui_reset"):
		player.inventory.clear()
		loopReset()
		
		

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
