extends State
class_name state_hurt


var this_entity: CharacterBody2D
var hurtbox_component: HurtboxComponent

var invincibility_time: float = 0.5

var timer: float


func setup():
	this_entity = get_parent().get_this_entity()
	hurtbox_component = get_parent().get_hurtbox_component()

	invincibility_time = get_parent().invincibility_time


func enter():
	get_parent().get_state_label().text = "Hurt"
	timer = invincibility_time
	hurtbox_component.collision_layer = 0
	this_entity.velocity = Vector2.ZERO


func exit():
	hurtbox_component.collision_layer = 2


func update(delta):
	timer -= delta
	
	if timer <= 0:
		hurtbox_component.collision_layer = 2
	
		var previous_state = get_parent().previous_state
		var last_follower_state = get_parent().last_follower_state
		var is_follower = get_parent().is_follower
		var swarm_phase = this_entity.swarm_phase
		
	# need to change to be enum check instead of string check later
		if swarm_phase && !is_follower:
			transitioned.emit(self, "state_swarm_phase")
			return
	
		if previous_state is state_combat:
			transitioned.emit(self, "state_combat")
			return
			
		if is_follower:
			if last_follower_state is state_follow_target:
				transitioned.emit(self, "state_follow_target")
				return
			
			if last_follower_state is state_attack_target:
				transitioned.emit(self, "state_attack_target")
				return
			
			transitioned.emit(self, "state_follow_player")
			return
		
		else:
			transitioned.emit(self, "state_idle")
