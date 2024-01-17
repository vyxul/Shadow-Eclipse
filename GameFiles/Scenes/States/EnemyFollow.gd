extends State
class_name EnemyFollow

@export var move_speed: float = 50

var player: Player
var enemy: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("player")
	enemy = get_parent().get_enemy()
	get_parent().get_label().text = "Follow"


func physics_update(delta):
	var move_direction = player.global_position - enemy.global_position
	get_parent().state_label.text = "Follow" + "\n" + str(move_direction.length())
	
	if move_direction.length() < 250:
		enemy.velocity = move_direction.normalized() * move_speed
	
	else:
		enemy.velocity = Vector2()
	
	if move_direction.length() > 350:
		transitioned.emit(self, "enemyidle")
