extends CharacterBody2D


@export var player_speed: float = 500
@export var run_speed_multiplier: float = 1.5


func _physics_process(delta):
	move(delta)


func move(delta: float):
	var move_direction = Input.get_vector("left", "right", "up", "down")
	move_direction = move_direction.normalized()
	
	var player_running = Input.is_action_pressed("shift")
	var move_speed: float
	if player_running:
		move_speed = player_speed * run_speed_multiplier
	else:
		move_speed = player_speed
	
	var target_velocity = move_direction * move_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 5))
	
	move_and_slide()
