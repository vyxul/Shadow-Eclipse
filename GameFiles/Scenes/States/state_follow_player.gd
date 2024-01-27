extends State
class_name state_follow_player


var this_entity: NonPlayerCharacter
var this_conversion_component: ConversionComponent
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer
var this_animation_player: AnimationPlayer

var follow_move_speed

var follow_marker: Marker2D

var is_following_player: bool = false


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	
	this_conversion_component = get_parent().get_conversion_component() as ConversionComponent
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	this_animation_player = get_parent().get_animation_player() as AnimationPlayer
	
	follow_move_speed = get_parent().follow_move_speed
	
	# set up event listeners
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.attack_target_command.connect(on_attack_target_command)
	get_parent().get_search_radius().tracking_enemy.connect(on_tracking_enemy)
	


func enter():
	follow_marker = this_conversion_component.follow_marker as Marker2D
	
	get_parent().get_state_label().text = "Follow Player"
	this_navigation_timer.start()
	this_animation_player.play("walk")
	is_following_player = true


func exit():
	this_navigation_timer.stop()
	this_animation_player.stop()
	is_following_player = false


func physics_update(delta):
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * follow_move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func make_path() -> void:
	var follow_marker_global_position = follow_marker.global_position
	this_navigation_agent.target_position = follow_marker_global_position


func on_navigation_timer_timeout():
	if !is_following_player:
		return
		
	call_deferred("make_path")


func on_follow_target_set():
	transitioned.emit(self, "state_follow_target")


func on_attack_target_command():
	transitioned.emit(self, "state_attack_target")


func on_tracking_enemy():
	transitioned.emit(self, "state_combat")
