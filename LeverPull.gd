extends Area2D


var isPulled = []
var inRange

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inRange and Input.is_action_just_pressed("ui_pickup"):
		if $sprite2D.frame == 0:
			$Sprite2D.frame = 1
			isPulled.append(self.name)
		elif $Sprite2D.frame == 1:
			$Sprite2D.frame = 0
			isPulled.erase(self.name)
		
	if "Lever 1" in isPulled:
		print(isPulled)

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_node("PlayerSprite"):
		inRange = true

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_node("PlayeSprite"):
		inRange = false
