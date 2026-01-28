extends Node2D

var speed = 200
var acceleration  = 1.06
var moving = false

func _ready() -> void:
	position = Vector2(600,520)
	

func _process(delta: float) -> void:
	if moving == true:
		if speed <= 400:
			speed = speed * acceleration
		if speed >= 400:
			speed = 400
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"): # A or left arrow\
		moving = true
		position += Vector2(-speed,0) * delta
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"): # D or right arrow
		moving = true
		position += Vector2(speed,0) * delta
	if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"): # S or arrow down
		moving = true
		position += Vector2(0, speed) * delta
	if Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"): # W or arrow up
		moving = true
		position += Vector2(0, -speed) * delta
		
	if Input.is_action_just_pressed("ui_select"): # spacebar
		position += Vector2(0,-100)
