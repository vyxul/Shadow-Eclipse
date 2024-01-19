extends State
class_name EnemyCombat

@export var move_speed: float = 50

var focus_target: CharacterBody2D
var this_entity: CharacterBody2D

var in_attack_range: bool = false

func enter():
	# for now using player as focus target
	# later can search through search_radius array for closest enemy faction entity
	focus_target = get_tree().get_first_node_in_group("player")
	this_entity = get_parent().get_this_entity()

	get_parent().get_state_label().text = "Combat"
	get_parent().get_enemy_follow_label().text = "Follow Count: " + str(get_parent().get_search_radius().get_enemies_in_follow_range_count())
	get_parent().get_enemy_combat_label().text = "Combat Count: " + str(get_parent().get_search_radius().get_enemies_in_combat_range_count())

	# set up connections with search_radius
	get_parent().get_search_radius().fighting_enemy.connect(on_fighting_enemy)
	get_parent().get_search_radius().no_enemy_in_follow_range.connect(on_no_enemy_in_follow_range)
	get_parent().get_search_radius().no_enemy_in_combat_range.connect(on_no_enemy_in_combat_range)


func exit():
	focus_target = null


func physics_update(delta):
	if !in_attack_range:
		var move_direction = focus_target.global_position - this_entity.global_position
		get_parent().state_label.text = "Combat (Chasing)" + "\n" + str(move_direction.length())
		
		this_entity.velocity = move_direction.normalized() * move_speed


func on_fighting_enemy():
	in_attack_range = true
	this_entity.velocity = Vector2.ZERO
	get_parent().get_state_label().text = "Combat (Attacking)"
	get_parent().get_enemy_follow_label().text = "Follow Count: " + str(get_parent().get_search_radius().get_enemies_in_follow_range_count())
	get_parent().get_enemy_combat_label().text = "Combat Count: " + str(get_parent().get_search_radius().get_enemies_in_combat_range_count())


func on_no_enemy_in_follow_range():
	transitioned.emit(self, "enemyidle")


func on_no_enemy_in_combat_range():
	in_attack_range = false
	get_parent().get_enemy_follow_label().text = "Follow Count: " + str(get_parent().get_search_radius().get_enemies_in_follow_range_count())
	get_parent().get_enemy_combat_label().text = "Combat Count: " + str(get_parent().get_search_radius().get_enemies_in_combat_range_count())
