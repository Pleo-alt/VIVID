extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $main_character/AnimatedSprite2D
@onready var dad_sprite: AnimatedSprite2D = $Dad/AnimatedSprite2D  # 👈 Reference to Dad's sprite

func _ready() -> void:
	animated_sprite.play("side_idle")     # Eli idle animation
	dad_sprite.play("dad_idle")          # Dad idle animation

	animation_player.play("fade_out")
	await animation_player.animation_finished

	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/special_ending.dialogue"))
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	animation_player.play("fade_in")
