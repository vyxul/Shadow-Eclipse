extends State
class_name state_combat


var this_entity: NonPlayerCharacter
var this_npc_attack_component: NpcAttackComponent
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer
var this_search_radius: SearchRadius
var focus_target: CharacterBody2D

var combat_move_speed
var attack_cooldown
var attack_cd_timer: float = 0

var in_combat: bool = false
var is_attacking: bool = false
var is_follower: bool


func setup():
	# set up component references
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_npc_attack_component = get_parent().get_npc_attack_component() as NpcAttackComponent
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	this_search_radius = get_parent().get_search_radius() as SearchRadius
	
	# set up state properties
	combat_move_speed = get_parent().combat_move_speed
	attack_cooldown = get_parent().attack_cooldown
	
	# set up event listeners
	this_npc_attack_component.attack_finished.connect(on_attack_finished)
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	get_parent().get_search_radius().not_tracking_enemy.connect(on_not_tracking_enemy)
	GameData.follow_player.connect(on_follow_player)
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.attack_target_command.connect(on_attack_target_command)
	
	focus_target = this_search_radius.get_closest_tracked_enemy() as CharacterBody2D


func enter():
	get_parent().get_animation_player().play("walk")
	get_parent().get_state_label().text = "Combat"
	
	in_combat = true
	this_navigation_timer.start()
	is_follower = get_parent().is_follower
	

func exit():
	in_combat = false
	this_navigation_timer.stop()
	focus_target = null
	get_parent().get_animation_player().play("RESET")


func update(delta):
	focus_target = this_search_radius.get_closest_tracked_enemy()
	
	if !is_attacking:
		attack_cd_timer -= delta
	
	if this_npc_attack_component.is_body_in_attack_range(focus_target) && (attack_cd_timer <= 0):
		is_attacking = true
		this_npc_attack_component.attack(focus_target)
		attack_cd_timer = attack_cooldown


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = move_direction.normalized() * combat_move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * combat_move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func on_attack_finished():
	is_attacking = false


func make_path() -> void:
	if !focus_target:
		return
	
	this_navigation_agent.target_position = focus_target.global_position


func on_navigation_timer_timeout():
	if !in_combat:
		return
	
	make_path()


func on_not_tracking_enemy():
	var previous_state = get_parent().previous_state
	var last_follower_state = get_parent().last_follower_state
	var is_follower = get_parent().is_follower
	
	if is_follower:
		if last_follower_state is state_follow_player:
			transitioned.emit(self, "state_follow_player")
			return
			
		if last_follower_state is state_follow_target:
			transitioned.emit(self, "state_follow_target")
			return
			
		if last_follower_state is state_defend_target:
			transitioned.emit(self, "state_defend_target")
			return

		if last_follower_state is state_attack_target:
			transitioned.emit(self, "state_follow_player")
			return

	else:
		transitioned.emit(self, "state_idle")


func on_follow_player():
	if !is_follower:
		return
	
	transitioned.emit(self, "state_follow_player")


func on_follow_target_set():
	if !is_follower:
		return
	
	transitioned.emit(self, "state_follow_target")


func on_attack_target_command():
	if !is_follower:
		return
	
	transitioned.emit(self, "state_attack_target")
