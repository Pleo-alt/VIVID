extends CharacterBody2D

@export var speed := 40
@export var retreat_position: Vector2 = Vector2.ZERO

var player_chase := false
var player: Node2D = null
var wondering := false
var retreating := false
var last_facing := "front"
var hit_count := 0
var player_inside_attack_area := false
var player_died := false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wonder_player: AnimationPlayer = $WonderMode
@onready var wonder_timer: Timer = $WonderTimer
@onready var wonder_delay_timer: Timer = $WonderDelayTimer

func _ready() -> void:
	$PlayerAttack.body_entered.connect(_on_player_attack_body_entered)
	$PlayerAttack.body_exited.connect(_on_player_attack_body_exited)

	if $DamageTimer:
		$DamageTimer.timeout.connect(_on_DamageTimer_timeout)

	if wonder_timer:
		wonder_timer.timeout.connect(_on_WonderTimer_timeout)
	if wonder_delay_timer:
		wonder_delay_timer.timeout.connect(_on_WonderDelayTimer_timeout)
	if wonder_player:
		wonder_player.animation_finished.connect(_on_wonder_mode_animation_finished)

	retreat_position = global_position  # Retreat to spawn


func _physics_process(delta: float) -> void:
	if player_died:
		return

	if player:
		if player.get_meta("is_hidden", false):
			if player_chase and not wondering:
				print("⏳ Player vanished — delaying wonder...")
				player_chase = false
				wondering = true
				retreating = false
				animated_sprite_2d.stop()  # Stop attack animation immediately
				wonder_delay_timer.start()
			return
		elif wondering:
			print("👀 Player popped back up — canceling wonder.")
			wondering = false
			retreating = false
			wonder_timer.stop()
			wonder_delay_timer.stop()
			player_chase = true
		else:
			player_chase = true

	if player_chase:
		var direction := player.global_position - global_position
		position += direction.normalized() * speed * delta
		_play_movement_animation(direction)
	elif retreating:
		var direction := retreat_position - global_position
		if direction.length() > 4:
			position += direction.normalized() * speed * delta
			_play_movement_animation(direction)
		else:
			retreating = false
			animated_sprite_2d.play("%s_idle" % last_facing)
	elif not wondering:
		animated_sprite_2d.play("%s_idle" % last_facing)

func _play_movement_animation(direction: Vector2) -> void:
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

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		print("🧠 Enemy detected presence — tracking engaged.")

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
		print("🚪 Player left detection area — standing down.")

func _on_player_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not player_inside_attack_area and not player_died:
		player_inside_attack_area = true
		$DamageTimer.start()

func _on_player_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside_attack_area = false
		$DamageTimer.stop()

func _on_DamageTimer_timeout() -> void:
	if player_inside_attack_area and player and not player.get_meta("is_hidden", false):
		hit_count += 1
		if hit_count >= 3 and not player_died:
			player_died = true
			print("☠️ Player died.")
			$DamageTimer.stop()
			animated_sprite_2d.stop()
			if player.has_method("play_death"):
				player.play_death()
	else:
		print("🛡️ Attack skipped — player hidden.")

func wonder_left():
	animated_sprite_2d.play("left_idle")

func wonder_right():
	animated_sprite_2d.play("right_idle")

func _on_WonderDelayTimer_timeout() -> void:
	if wondering and wonder_player.has_animation("wonder"):
		print("🕵️ Wonder animation starts.")
		wonder_player.play("wonder")

func _on_wonder_mode_animation_finished(anim_name: StringName) -> void:
	if anim_name == "wonder" and wondering:
		print("⏳ Wonder animation done — holding 2 seconds.")
		wonder_timer.start()

func _on_WonderTimer_timeout() -> void:
	print("💨 Wonder delay over. Retreating...")
	wondering = false
	player = null
	player_chase = false
	retreating = true
