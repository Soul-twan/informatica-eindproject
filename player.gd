extends CharacterBody2D

const max_speed = 400.0
const acc = 30
const fric = 70
const jump_power = -600.0
const dashSpeed = 800.0
var doubleJump = true

var hearts : Array[TextureRect]
var health = 5
var invincibility = false

const fullHeart = preload("res://HUD/heartFull.png")
const emptyHeart = preload("res://HUD/heartEmpty.png")

var inventory = {
}

@onready var invincTimer = $InvincibilityTimer

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
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_power
		
	if Input.is_action_just_pressed("ui_jump") and not is_on_floor() and doubleJump:
		doubleJump = false
		velocity.y = jump_power
		
	if is_on_floor() and not doubleJump:
		doubleJump = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input:
		velocity.x = move_toward(velocity.x, input * max_speed, acc)
	else:
		velocity.x = move_toward(velocity.x, 0, fric)
		
	if Input.is_action_just_pressed("ui_dash") and (input > 0):
		velocity.x += dashSpeed
	elif Input.is_action_just_pressed("ui_dash") and (input < 0):
		velocity.x -= dashSpeed

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("spikes"):
			damage()
	
	
func damage():
	if invincibility:
		return
	else:
		invincibility = true
		invincTimer.start()
		if health > 0:
			health -= 1
			remove_heart()
		
func _on_invincibility_timer_timeout() -> void:
	invincibility = false

func remove_heart():
	hearts[health].texture = emptyHeart
	
func add_heart():
	hearts[health - 1].texture = fullHeart
	
func loadSave():
	if FileAccess.file_exists("user://save.txt"):
		var saveFile = FileAccess.open("user://save.txt", FileAccess.READ)
		var jsonString = saveFile.get_line()
		var json = JSON.new()
		json.parse(jsonString)
		inventory = json.data
		
		for thing in inventory:
			inventory[thing] = int(inventory[thing])


func _on_healing_pad_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		var healingPad = get_node("../HealingPad")
		if body.has_node("PlayerSprite") and healingPad.visible and health != 5:
			health += 1 
			healingPad.visible = false
			add_heart()
