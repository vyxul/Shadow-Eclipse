extends State
class_name FollowTargetState

@export var move_speed: float = 50

var this_entity: NonPlayerCharacter
var this_animation_player: AnimationPlayer
var follow_target: Vector2
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var is_setup: bool = false
var is_following_target: bool = false

func enter():
	if !is_setup:
		setup()

	get_parent().get_state_label().text = "Follow"
	this_animation_player.play("walk")
	this_navigation_timer.start()
	is_following_target = true


func exit():
	this_animation_player.stop()
	this_navigation_timer.stop()
	is_following_target = false


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = moved_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0
	


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_animation_player = get_parent().get_animation_player() as AnimationPlayer
	follow_target = GameData.follow_target_position

	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	this_navigation_agent.target_position = follow_target
	
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	
	# set up connections for follower commands
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.follow_player.connect(on_follow_player)
	GameData.attack_target_command.connect(on_attack_target_command)
	# set up event for when npc reaches target, move onto defend state?
	
	is_setup = true


func make_path() -> void:
	follow_target = GameData.follow_target_position
	this_navigation_agent.target_position = follow_target


func on_navigation_timer_timeout():
	if !is_following_target:
		return
		
	make_path()


func on_follow_player():
	transitioned.emit(self, "followplayerstate")


func on_follow_target_set():
	follow_target = GameData.follow_target_position


func on_attack_target_command():
	transitioned.emit(self, "attacktargetstate")
