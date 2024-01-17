extends State
class_name EnemyIdle

@export var move_speed: float = 10.0

var enemy: CharacterBody2D
var player: Player
var move_direction: Vector2
var wander_time: float


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)


func enter():
	enemy = get_parent().get_enemy()
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()
	get_parent().get_label().text = "Idle"


func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()
		
	var player_direction = player.global_position - enemy.global_position
	if player_direction.length() < 250:
		transitioned.emit(self, "enemyfollow")


func physics_update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
