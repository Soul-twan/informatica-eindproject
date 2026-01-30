extends Node2D

var timer
var timerHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("Timer")
	timerHUD = get_node("Camera/TimerHUD")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var remainingTime = str(floor(int(timer.get_time_left()) / 60)) + ":" + str((int(timer.get_time_left()) % 60))
	timerHUD.set_text(str(remainingTime))

func _on_timer_timeout() -> void:
	print("timer")
	get_tree().reload_current_scene()
