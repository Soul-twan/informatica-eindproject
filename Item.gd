extends Area2D

var pickupHUD
var textBg
var player
var inRange = false
var item
var timer
var pickupTimer
var PickedUp
var CollectedHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickupHUD =  get_node("../Camera/PickupHUD")
	textBg = get_node("../Camera/Textbg")
	player = get_node("../Player")
	timer = get_node("../Timer")
	pickupTimer = get_node("../PickUpTimer")
	CollectedHUD = get_node("../Camera/CollectedHUD")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	item = self.name
	
	if item == "DoubleJump":
		PickedUp = "Double Jump"
	elif item == "Dash":
		PickedUp = "Dash"
	elif item == "WallJump":
		PickedUp = "Wall Jump"

	if inRange and self.visible:
		if Input.is_action_just_pressed("ui_pickup"):
			if item == "TimeCrystal":
				get_tree().change_scene_to_file('res://win.tscn')
			else:
				if (item == "WallJump" or item == "DoubleJump" or item == "Dash") and not item in player.inventory:
					CollectedHUD.text = PickedUp + " has been added to your inventory!"
					CollectedHUD.visible = true
					pickupTimer.start()
				elif (item == "WallJump" or item == "DoubleJump" or item == "Dash") and item in player.inventory:
					CollectedHUD.text = PickedUp + " was already collected."
					CollectedHUD.visible = true
					pickupTimer.start()
				else: 
					textBg.visible = false
				player.inventory[item] = 1
				pickupHUD.visible = false
				self.visible = false


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
		
func _on_pick_up_timer_timeout() -> void:
	textBg.visible = false
	CollectedHUD.visible = false
