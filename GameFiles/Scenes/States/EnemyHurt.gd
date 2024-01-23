extends State
class_name EnemyHurt

@export var invincibility_time: float = 0.5

var this_entity: CharacterBody2D
var hurtbox_component: HurtboxComponent
var timer: float

func enter():
	this_entity = get_parent().get_this_entity()
	hurtbox_component = get_parent().get_hurtbox_component()
	get_parent().get_state_label().text = "Hurt"
	timer = invincibility_time
	hurtbox_component.collision_layer = 0
	
	if this_entity:
		this_entity.set_process(false)


func update(delta):
	timer -= delta
	
	if timer <= 0:
		hurtbox_component.collision_layer = 2
		if this_entity:
			this_entity.set_process(true)
		
		var previous_state = get_parent().previous_state
		# need to change to be enum check instead of string check later
		if previous_state is SpawnState:
			this_entity.collision_layer = 2
			transitioned.emit(self, "SpawnState")
		
		if previous_state is EnemyIdle:
			transitioned.emit(self, "EnemyIdle")
		
		if previous_state is EnemyCombat:
			transitioned.emit(self, "EnemyCombat")
		
		if previous_state is FollowPlayerState:
			transitioned.emit(self, "FollowPlayerState")
		
		if previous_state is FollowTargetState:
			transitioned.emit(self, "FollowTargetState")
		
		if previous_state is AttackTargetState:
			transitioned.emit(self, "AttackTargetState")
