extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer

func _ready() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/normal_ending.dialogue"))
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	animation_player.play("fade_in")
