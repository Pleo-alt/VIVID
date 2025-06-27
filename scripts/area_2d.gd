extends Area2D

@onready var animation_player: AnimationPlayer = $"../../CanvasLayer/ColorRect/AnimationPlayer"
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	# 🔄 Play the idle animation on load
	animated_sprite.play("exit_anim")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("✅ Player entered exit area.")

		body.set_physics_process(false)
		if body.has_method("set_process_input"):
			body.set_process_input(false)

		animation_player.play("fade_in")
		await animation_player.animation_finished

		get_tree().change_scene_to_file("res://scenes/normal_ending.tscn")
