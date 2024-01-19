extends State
class_name EnemyIdle

@export var move_speed: float = 10.0

var this_entity: CharacterBody2D
var move_direction: Vector2
var wander_time: float


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)


func enter():
	this_entity = get_parent().get_this_entity()
	randomize_wander()
	get_parent().get_state_label().text = "Idle"
	get_parent().get_enemy_follow_label().text = "Follow Count: " + str(get_parent().get_search_radius().get_enemies_in_follow_range_count())
	get_parent().get_enemy_combat_label().text = "Combat Count: " + str(get_parent().get_search_radius().get_enemies_in_combat_range_count())
	
	# set up connections with search_radius
	get_parent().get_search_radius().enemy_detected.connect(on_enemy_detected)


func exit():
	this_entity.velocity = Vector2.ZERO


func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()


func physics_update(delta: float):
	if this_entity:
		this_entity.velocity = move_direction * move_speed


func on_enemy_detected():
	transitioned.emit(self, "enemycombat")
