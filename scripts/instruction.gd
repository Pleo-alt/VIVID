extends Area2D





func _on_body_entered(body: Node2D) -> void:
	if body.name == "main_character":
		set_process_input(true)

func _input(event) -> void:
	if event.is_action_pressed("Interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/instruction.dialogue"))
