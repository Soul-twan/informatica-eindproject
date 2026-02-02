extends CharacterBody2D

const max_speed = 400.0
const acc = 30
const fric = 70
const jump_power = -600.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_power

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input:
		velocity.x = move_toward(velocity.x, input * max_speed, acc)
	else:
		velocity.x = move_toward(velocity.x, 0, fric)

	move_and_slide()
