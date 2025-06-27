extends Area2D

var has_shown_instruction := false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and can_show_instruction():
		DialogueManager.show.example_dialogue_balloon(load("res://dialogue/instruction.dialogue"))
		has_shown_instruction = true
		set_process_input(false)

func can_show_instruction() -> bool:
	return not has_shown_instruction and GameState.player_can_interact and not GameState.is_hidden
