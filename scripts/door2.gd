extends Area2D

@onready var sprite = $StaticBody2D/AnimatedSprite2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D

var dialogue_active = false

func _ready() -> void:
	set_process_input(false)
	sprite.frame = 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character": 
		set_process_input(true)

func _input(event) -> void:
	if event.is_action_pressed("Interact") and not dialogue_active:
		dialogue_active = true
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
		await get_tree().create_timer(1.0).timeout  # Small delay before resetting interaction
		dialogue_active = false
