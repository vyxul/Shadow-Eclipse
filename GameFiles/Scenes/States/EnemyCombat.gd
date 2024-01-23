extends State
class_name EnemyCombat

@export var npc_attack_component: NpcAttackComponent
@export var move_speed: float = 50
@export var attack_cooldown: float = 1

var focus_target: CharacterBody2D
var this_entity: NonPlayerCharacter
var this_search_radius: SearchRadius
var this_navigation_agent: NavigationAgent2D
var this_navigation_timer: Timer
var attack_cd_timer: float = 0

var in_combat: bool = false
var is_setup: bool = false
var is_attacking: bool = false

func enter():
	if !is_setup:
		setup()
	
	get_parent().get_animation_player().play("walk")

	get_parent().get_state_label().text = "Combat"

	in_combat = true
	this_navigation_timer.start()


func exit():
	this_navigation_timer.stop()
	focus_target = null
	in_combat = false
	get_parent().get_animation_player().play("RESET")


func update(delta):
	focus_target = this_search_radius.get_closest_tracked_enemy()
	
	if !is_attacking:
		attack_cd_timer -= delta
	
	if npc_attack_component.is_body_in_attack_range(focus_target) && (attack_cd_timer <= 0):
		is_attacking = true
		npc_attack_component.attack(focus_target)
		attack_cd_timer = attack_cooldown


func physics_update(delta):
	#var move_direction = focus_target.global_position - this_entity.global_position
	#this_entity.velocity = move_direction.normalized() * move_speed
	
	var move_direction = this_entity.to_local(this_navigation_agent.get_next_path_position()).normalized()
	this_entity.velocity = move_direction * move_speed
	this_entity.get_sprite().flip_h = this_entity.velocity.x < 0


func setup():
	this_entity = get_parent().get_this_entity() as NonPlayerCharacter
	this_navigation_agent = this_entity.get_navigation_agent() as NavigationAgent2D
	this_navigation_timer = this_entity.get_navigation_timer() as Timer
	this_search_radius = get_parent().get_search_radius() as SearchRadius
	focus_target = this_search_radius.get_closest_tracked_enemy() as CharacterBody2D
	
	get_parent().get_search_radius().not_tracking_enemy.connect(on_not_tracking_enemy)
	this_navigation_timer.timeout.connect(on_navigation_timer_timeout)
	npc_attack_component.attack_finished.connect(on_attack_finished)
	
	is_setup = true


func make_path() -> void:
	this_navigation_agent.target_position = focus_target.global_position


func on_not_tracking_enemy():
	transitioned.emit(self, "enemyidle")
	#print_debug("Transitioning from combat to idle")


func on_navigation_timer_timeout():
	if !in_combat:
		return
	
	make_path()


func on_attack_finished():
	is_attacking = false
