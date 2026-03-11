extends Area2D

#variables
var doorHUD
var InRange = false
var door
var textbg
var key
var player
var failed
var openDoor

#saves all needed nodes in a variable
func _ready() -> void:
	doorHUD = get_node("../../../Camera/UnlockDoorHUD")
	door = get_parent()
	textbg = get_node("../../../Camera/Textbg")
	key = get_node("../../../Key")
	player = get_node("../../../Player")
	failed = get_node("../../../Camera/UnlockFailedHUD")
	openDoor = get_node("../../DoorOpen")
	


func _process(_delta: float) -> void:
	
	# changes the needed uis visibility when trying to open the door
	if InRange: 
		
		if Input.is_action_just_pressed("ui_pickup") and key.name in player.inventory:
			doorHUD.visible = false
			textbg.visible = false
			door.visible = false
			openDoor.visible = true
		elif Input.is_action_just_pressed("ui_pickup") and key.name not in player.inventory:
			doorHUD.visible = false
			failed.visible = true

	if not door.visible:
		door.collision_enabled = false


# changes the uis visibility based on whether the player has entered or left the collision of the door
func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_node("PlayerSprite") and door.visible:
		InRange = true
		doorHUD.visible = true
		textbg.visible = true

func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_node("PlayerSprite") and door.visible:
		InRange = false
		doorHUD.visible = false
		textbg.visible = false
		failed.visible = false
		
