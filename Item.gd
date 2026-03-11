extends Area2D

#variables
var pickupHUD
var textBg
var player
var inRange = false
var item
var timer
var pickupTimer
var PickedUp
var CollectedHUD

# saves all needed nodes in a variable
func _ready() -> void:
	pickupHUD =  get_node("../Camera/PickupHUD")
	textBg = get_node("../Camera/Textbg")
	player = get_node("../Player")
	timer = get_node("../Timer")
	pickupTimer = get_node("../PickUpTimer")
	CollectedHUD = get_node("../Camera/CollectedHUD")


func _process(_delta: float) -> void:
	item = self.name
	
	# changes the value of the variable 'PickedUp' based on the item that is being picked up
	if item == "DoubleJump":
		PickedUp = "Double Jump"
	elif item == "Dash":
		PickedUp = "Dash"
	elif item == "WallJump":
		PickedUp = "Wall Jump"
	elif item == "Key":
		PickedUp = "Key"

	# first checks which item is being collected
	# then changes the right uis visibilities based on whether the item was already in the inventory
	# adds the item to the player's inventory
	
	# if the item is the final time crystal, the scene changes to the win scene
	if inRange and self.visible:
		if Input.is_action_just_pressed("ui_pickup"):
			if item == "TimeCrystal":
				get_tree().change_scene_to_file('res://win.tscn')
			else:
				if (item == "WallJump" or item == "DoubleJump" or item == "Dash" or item == "Key") and not item in player.inventory:
					CollectedHUD.text = PickedUp + " has been added to your inventory!"
					CollectedHUD.visible = true
					pickupTimer.start()
				elif (item == "WallJump" or item == "DoubleJump" or item == "Dash" or item == "Key") and item in player.inventory:
					CollectedHUD.text = PickedUp + " was already collected."
					CollectedHUD.visible = true
					pickupTimer.start()
				else: 
					textBg.visible = false
				player.inventory[item] = 1
				pickupHUD.visible = false
				self.visible = false

# next functions change the uis based on whether the player has entered or left the item's collision shape
func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_node("PlayerSprite") and self.visible:
		pickupHUD.visible = true
		textBg.visible = true
		inRange = true

func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		pickupHUD.visible = false
		if self.visible: 		
			textBg.visible = false
		inRange = false

# changes the visibility of the uis after the pickup timer has expired
# happens so the ui doesn't stay on the screen forever		
func _on_pick_up_timer_timeout() -> void:
	textBg.visible = false
	CollectedHUD.visible = false
