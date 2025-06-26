extends CharacterBody2D

const SPEED = 40.0
const BOOST_AMOUNT = 20.0  
var current_dir = "none"
var is_sprinting = false
var is_cutscene = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("front_idle")

func _physics_process(delta):
	if is_cutscene:
		velocity = Vector2.ZERO
		move_and_collide(velocity)
		return

	player_movement(delta)


func player_movement(delta):
	var adjusted_speed = SPEED
	if get_tree().current_scene.name == "scene_one":
		# Disable sprinting by ignoring Shift input
		is_sprinting = false
	else:
		
		if Input.is_action_pressed("boost"):  
			is_sprinting = true
			adjusted_speed += BOOST_AMOUNT
		else:
			is_sprinting = false

	
	if Input.is_action_pressed("move_right"):
		current_dir = "right"
		player_anim(1)
		velocity.x = adjusted_speed
		velocity.y = 0

	elif Input.is_action_pressed("move_left"):
		current_dir = "left"
		player_anim(1)
		velocity.x = -adjusted_speed
		velocity.y = 0

	elif Input.is_action_pressed("move_down"):
		current_dir = "down"
		player_anim(1)
		velocity.y = adjusted_speed
		velocity.x = 0

	elif Input.is_action_pressed("move_up"):
		current_dir = "up"
		player_anim(1)
		velocity.y = -adjusted_speed
		velocity.x = 0

	else:
		player_anim(0)
		velocity.x = 0
		velocity.y = 0

	velocity = velocity * delta  # Ensure velocity is scaled by delta
	move_and_collide(velocity)

func player_anim(movement):
	var dir = current_dir

	if dir == "right":
		sprite.flip_h = false
		if is_sprinting and movement == 1:
			sprite.play("side_run")
		elif movement == 1:
			sprite.play("side_walk")
		elif movement == 0:
			sprite.play("side_idle")

	if dir == "left":
		sprite.flip_h = true
		if is_sprinting and movement == 1:
			sprite.play("side_run")
		elif movement == 1:
			sprite.play("side_walk")
		elif movement == 0:
			sprite.play("side_idle")    

	if dir == "down":
		sprite.flip_h = false
		if is_sprinting and movement == 1:
			sprite.play("front_run")
		elif movement == 1:
			sprite.play("front_walk")
		elif movement == 0:
			sprite.play("front_idle")

	if dir == "up":
		sprite.flip_h = false
		if is_sprinting and movement == 1:
			sprite.play("back_run")
		elif movement == 1:
			sprite.play("back_walk")
		elif movement == 0:
			sprite.play("back_idle")
func look_up():
	sprite.play("back_idle")

func look_right():
	sprite.flip_h = false
	sprite.play("side_idle")

func look_left():
	sprite.flip_h = true
	sprite.play("side_idle")

func look_down():
	sprite.play("front_idle")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
func play_death():
	sprite.play("death")
	set_physics_process(false)
