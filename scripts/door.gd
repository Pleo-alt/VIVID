extends Area2D

@onready var sprite = $StaticBody2D/AnimatedSprite2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D
@onready var animator = $"../CanvasLayer/ColorRect/AnimationPlayer"
@onready var fade_rect = $"../CanvasLayer/ColorRect"

var door_opened := false

func _ready() -> void:
	set_process_input(false)
	sprite.frame = 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(true)

func _input(event) -> void:
	if event.is_action_pressed("Interact") and not door_opened:
		sprite.play("open")
		collision_shape.disabled = true  # Let the player walk through
		door_opened = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "main_character" and door_opened:
		set_process_input(false)
		animator.play("fade_out")
		get_tree().change_scene_to_file("res://scenes/outside_scene.tscn")
