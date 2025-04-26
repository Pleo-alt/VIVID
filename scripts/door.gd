extends Area2D

@onready var sprite = $StaticBody2D/AnimatedSprite2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D


func _ready() -> void:
	set_process_input(false) # the door will remain unactive UNLESS the player interacts with it by pressing E and enters the body area
	sprite.frame = 0 # ready the animation in frame 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character": 
		set_process_input(true)

func _input(event):
	if event.is_action_pressed("Interact"):
		sprite.play("open")
		set_process_input(false)
		await get_tree().create_timer(0.5).timeout
		sprite.stop()
		sprite.frame = 5
		collision_shape.disabled = true  # Disables the collision shape
		

func _on_body_exited(body: Node2D) -> void:
	if body.name == "main_character":
		sprite.stop()  # Stop the animation
		sprite.frame = 0  # Reset to frame 0
		collision_shape.call_deferred("set", "disabled", false)
		collision_shape.visible = true
