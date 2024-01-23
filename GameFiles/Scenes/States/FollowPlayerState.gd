extends State
class_name FollowPlayerState

@export var move_speed: float = 50

var this_entity: NonPlayerCharacter
var this_conversion_component: ConversionComponent
var this_animation_player: AnimationPlayer
var follow_marker: Marker2D
var player: Player
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var is_setup: bool = false
var is_following_player: bool = false

func enter():
	if !is_setup:
		setup()

	get_parent().get_state_label().text = "Follow Player"
	this_navigation_timer.start()
	this_animation_player.play("walk")
	is_following_player = true


func exit():
	this_navigation_timer.stop()
	this_animation_player.stop()
	is_following_player = false


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = moved_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	# can move next 2 lines to conversion component
	this_entity.faction = GameData.Factions.SHADOW
	this_entity.collision_layer = 8
	
	this_conversion_component = get_parent().get_conversion_component() as ConversionComponent
	follow_marker = this_conversion_component.follow_marker as Marker2D
	player = this_conversion_component.player as Player
	
	this_animation_player = get_parent().get_animation_player() as AnimationPlayer
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	
	# set up connections for follower commands
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.attack_target_command.connect(on_attack_target_command)
	
	is_setup = true


func make_path() -> void:
	var follow_marker_global_position = follow_marker.global_position
	this_navigation_agent.target_position = follow_marker_global_position


func on_navigation_timer_timeout():
	if !is_following_player:
		return
		
	make_path()


func on_follow_target_set():
	transitioned.emit(self, "followtargetstate")


func on_attack_target_command():
	transitioned.emit(self, "attacktargetstate")
