extends Sprite2D

var isPulled = []
var inRange
var openDoor
var closeDoor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	openDoor = get_node("../../PuzzleDoor/DoorOpen")
	closeDoor = get_node("../../PuzzleDoor/DoorClosed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if inRange and Input.is_action_just_pressed("ui_pickup") and self.frame == 0:
		self.frame = 1
		isPulled.append(self.name)
	elif inRange and Input.is_action_just_pressed("ui_pickup") and self.frame == 1:
		self.frame = 0
		isPulled.erase(self.name)
		
	if "LeverS1" in isPulled and "LeverS2" in isPulled and not "LeverS3" in isPulled:
		openDoor.visible = true
		closeDoor.visible = false
	else:
		openDoor.visible = false
		closeDoor.visible = true

func _on_lever_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true

func _on_lever_1_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false

func _on_lever_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true
		
func _on_lever_2_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false
		
func _on_lever_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true
		
func _on_lever_3_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false
