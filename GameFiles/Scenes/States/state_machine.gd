extends Node

@export var enemy: CharacterBody2D
@export var initial_state: State
@export var state_label: Label
@export var hurtbox_component: HurtboxComponent
@export var health_component: HealthComponent

var current_state: State
var states: Dictionary = {}


func get_enemy() -> CharacterBody2D:
	return enemy


func get_label() -> Label:
	return state_label


func get_hurtbox_component() -> HurtboxComponent:
	return hurtbox_component


func get_health_component() -> HealthComponent:
	return health_component


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
		
	new_state.enter()
	current_state = new_state


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
