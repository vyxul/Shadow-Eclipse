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


func update(delta):
	timer -= delta
	
	if timer <= 0:
		hurtbox_component.collision_layer = 2
	
		var last_follower_state = get_parent().last_follower_state
		
		# need to change to be enum check instead of string check later
		
		if last_follower_state is state_follow_player:
			transitioned.emit(self, "state_follow_player")
			return
		
		if last_follower_state is state_follow_target:
			transitioned.emit(self, "state_follow_target")
			return
		
		if last_follower_state is state_attack_target:
			transitioned.emit(self, "state_attack_target")
			return
			
		transitioned.emit(self, "state_idle")
