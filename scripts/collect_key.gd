extends Area2D

var player_inside := false
var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = get_parent()  # CollectKey’s parent is AnimatedSprite2D
	play_idle_animation()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":
		player_inside = true
		set_process_input(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "main_character":
		player_inside = false
		set_process_input(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_inside:
		print("You got the key!")

		# 🔓 Reveal and activate SpecialExit (hidden by default)
		var special_exit = get_node("/root/World/SpecialExit")


		if special_exit:
			special_exit.visible = true
			for child in special_exit.get_children():
				if child is CollisionShape2D:
					child.disabled = false
		else:
			print("⚠️ Could not find SpecialExit!")

		# 🧹 Remove the full key structure (StaticBody2D)
		var root = get_parent().get_parent()
		if root:
			root.queue_free()
		else:
			print("⚠️ Could not find key root to free.")

func play_idle_animation() -> void:
	if sprite:
		sprite.play("key_anim")
