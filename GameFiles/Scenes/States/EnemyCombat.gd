extends State
class_name EnemyCombat

@export var move_speed: float = 50

var focus_target: CharacterBody2D
var this_entity: CharacterBody2D
var this_search_radius: SearchRadius
var in_attack_range: bool = false

func enter():
	# for now using player as focus target
	# later can search through search_radius array for closest enemy faction entity
	this_entity = get_parent().get_this_entity()
	this_search_radius = get_parent().get_search_radius()
	focus_target = this_search_radius.get_closest_tracked_enemy()

	get_parent().get_state_label().text = "Combat"
	get_parent().get_search_radius().not_tracking_enemy.connect(on_not_tracking_enemy)



func exit():
	focus_target = null


func update(delta):
	focus_target = this_search_radius.get_closest_tracked_enemy()


func physics_update(delta):
	var move_direction = focus_target.global_position - this_entity.global_position
	this_entity.velocity = move_direction.normalized() * move_speed


func on_not_tracking_enemy():
	transitioned.emit(self, "enemyidle")
	print_debug("Transitioning from combat to idle")
