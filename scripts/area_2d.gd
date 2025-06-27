extends Area2D

@onready var animation_player: AnimationPlayer = $"../../CanvasLayer/ColorRect/AnimationPlayer"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("✅ Player entered exit area.")
		
		body.set_physics_process(false)  # Disable movement or logic processing
		if body.has_method("set_process_input"):
			body.set_process_input(false)  # Optionally disable input directly too

		animation_player.play("fade_in")
		await animation_player.animation_finished

		get_tree().change_scene_to_file("res://scenes/house_inside.tscn")
