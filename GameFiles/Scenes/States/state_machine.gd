extends Node

@export var this_entity: CharacterBody2D
@export var initial_state: State
@export var hurtbox_component: HurtboxComponent
@export var health_component: HealthComponent
@export var conversion_component: ConversionComponent
@export var search_radius: SearchRadius
@export var state_label: Label

var current_state: State
var states: Dictionary = {}


func get_this_entity() -> CharacterBody2D:
	return this_entity


func get_hurtbox_component() -> HurtboxComponent:
	return hurtbox_component


func get_health_component() -> HealthComponent:
	return health_component


func get_conversion_component() -> ConversionComponent:
	return conversion_component


func get_search_radius() -> SearchRadius:
	return search_radius


func get_state_label() -> Label:
	return state_label


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	
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
		
	current_state = new_state
	new_state.enter()


func on_hurt():
	if current_state:
		current_state.exit()
	
	var new_state = states.get("enemyhurt")
	new_state.enter()
	current_state = new_state


func on_health_depleted():
	if current_state:
		current_state.exit()
	
	var new_state = states.get("enemydeath")
	new_state.enter()
	current_state = new_state


func on_new_follower_added(entity: NonPlayerCharacter):
	print_debug("Follow stated not yet implemented")
	if current_state:
		current_state.exit()
	
	var new_state = states.get("followstate")
	new_state.enter()
	current_state = new_state
