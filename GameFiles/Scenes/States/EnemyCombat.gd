extends State
class_name EnemyCombat

@export var move_speed: float = 50

var focus_target: CharacterBody2D
var this_entity: NonPlayerCharacter
var this_search_radius: SearchRadius
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var in_combat: bool = false

func enter():
	# for now using player as focus target
	# later can search through search_radius array for closest enemy faction entity
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	this_search_radius = get_parent().get_search_radius() as SearchRadius
	focus_target = this_search_radius.get_closest_tracked_enemy() as CharacterBody2D

	get_parent().get_state_label().text = "Combat"
	get_parent().get_search_radius().not_tracking_enemy.connect(on_not_tracking_enemy)
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)

	in_combat = true
	this_navigation_timer.start()


func exit():
	this_navigation_timer.stop()
	focus_target = null
	in_combat = false


func update(delta):
	focus_target = this_search_radius.get_closest_tracked_enemy()


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = move_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * move_speed


func make_path() -> void:
	this_navigation_agent.target_position = focus_target.global_position


func on_not_tracking_enemy():
	transitioned.emit(self, "enemyidle")
	print_debug("Transitioning from combat to idle")


func on_navigation_timer_timeout():
	if !in_combat:
		return
	
	make_path()
