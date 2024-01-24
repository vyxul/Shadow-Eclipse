extends Node
class_name StateMachine

@export_group("State Setup")
@export var initial_state: State
@export var this_entity: CharacterBody2D
@export var hurtbox_component: HurtboxComponent
@export var health_component: HealthComponent
@export var conversion_component: ConversionComponent
@export var npc_attack_component: NpcAttackComponent
@export var search_radius: SearchRadius
@export var state_label: Label
@export var animation_player: AnimationPlayer

@export_group("State Properties")
@export_subgroup("Idle")
@export var idle_time: float = 1
@export var wander_move_speed: float = 10
@export var wander_max_time: float = 3

@export_subgroup("Combat")
@export var combat_move_speed: float = 50
@export var attack_cooldown: float = 1

@export_subgroup("Hurt")
@export var invincibility_time: float = 1

@export_subgroup("Follow Player")
@export var follow_move_speed: float = 50

@export_subgroup("Follow Target")
@export var follow_target_move_speed: float = 50

@export_subgroup("Attack Target")
@export var attack_target_move_speed: float = 50

@export_subgroup("Defend Target")
@export var defend_target_distance: float = 32

var current_state: State
var previous_state: State
var last_follower_state: State = null
var is_follower: bool = false
var states: Dictionary = {}

#region Getter Functions
func get_this_entity() -> CharacterBody2D:
	return this_entity


func get_hurtbox_component() -> HurtboxComponent:
	return hurtbox_component


func get_health_component() -> HealthComponent:
	return health_component


func get_conversion_component() -> ConversionComponent:
	return conversion_component


func get_npc_attack_component() -> NpcAttackComponent:
	return npc_attack_component


func get_search_radius() -> SearchRadius:
	return search_radius


func get_state_label() -> Label:
	return state_label


func get_animation_player() -> AnimationPlayer:
	return animation_player
#endregion


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.setup()
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	
	# set up state transitions that are always active
	hurtbox_component.hurt.connect(on_hurt)
	health_component.health_depleted.connect(on_health_depleted)
	conversion_component.new_follower_added.connect(on_new_follower_added)


func _process(delta):
	if current_state:
		current_state.update(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func on_child_transition(state, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
		previous_state = current_state
		if is_state_follower(current_state):
			last_follower_state = current_state
		
		
	current_state = new_state
	new_state.enter()


func is_state_follower(state: State):
	if state is state_follow_player:
		return true
	if state is state_follow_target:
		return true
	if state is state_defend_target:
		return true
	if state is state_attack_target:
		return true
	return false


func on_hurt():
	if current_state:
		current_state.exit()
		previous_state = current_state
	
	var new_state = states.get("state_hurt")
	current_state = new_state
	new_state.enter()


func on_health_depleted():
	if current_state:
		current_state.exit()
	
	var new_state = states.get("state_death")
	new_state.enter()
	current_state = new_state


func on_new_follower_added(entity: NonPlayerCharacter):
	if current_state:
		current_state.exit()
		previous_state = current_state
	
	var new_state = states.get("state_follow_player")
	new_state.enter()
	current_state = new_state
	is_follower = true
