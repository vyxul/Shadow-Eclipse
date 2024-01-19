extends Node2D
class_name SearchRadius

signal enemy_detected
signal no_enemy_in_follow_range
signal fighting_enemy
signal no_enemy_in_combat_range


@export var follow_range: float = 180
@export var combat_range: float = 100

@onready var follow_area_2d = $Follow_Area2D
@onready var follow_collision_shape_2d = $Follow_Area2D/Follow_CollisionShape2D
@onready var combat_area_2d = $Combat_Area2D
@onready var combat_collision_shape_2d = $Combat_Area2D/Combat_CollisionShape2D
@onready var ray_cast_2d = $RayCast2D

var enemies_in_follow_range = []
var enemies_in_combat_range = []

var currently_following_enemy: bool = false
var currently_fighting_enemy: bool = false


func _ready():
	follow_range = max(follow_range, combat_range)
	follow_collision_shape_2d.shape.radius = follow_range
	combat_collision_shape_2d.shape.radius = combat_range
	set_process(false)


func _process(delta):
	# for now just doing raycast check to player
	# later need to raycast for every enemy in array
	var enemy_direction = get_tree().get_first_node_in_group("player").global_position - get_parent().global_position
	var enemy_distance = enemy_direction.length()
	var raycast_length = min(follow_range, enemy_distance)
	ray_cast_2d.target_position = enemy_direction.normalized() * raycast_length
	#ray_cast_2d.enabled = true
	
	if !ray_cast_2d.is_colliding():
		emit_enemy_detected()


#region Emit Functions
func emit_enemy_detected():
	if currently_following_enemy:
		return
	
	currently_following_enemy = true
	enemy_detected.emit()


func emit_fighting_enemy():
	if currently_fighting_enemy:
		return
	
	currently_fighting_enemy = true
	fighting_enemy.emit()
#endregion


#region Array Helper Functions
func add_enemy_in_follow_range(body):
	enemies_in_follow_range.append(body)
	set_process(true)


func remove_enemy_in_follow_range(body):
	enemies_in_follow_range.erase(body)
	
	if enemies_in_follow_range.size() <= 0:
		set_process(false)
		#ray_cast_2d.enabled = false
		currently_following_enemy = false
		no_enemy_in_follow_range.emit()


func add_enemy_in_combat_range(body):
	enemies_in_combat_range.append(body)
	emit_fighting_enemy()


func remove_enemy_in_combat_range(body):
	enemies_in_combat_range.erase(body)
	
	if enemies_in_combat_range.size() <= 0:
		currently_fighting_enemy = false
		no_enemy_in_combat_range.emit()


func get_enemies_in_follow_range_count():
	return enemies_in_follow_range.size()


func get_enemies_in_combat_range_count():
	return enemies_in_combat_range.size()


func check_entity_in_range(entity: CharacterBody2D):
	return enemies_in_follow_range.has(entity)
#endregion


#region Follow Area Event Listeners
func _on_follow_area_2d_body_entered(body):
	var this_faction = get_parent().get_faction()
	var that_faction = body.get_faction()
	var body_is_ally = GameData.is_faction_ally(this_faction, that_faction)

	if !body_is_ally:
		#print_debug("Enemy Body")
		add_enemy_in_follow_range(body)


func _on_follow_area_2d_body_exited(body):
	remove_enemy_in_follow_range(body)
#endregion


#region Combat Area Event Listeners
func _on_combat_area_2d_body_entered(body):
	var this_faction = get_parent().get_faction()
	var that_faction = body.get_faction()
	var body_is_ally = GameData.is_faction_ally(this_faction, that_faction)

	if !body_is_ally:
		#print_debug("Enemy Body")
		add_enemy_in_combat_range(body)


func _on_combat_area_2d_body_exited(body):
	remove_enemy_in_combat_range(body)
#endregion
