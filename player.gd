extends CharacterBody2D

const max_speed = 400.0
const acc = 30
const fric = 70
const jump_power = -600.0

var inventory = {
}

func _ready() -> void:
	loadSave()

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

func loadSave():
	if FileAccess.file_exists("user://save.txt"):
		var saveFile = FileAccess.open("user://save.txt", FileAccess.READ)
		var jsonString = saveFile.get_line()
		var json = JSON.new()
		json.parse(jsonString)
		inventory = json.data
		
		for thing in inventory:
			inventory[thing] = int(inventory[thing])
