extends Area2D

var pickupHUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickupHUD =  get_node("../Camera/PickupHUD")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		pickupHUD.visible = true

#		get_tree().change_scene_to_file('res://win.tscn')

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		pickupHUD.visible = false
