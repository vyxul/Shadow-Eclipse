extends State
class_name state_attack_target


var this_entity: NonPlayerCharacter
var this_npc_attack_component: NpcAttackComponent
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer

var attack_target_move_speed
var attack_cooldown

var focus_target: NonPlayerCharacter
var attack_cd_timer: float = 0
var in_attack_target: bool = false
var is_attacking: bool = false


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_npc_attack_component = this_entity.get_npc_attack_component() as NpcAttackComponent
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	
	attack_target_move_speed = get_parent().attack_target_move_speed
	attack_cooldown = get_parent().attack_cooldown
	
	# set up event listeners
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	this_npc_attack_component.attack_finished.connect(on_attack_finished)
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.follow_player.connect(on_follow_player)
	GameData.attack_target_command.connect(on_attack_target_command)
	GameData.npc_died.connect(on_npc_died)


func enter():
	focus_target = GameData.get_attack_target()
	get_parent().get_animation_player().play("walk")
	get_parent().get_state_label().text = "Attack Target"

	in_attack_target = true
	this_navigation_timer.start()


func exit():
	focus_target = null
	get_parent().get_animation_player().play("RESET")
	in_attack_target = false
	this_navigation_timer.stop()


func update(delta):
	if !focus_target:
		return
		
	if !is_attacking:
		attack_cd_timer -= delta
	
	if this_npc_attack_component.is_body_in_attack_range(focus_target) && (attack_cd_timer <= 0):
		is_attacking = true
		this_npc_attack_component.attack(focus_target)
		attack_cd_timer = attack_cooldown


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = move_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * attack_target_move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func make_path() -> void:
	if !focus_target:
		return
	
	this_navigation_agent.target_position = focus_target.global_position


func on_navigation_timer_timeout():
	if !in_attack_target:
		return
	
	call_deferred("make_path")


func on_attack_finished():
	is_attacking = false


func on_follow_player():
	transitioned.emit(self, "state_follow_player")


func on_follow_target_set():
	transitioned.emit(self, "state_follow_target")


func on_attack_target_command():
	focus_target = GameData.get_attack_target()


func on_npc_died(npc: NonPlayerCharacter):
	if focus_target == npc:
		focus_target = null
		transitioned.emit(self, "state_follow_player")
