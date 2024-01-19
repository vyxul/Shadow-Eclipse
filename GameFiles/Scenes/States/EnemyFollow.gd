extends State
class_name EnemyFollow

@export var move_speed: float = 50

var player: Player
var enemy: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("player")
	enemy = get_parent().get_enemy()
	get_parent().get_state_label().text = "Follow"
	get_parent().get_enemy_follow_label().text = "Follow Count: " + str(get_parent().get_search_radius().get_enemies_in_follow_range_count())
	get_parent().get_enemy_combat_label().text = "Combat Count: " + str(get_parent().get_search_radius().get_enemies_in_combat_range_count())

	# set up connections with search_radius
	get_parent().get_search_radius().no_enemy_in_follow_range.connect(on_no_enemy_in_follow_range)
	get_parent().get_search_radius().no_enemy_in_combat_range.connect(on_no_enemy_in_combat_range)


func physics_update(delta):
	var move_direction = player.global_position - enemy.global_position
	get_parent().state_label.text = "Follow" + "\n" + str(move_direction.length())
	
	enemy.velocity = move_direction.normalized() * move_speed


func on_no_enemy_in_follow_range():
	transitioned.emit(self, "enemyidle")


func on_no_enemy_in_combat_range():
	transitioned.emit(self, "enemyidle")
