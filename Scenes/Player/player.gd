extends CharacterBody2D


@export var player_speed: int = 500


func _physics_process(delta):
	move(delta)


func move(delta: float):
	var move_direction = Input.get_vector("left", "right", "up", "down")
	move_direction = move_direction.normalized()
	
	var target_velocity = move_direction * player_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 5))
	
	move_and_slide()
