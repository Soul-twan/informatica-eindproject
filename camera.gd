extends Camera2D

var player
var lookDistance
var doubleUpgrade
var singleUpgrade
var dash
var doubleJump
var hasLooked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")
	doubleUpgrade = get_node("HUDbg/HUDbgDoubleUpgrade")
	singleUpgrade = get_node("HUDbg/HUDbgSingleUpgrade")
	dash = get_node("HUDbg/DashHUD")
	doubleJump = get_node("HUDbg/DoubleJumpHUD")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var positionDelta = Vector2(0,0) 
	positionDelta = position - player.position
	positionDelta.y += 85
	
	var boundingDistance = Vector2(120, 75)	
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		if Input.is_action_just_pressed("ui_up"):
			lookDistance = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
			position.y += lookDistance - 320
			hasLooked = true
		if Input.is_action_just_released("ui_up") and hasLooked:
			position.y -= lookDistance - 320
			hasLooked = false

		if Input.is_action_just_pressed("ui_down"):
			lookDistance = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
			position.y += lookDistance + 320
			hasLooked = true
		if Input.is_action_just_released("ui_down") and hasLooked:
			position.y -= lookDistance + 320
			hasLooked = false

	else:
		if positionDelta.y < -boundingDistance.y:
			position.y -= positionDelta.y + boundingDistance.y
		if positionDelta.y > boundingDistance.y:
			position.y -= positionDelta.y - boundingDistance.y

	if positionDelta.x < -boundingDistance.x:
		position.x -= positionDelta.x + boundingDistance.x
	if positionDelta.x > boundingDistance.x:
		position.x -= positionDelta.x - boundingDistance.x

	if "DoubleJump" in player.inventory:
		singleUpgrade.visible = false
		doubleUpgrade.visible = true
		doubleJump.visible = true
		dash.visible = true		

	elif "Dash" in player.inventory:
		singleUpgrade.visible = true
		dash.visible = true

	if player.doubleJump == true:
		doubleJump.frame = 0
	else:
		doubleJump.frame = 1
		
	if player.dashReady == true:
		dash.frame = 0
	else:
		dash.frame = 1
