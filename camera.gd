extends Camera2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var positionDelta = Vector2(0,0) 
	positionDelta = position - player.position
	positionDelta.y += 85
	
	var boundingDistance = Vector2(150, 75)	
	
	if positionDelta.x < -boundingDistance.x:
		position.x -= positionDelta.x + boundingDistance.x
	if positionDelta.x > boundingDistance.x:
		position.x -= positionDelta.x - boundingDistance.x

	if positionDelta.y < -boundingDistance.y:
		position.y -= positionDelta.y + boundingDistance.y
	if positionDelta.y > boundingDistance.y:
		position.y -= positionDelta.y - boundingDistance.y
