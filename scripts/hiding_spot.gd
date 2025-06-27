extends Area2D

var player_inside := false
var player_ref: Node2D = null
var is_hidden := false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("Interact") and player_ref:
		if not is_hidden:
			player_ref.hide()
			player_ref.set_meta("is_hidden", true)
			player_ref.set_meta("can_move", false)  # Disable movement
			is_hidden = true
		else:
			player_ref.show()
			player_ref.set_meta("is_hidden", false)
			player_ref.set_meta("can_move", true)  # Reactivate movement
			is_hidden = false

			# 🔁 Notify overlapping enemies to resume chase, if any
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if enemy.has_node("PlayerDetection"):
					var detector := enemy.get_node("PlayerDetection")
					if detector.overlaps_body(player_ref):
						enemy._on_player_detection_body_entered(player_ref)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		player_ref = body
		if player_ref.get_meta("is_hidden", false) and not is_hidden:
			player_ref.set_meta("is_hidden", false)
			player_ref.set_meta("can_move", true)
			player_ref.show()

func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		if is_hidden:
			player_ref.show()
			player_ref.set_meta("is_hidden", false)
			player_ref.set_meta("can_move", true)
		player_inside = false
		player_ref = null
		is_hidden = false
