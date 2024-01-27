extends State
class_name state_follow_target


var this_entity: NonPlayerCharacter
var this_animation_player: AnimationPlayer
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var follow_target_move_speed

var follow_target: Vector2
var is_following_target: bool = false


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_animation_player = get_parent().get_animation_player() as AnimationPlayer
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	
	follow_target_move_speed = get_parent().follow_target_move_speed
	
	# set up event listeners
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	GameData.follow_player.connect(on_follow_player)
	GameData.attack_target_command.connect(on_attack_target_command)
	this_navigation_agent.target_reached.connect(on_target_reached)
	get_parent().get_search_radius().tracking_enemy.connect(on_tracking_enemy)


func enter():
	get_parent().get_state_label().text = "Follow"
	this_animation_player.play("walk")
	this_navigation_timer.start()
	is_following_target = true
	
	follow_target = GameData.follow_target_position
	this_navigation_agent.target_position = follow_target


func exit():
	this_animation_player.stop()
	this_navigation_timer.stop()
	is_following_target = false


func physics_update(delta):
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * follow_target_move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func make_path() -> void:
	follow_target = GameData.follow_target_position
	this_navigation_agent.target_position = follow_target


func on_navigation_timer_timeout():
	if !is_following_target:
		return
		
	call_deferred("make_path")


func on_follow_player():
	transitioned.emit(self, "state_follow_player")


func on_attack_target_command():
	transitioned.emit(self, "state_attack_target")


func on_target_reached():
	transitioned.emit(self, "state_defend_target")


func on_tracking_enemy():
	transitioned.emit(self, "state_combat")
