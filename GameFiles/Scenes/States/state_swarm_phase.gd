extends State
class_name state_swarm_phase


var this_entity: NonPlayerCharacter
var this_npc_attack_component: NpcAttackComponent
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var attack_target_move_speed
var attack_cooldown

var focus_target: Player
var attack_cd_timer: float = 0
var in_attack_target: bool = false
var is_attacking: bool = false


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_npc_attack_component = this_entity.get_npc_attack_component() as NpcAttackComponent
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	focus_target = get_tree().get_first_node_in_group("player")
	
	attack_target_move_speed = get_parent().attack_target_move_speed
	attack_cooldown = get_parent().attack_cooldown
	
	# set up event listeners
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	this_npc_attack_component.attack_finished.connect(on_attack_finished)


func enter():
	get_parent().get_animation_player().play("walk")
	get_parent().get_state_label().text = "Swarm Phase"

	in_attack_target = true
	this_navigation_timer.start()


func exit():
	get_parent().get_animation_player().play("RESET")
	in_attack_target = false
	this_navigation_timer.stop()


func update(delta):
	if !is_attacking:
		attack_cd_timer -= delta
	
	#if this_npc_attack_component.is_body_in_attack_range(focus_target) && (attack_cd_timer <= 0):
	if is_colliding_with_terrain() && attack_cd_timer <= 0:
		is_attacking = true
		this_npc_attack_component.attack(focus_target)
		attack_cd_timer = attack_cooldown


func physics_update(delta):
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * attack_target_move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func is_colliding_with_terrain():
	return this_entity.is_on_wall() || this_entity.is_on_ceiling() || this_entity.is_on_floor()


func make_path() -> void:
	this_navigation_agent.target_position = focus_target.global_position


func on_navigation_timer_timeout():
	if !in_attack_target:
		return
	
	make_path()


func on_attack_finished():
	is_attacking = false
