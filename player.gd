extends CharacterBody2D

const max_speed = 400.0
const acc = 35
const fric = 80
const jump_power = -630.0
const dashSpeed = 800.0

var wallSlide
var wallJumpHorizontal
var doubleJump = true
var dashReady = true

var hearts : Array[TextureRect]
var health = 5
var invincibility = false
var input

var latestDirection = "right"
var floorJumped = false

const fullHeart = preload("res://HUD/heartFull.png")
const emptyHeart = preload("res://HUD/heartEmpty.png")

var inventory = {
}


@onready var invincTimer = $InvincibilityTimer
@onready var dashTimer = $DashTimer
@onready var nearWallChecker = $NearWallCheck
@onready var animate = $AnimationPlayer
@onready var dashEffects = $AnimationPlayer/DashEffects
@onready var jumpEffects = $AnimationPlayer/JumpEffects

func _ready() -> void:
	var heartsBox = $"../Camera/HealthHUD/HBoxContainer"
	var timer = $"../Timer"
	for child in heartsBox.get_children():
		hearts.append(child)
		
	loadSave()
	
	if "Dash" in inventory and "WallJump" in inventory and "DoubleJump" in inventory:
		timer.wait_time = 120
	elif "Dash" in inventory and "WallJump" in inventory:
		timer.wait_time = 70
	elif "WallJump" in inventory:
		timer.wait_time = 40
	else:
		timer.wait_time = 20

func _physics_process(delta: float) -> void:
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0 and not is_on_floor() and nearWallChecker.is_colliding() and velocity.y > 0:
		wallSlide = true
	else: 
		wallSlide = false
	
	if not is_on_floor() and not wallSlide: 
		velocity += get_gravity() * 1.85 * delta
	elif not is_on_floor() and wallSlide:
		velocity += get_gravity() * 1.2 * delta
		
	floorJumped = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_power
		floorJumped = true

	if Input.is_action_just_pressed("ui_jump") and not is_on_floor() and nearWallChecker.is_colliding() and input != 0 and "WallJump" in inventory:
		velocity.y = jump_power
		velocity.x = wallJumpHorizontal
	elif Input.is_action_just_pressed("ui_jump") and not is_on_floor() and doubleJump and "DoubleJump" in inventory:
		doubleJump = false
		velocity.y = jump_power
		floorJumped = true
		jumpEffects.play("DoubleJump")
		
		
	if latestDirection == "right":
		nearWallChecker.rotation = -90
		wallJumpHorizontal = -780
	elif latestDirection == "left":
		nearWallChecker.rotation = 90
		wallJumpHorizontal = 780
		
	if is_on_floor() and not doubleJump:
		doubleJump = true
		
	if input:
		velocity.x = move_toward(velocity.x, input * max_speed, acc)
		if input > 0:
			latestDirection = "right"
		elif input < 0:
			latestDirection = "left"
	else:
		velocity.x = move_toward(velocity.x, 0, fric)
		
	if (Input.is_action_just_pressed("ui_dash") or Input.is_action_just_pressed("ui_dash2")) and (input > 0) and dashReady and "Dash" in inventory:
		velocity.x += dashSpeed
		dashReady = false
		dashTimer.start()
		dashEffects.play("DashRight")
	elif (Input.is_action_just_pressed("ui_dash") or Input.is_action_just_pressed("ui_dash2")) and (input < 0) and dashReady and "Dash" in inventory:
		velocity.x -= dashSpeed
		dashReady = false
		dashTimer.start()
		dashEffects.play("DashLeft")
		
	animation()

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


func _on_healing_pad_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
		var healingPad = get_node("../HealingPad")
		if body.has_node("PlayerSprite") and healingPad.visible and health != 5:
			health += 1 
			healingPad.visible = false
			add_heart()
			
func animation() -> void:
	var jumpAnimation
	# idle
	if is_on_floor() and velocity == Vector2(0, 0) and input == 0:
		match latestDirection:
			"right":
				animate.play("IdleRight")
			"left":
				animate.play("IdleLeft")
				
	# walk
	if is_on_floor() and velocity != Vector2(0, 0):
		match latestDirection:
			"right":
				animate.play("WalkRight")
			"left":
				animate.play("WalkLeft")
	
	# jump
	if floorJumped:
		if input == 0:
			jumpAnimation = true
			match latestDirection:
				"right":
					animate.play("JumpMiddleRight")
				"left":
					animate.play("JumpMiddleLeft")
		else:
			match latestDirection:
				"right":
					animate.play("JumpRight")
				"left":
					animate.play("JumpLeft")

	# fall
	if !is_on_floor() and velocity.y > 0:
		match latestDirection:
			"right":
				animate.play("FallingRight")
			"left":
				animate.play("FallingLeft")

	# float
	if !is_on_floor() and velocity.y < 0 and !jumpAnimation and animate.current_animation != "JumpRight" and animate.current_animation != "JumpLeft" and animate.current_animation != "JumpMiddleLeft" and animate.current_animation != "JumpMiddleRight":
		match latestDirection:
			"right":
				animate.play("FloatingRight")
			"left":
				animate.play("FloatingLeft")
	
	# wall cling
	if input != 0 and nearWallChecker.is_colliding() and !is_on_floor():
		match latestDirection:
			"right":
				animate.play("WallRight")
			"left":
				animate.play("WallLeft")
