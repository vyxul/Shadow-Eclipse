extends State
class_name SpawnState

var this_entity: CharacterBody2D

func enter():
	# play spawn animation
	this_entity = get_parent().get_this_entity()
	var animation_player = this_entity.get_animation_player() as AnimationPlayer
	get_parent().get_state_label().text = "Spawn"
	animation_player.animation_finished.connect(on_animation_finished)
	animation_player.play("spawn")
	pass


func exit():
	# set up collisions
	this_entity.collision_layer = 2


func on_animation_finished(animation):
	if animation == "spawn":
		#print_debug("finished spawn animation")
		transitioned.emit(self, "enemyidle")
