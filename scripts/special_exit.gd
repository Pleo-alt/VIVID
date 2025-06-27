extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = get_parent()
@onready var special_exit_root := get_parent().get_parent()  # StaticBody2D
@onready var collision_shapes := special_exit_root.get_children().filter(func(n): return n is CollisionShape2D)
@onready var animation_player: AnimationPlayer = get_node("/root/World/CanvasLayer/ColorRect/AnimationPlayer")

const NEXT_SCENE_PATH := "res://scenes/special_ending.tscn"

func _ready() -> void:
	# Hide SpecialExit and disable its collision shapes
	if special_exit_root:
		special_exit_root.visible = false
		for shape in collision_shapes:
			shape.disabled = true

	# Play idle/open animation on load
	animated_sprite_2d.play("special_door")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":

		if animation_player:
			animation_player.play("fade_in")
			await animation_player.animation_finished
		else:
			print("⚠️ AnimationPlayer not found — skipping fade.")

		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
