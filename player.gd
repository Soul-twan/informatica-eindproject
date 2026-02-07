extends CharacterBody2D

const max_speed = 400.0
const acc = 30
const fric = 70
const jump_power = -630.0
const dashSpeed = 800.0
const wallJumpHorizontal = 800

var doubleJump = true
var dashReady = true

var hearts : Array[TextureRect]
var health = 5
var invincibility = false

const fullHeart = preload("res://HUD/heartFull.png")
const emptyHeart = preload("res://HUD/heartEmpty.png")

var inventory = {
}

@onready var invincTimer = $InvincibilityTimer
@onready var dashTimer = $DashTimer
@onready var nearWallChecker = $NearWallCheck

func _ready() -> void:
	var heartsBox = $"../Camera/HealthHUD/HBoxContainer"
	for child in heartsBox.get_children():
		hearts.append(child)
		
	loadSave()

func _physics_process(delta: float) -> void:
	var input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_power
		
	if Input.is_action_just_pressed("ui_jump") and not is_on_floor() and doubleJump and not nearWallChecker.is_colliding():
		doubleJump = false
		velocity.y = jump_power
		
	if Input.is_action_just_pressed("ui_jump") and not is_on_floor() and nearWallChecker.is_colliding():
		velocity.y = jump_power
		velocity.x = -wallJumpHorizontal
		
	if is_on_floor() and not doubleJump:
		doubleJump = true
		
	if input:
		velocity.x = move_toward(velocity.x, input * max_speed, acc)
	else:
		velocity.x = move_toward(velocity.x, 0, fric)
		
	if (Input.is_action_just_pressed("ui_dash") or Input.is_action_just_pressed("ui_dash2")) and (input > 0) and dashReady:
		velocity.x += dashSpeed
		dashReady = false
		dashTimer.start()
	elif (Input.is_action_just_pressed("ui_dash") or Input.is_action_just_pressed("ui_dash2")) and (input < 0) and dashReady:
		velocity.x -= dashSpeed
		dashReady = false
		dashTimer.start()

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("spikes"):
			damage()
	
func _on_dash_timer_timeout() -> void:
	dashReady = true

	
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
