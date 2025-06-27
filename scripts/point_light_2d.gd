extends PointLight2D

@export var target: Node2D  # Drag your main_character here in the Inspector

func _process(delta: float) -> void:
	if target:
		global_position = target.global_position
