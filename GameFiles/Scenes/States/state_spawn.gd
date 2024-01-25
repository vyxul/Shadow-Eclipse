extends State
class_name state_spawn

var this_entity: CharacterBody2D
var hurtbox_component: HurtboxComponent
var animation_player: AnimationPlayer


func setup():
	this_entity = get_parent().get_this_entity()
	hurtbox_component = get_parent().get_hurtbox_component()
	animation_player = this_entity.get_animation_player() as AnimationPlayer
	animation_player.animation_finished.connect(on_animation_finished)


func enter():
	# play spawn animation
	get_parent().get_state_label().text = "Spawn"
	animation_player.play("spawn")
	this_entity.collision_layer = 0
	hurtbox_component.collision_layer = 0


func exit():
	# set up collisions
	this_entity.collision_layer = 2
	hurtbox_component.collision_layer = 2


func on_animation_finished(animation):
	if animation == "spawn":
		#print_debug("finished spawn animation")
		transitioned.emit(self, "state_idle")