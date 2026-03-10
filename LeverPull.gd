extends Sprite2D

var inRange
var openDoor
var closeDoor
var lever1
var lever2
var lever3
var textBg
var LeverHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	openDoor = get_node("../../PuzzleDoor/DoorOpen")
	closeDoor = get_node("../../PuzzleDoor/DoorClosed")
	lever1 = get_node("../../Lever1/LeverS1")
	lever2 = get_node("../../Lever2/LeverS2")
	lever3 = get_node("../../Lever3/LeverS3")
	textBg = get_node("../../Camera/Textbg")
	LeverHUD = get_node("../../Camera/LeverHUD")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if inRange and Input.is_action_just_pressed("ui_pickup") and self.frame == 0:
		self.frame = 1
	elif inRange and Input.is_action_just_pressed("ui_pickup") and self.frame == 1:
		self.frame = 0
		
	if lever1.frame == 1 and lever2.frame == 1 and lever3.frame == 0:
		openDoor.visible = true
		closeDoor.visible = false
	else: 
		openDoor.visible = false
		closeDoor.visible = true

func _on_lever_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true
		textBg.visible = true
		LeverHUD.visible = true

func _on_lever_1_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false
		textBg.visible = false
		LeverHUD.visible = false
		
func _on_lever_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true
		textBg.visible = true
		LeverHUD.visible = true
		
func _on_lever_2_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false
		textBg.visible = false
		LeverHUD.visible = false
		
func _on_lever_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true
		textBg.visible = true
		LeverHUD.visible = true
		
func _on_lever_3_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = false
		textBg.visible = false
		LeverHUD.visible = false
