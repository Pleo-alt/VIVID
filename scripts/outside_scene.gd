extends Node2D

@onready var fade_rect = $CanvasLayer/ColorRect
@onready var animator = $CanvasLayer/ColorRect/AnimationPlayer
@onready var camera = $Camera2D  # Ensure this Camera2D node exists and is active
@onready var flash_animator = $FlashRect/FlashAnimator  # Plays the "screen_flash" animation

var dialogue_ended := false
var current_dialogue := ""  # Track which dialogue is active

func _ready() -> void:
	camera.make_current()
	$main_character.is_cutscene = true

	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))

	animator.play("fade_out")
	await animator.animation_finished
	
	await get_tree().create_timer(2.0).timeout
	await shake_camera(2.5, 6.0)
	$main_character/CutscenePlayer.play("look_around")
	await $main_character/CutscenePlayer.animation_finished

	current_dialogue = "intro"
	play_intro_dialogue()
	await _wait_for_dialogue_end()

	current_dialogue = "after_flash"

	flash_animator.play("screen_flash")
	await flash_animator.animation_finished

	play_after_flash_dialogue()
	await _wait_for_dialogue_end()

	await _handle_final_fade()

func _on_dialogue_ended(resource: DialogueResource) -> void:
	dialogue_ended = true

func _handle_final_fade() -> void:
	animator.play("fade_in")
	await animator.animation_finished
	$main_character.is_cutscene = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func play_intro_dialogue() -> void:
	dialogue_ended = false
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"))

func play_after_flash_dialogue() -> void:
	dialogue_ended = false
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/after_flash.dialogue"))

func _wait_for_dialogue_end() -> void:
	while not dialogue_ended:
		await get_tree().process_frame

func shake_camera(duration := 0.4, intensity := 6.0) -> void:
	var original_offset = camera.offset
	var time_elapsed := 0.0

	while time_elapsed < duration:
		var shake = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		camera.offset = original_offset + shake
		await get_tree().create_timer(0.02).timeout
		time_elapsed += 0.02

	camera.offset = original_offset
