extends Node2D
class_name SearchRadius

signal tracking_enemy
signal not_tracking_enemy

@export var tracked_enemies_range: float = 180
@export var discovery_range: float = 100

@onready var tracked_enemies_area_2d = $Tracked_Enemies_Area2D
@onready var tracked_enemies_collision_shape_2d = $Tracked_Enemies_Area2D/Tracked_Enemies_CollisionShape2D
@onready var discovery_area_2d = $Discovery_Area2D
@onready var discovery_collision_shape_2d = $Discovery_Area2D/Discovery_CollisionShape2D
@onready var ray_cast_2d = $RayCast2D

var enemies_in_discovery_range = []
var tracked_enemies_in_range = []

var currently_tracking_enemy: bool = false

var raycast_length: float = 50


func _ready():
	tracked_enemies_range = max(tracked_enemies_range, discovery_range * 1.1)
	tracked_enemies_collision_shape_2d.shape.radius = tracked_enemies_range
	discovery_collision_shape_2d.shape.radius = discovery_range
	raycast_length = tracked_enemies_range
	ray_cast_2d.position = Vector2.ZERO


func _physics_process(delta):
	var found_enemies = []
	
	for enemy in enemies_in_discovery_range:
		var enemy_direction = enemy.global_position - get_parent().global_position
		ray_cast_2d.target_position = enemy_direction
		ray_cast_2d.force_raycast_update()
		
		var raycast_hit_object = null
		if ray_cast_2d.is_colliding():
			raycast_hit_object = ray_cast_2d.get_collider()
	
		if enemy == raycast_hit_object:
			found_enemies.append(enemy)

	for enemy in found_enemies:
		add_enemy_to_tracking(enemy)
		enemies_in_discovery_range.erase(enemy)


#region Emit Signal Functions
func emit_tracking_enemy():
	if currently_tracking_enemy:
		return
	
	currently_tracking_enemy = true
	tracking_enemy.emit()
	#print_debug("Emitting tracking_enemy")



func emit_not_tracking_enemy():
	if !currently_tracking_enemy:
		return
	
	currently_tracking_enemy = false
	not_tracking_enemy.emit()
	#print_debug("Emitting not_tracking_enemy")
#endregion


#region Array Helper Functions
func add_enemy_to_tracking(body):
	tracked_enemies_in_range.append(body)
	emit_tracking_enemy()


func remove_enemy_from_tracking(body):
	tracked_enemies_in_range.erase(body)
	
	if tracked_enemies_in_range.size() <= 0:
		emit_not_tracking_enemy()


func get_closest_tracked_enemy():
	var tracked_enemy_count = tracked_enemies_in_range.size()
	if tracked_enemy_count <= 0:
		return null
	
	var closest_enemy = tracked_enemies_in_range[0]
	var closest_distance = (tracked_enemies_in_range[0].global_position - get_parent().global_position).length()
	for index in range(1, tracked_enemy_count):
		var distance = (tracked_enemies_in_range[index].global_position - get_parent().global_position).length()
		if distance < closest_distance:
			closest_enemy = tracked_enemies_in_range[index]
			closest_distance = distance
	
	return closest_enemy
#endregion


#region Area Event Listeners
func _on_discovery_area_2d_body_entered(body):
	var this_parent = get_parent()
	if body == this_parent:
		return
	
	# theres a problem that for some reason that body and parent are
	# the same object when not player
	# problem was that the enemies spawned within the others discovery area
	# and weren't actually entering
	# simple solution is to just make them spawn further
	# another possible solution is to make it check overlapping bodies
	# and if it's not already in tracked or discovery list, 
	# then add it to discovery list
	# just doing simple solution for now
	
	
	var this_faction = this_parent.get_faction()
	var that_faction = body.get_faction()
	var body_is_ally = GameData.is_faction_ally(this_faction, that_faction)
	#print_debug("this name = " + this_parent.name)
	#print_debug("body name = " + body.name)

	if !body_is_ally:
		#print_debug("Enemy Body")
		enemies_in_discovery_range.append(body)


func _on_discovery_area_2d_body_exited(body):
	# dont need to check if body was removed from list from raycast check
	# erase will work fine if it doesn't see body in list
	enemies_in_discovery_range.erase(body)


func _on_tracking_area_2d_body_exited(body):
	remove_enemy_from_tracking(body)
#endregion
