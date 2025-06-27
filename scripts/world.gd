extends Node2D

@onready var animator = $CanvasLayer/ColorRect/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $main_character/AnimatedSprite2D
@onready var player = $main_character

func _ready() -> void:
	# Disable player input
	player.is_cutscene = true
	player.set_process(false)
	player.set_physics_process(false)

	animated_sprite_2d.visible = true
	animated_sprite_2d.play("get_up")
	animated_sprite_2d.frame = 0
	animated_sprite_2d.stop()

	animator.play("fade_out")
	await animator.animation_finished

	await get_tree().create_timer(1.0).timeout
	animated_sprite_2d.play("get_up")
	await animated_sprite_2d.animation_finished  

	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/forest.dialogue"))

	# Wait for dialogue to finish
	await DialogueManager.dialogue_ended

	# Re-enable player control
	player.is_cutscene = false
	player.set_process(true)
	player.set_physics_process(true)
