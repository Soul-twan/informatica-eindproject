extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		position += Vector2(-400,0) * delta
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		position += Vector2(400,0) * delta
	if Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		position += Vector2(0, 400) * delta
	if Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		position += Vector2(0, -400) * delta
