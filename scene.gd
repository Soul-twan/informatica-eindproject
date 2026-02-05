extends Node2D

var timer
var timerHUD
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("Timer")
	timerHUD = get_node("Camera/TimerHUD")
	player = get_node("Player")
	var healthHUD = get_node("Camera/HealthHUD")
	healthHUD.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var remainingTime = str(floor(int(timer.get_time_left()) / 60)) + ":" + str((int(timer.get_time_left()) % 60))
	timerHUD.set_text(str(remainingTime))
	
	if Input.is_action_just_pressed("ui_text_backspace"):
		print("insert test change scene")

func _on_timer_timeout() -> void:
	save()
	get_tree().reload_current_scene()

func save():
	var saveFile = FileAccess.open("user://save.txt", FileAccess.WRITE)
	var jsonString = JSON.stringify(player.inventory)
		
	saveFile.store_line(jsonString)
	saveFile.close()
