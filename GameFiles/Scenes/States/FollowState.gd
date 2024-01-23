extends State
class_name FollowState

@export var move_speed: float = 50

var this_entity: NonPlayerCharacter
var this_conversion_component: ConversionComponent
var follow_marker: Marker2D
var player: Player
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var is_following: bool = false

func enter():
	this_entity = get_parent().get_this_entity()
	this_entity.faction = GameData.Factions.SHADOW
	this_entity.collision_layer = 8
	this_conversion_component = get_parent().get_conversion_component() as ConversionComponent
	follow_marker = this_conversion_component.follow_marker as Marker2D
	player = this_conversion_component.player as Player

	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer

	get_parent().get_state_label().text = "Follow"
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)

	is_following = true
	this_navigation_timer.start()


func exit():
	is_following = false


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = move_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * move_speed


func make_path() -> void:
	this_navigation_agent.target_position = follow_marker.global_position


func on_navigation_timer_timeout():
	if !is_following:
		return

	make_path()
