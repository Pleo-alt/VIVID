extends Area2D

var player_is_inside := false
var is_showing_dialogue := false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(true)
		player_is_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(false)
		player_is_inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and can_show_instruction() and player_is_inside and not is_showing_dialogue:
		_start_instruction_dialogue()

func _start_instruction_dialogue() -> void:
	is_showing_dialogue = true
	GameState.player_can_interact = false

	# Find the main character node and pause their script directly
	var player = get_tree().get_current_scene().get_node("main_character")



	if player:
		player.set_physics_process(false)

	await DialogueManager.show_example_dialogue_balloon(load("res://dialogue/instruction.dialogue"))
	await get_tree().create_timer(0.05).timeout

	if player:
		player.set_physics_process(true)

	GameState.player_can_interact = true
	is_showing_dialogue = false

func can_show_instruction() -> bool:
	return GameState.player_can_interact and not GameState.is_hidden
