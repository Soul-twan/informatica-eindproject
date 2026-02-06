extends Camera2D

var player
var lookDistance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var positionDelta = Vector2(0,0) 
	positionDelta = position - player.position
	positionDelta.y += 85
	
	var boundingDistance = Vector2(120, 75)	
	
	if (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down")):
		if Input.is_action_just_pressed("ui_up"):
			lookDistance = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
			position.y += lookDistance - 320
		if Input.is_action_just_released("ui_up"):
			position.y -= lookDistance - 320

		if Input.is_action_just_pressed("ui_down"):
			lookDistance = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
			position.y += lookDistance + 320
		if Input.is_action_just_released("ui_down"):
			position.y -= lookDistance + 320

	else:
		if positionDelta.y < -boundingDistance.y:
			position.y -= positionDelta.y + boundingDistance.y
		if positionDelta.y > boundingDistance.y:
			position.y -= positionDelta.y - boundingDistance.y

	if positionDelta.x < -boundingDistance.x:
		position.x -= positionDelta.x + boundingDistance.x
	if positionDelta.x > boundingDistance.x:
		position.x -= positionDelta.x - boundingDistance.x
