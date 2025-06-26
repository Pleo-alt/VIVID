extends CharacterBody2D

@export var speed := 40
var player_chase := false
var player: Node2D = null
var last_facing := "front"
var hit_count := 0
var player_inside_attack_area := false
var player_died := false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$PlayerAttack.body_entered.connect(_on_player_attack_body_entered)
	$PlayerAttack.body_exited.connect(_on_player_attack_body_exited)
	if $DamageTimer:
		$DamageTimer.timeout.connect(_on_DamageTimer_timeout)
		print("✅ DamageTimer connected and ready.")
	else:
		print("❌ DamageTimer NOT found")
	

func _physics_process(delta: float) -> void:
	if player_died:
		return  # Stop all action once the player has died

	if player_chase and player:
		var direction := player.global_position - global_position
		position += direction.normalized() * speed * delta

		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite_2d.play("attack_right")
				last_facing = "right"
			else:
				animated_sprite_2d.play("attack_left")
				last_facing = "left"
		else:
			if direction.y > 0:
				animated_sprite_2d.play("attack_front")
				last_facing = "front"
			else:
				animated_sprite_2d.play("attack_back")
				last_facing = "back"
	else:
		animated_sprite_2d.play("%s_idle" % last_facing)

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false

func _on_player_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not player_inside_attack_area and not player_died:
		player_inside_attack_area = true
		$DamageTimer.start()

func _on_player_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside_attack_area = false
		$DamageTimer.stop()

func _on_DamageTimer_timeout() -> void:
	if player_inside_attack_area:
		hit_count += 1
		if hit_count >= 3 and not player_died:
			player_died = true
			print("player died")
			$DamageTimer.stop()
			animated_sprite_2d.stop()
			if player and player.has_method("play_death"):
				player.play_death()
			else:
					print("⚠ Couldn't trigger death animation: method missing on player")
