extends Area2D

var pickupHUD
var player
var inRange = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickupHUD =  get_node("../Camera/PickupHUD")
	player = get_node("../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var item = self.name
	if self.visible and self.name in player.inventory and player.inventory[item] == 1:
		self.visible = false
		
	if inRange:
		if Input.is_action_just_pressed("ui_pickup"):
			if item == "TimeCrystal":
				get_tree().change_scene_to_file('res://win.tscn')
			else:
				player.inventory[item] = 1
				pickupHUD.visible = false
				self.visible = false

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite") and self.visible:
		pickupHUD.visible = true
		inRange = true

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		pickupHUD.visible = false
		inRange = false
