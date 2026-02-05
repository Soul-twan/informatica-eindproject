extends CharacterBody2D

const max_speed = 400.0
const acc = 30
const fric = 60
const jump_power = -600.0

var hearts : Array[TextureRect]
var health = 5

const fullHeart = preload("res://hud_heartFull.png")
const emptyHeart = preload("res://hud_heartEmpty.png")

var inventory = {
}

func _ready() -> void:
	var heartsBox = $"../Camera/HealthHUD/HBoxContainer"
	for child in heartsBox.get_children():
		hearts.append(child)

	loadSave()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	# Handle jump.
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = jump_power

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input:
		velocity.x = move_toward(velocity.x, input * max_speed, acc)
	else:
		velocity.x = move_toward(velocity.x, 0, fric)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().type() == StaticBody2D:	
			print("I just collided with ", collision.get_collider().name())

func damage():
	if health > 0:
		health -= 1
		update_heart()
		
func update_heart():
	hearts[health].texture = emptyHeart


func loadSave():
	if FileAccess.file_exists("user://save.txt"):
		var saveFile = FileAccess.open("user://save.txt", FileAccess.READ)
		var jsonString = saveFile.get_line()
		var json = JSON.new()
		json.parse(jsonString)
		inventory = json.data
		
		for thing in inventory:
			inventory[thing] = int(inventory[thing])
