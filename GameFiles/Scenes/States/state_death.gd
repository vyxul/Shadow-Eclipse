extends State
class_name state_death

var this_entity: NonPlayerCharacter
var this_animation_player: AnimationPlayer

func setup():
	this_entity = get_parent().get_this_entity()
	this_animation_player = get_parent().get_animation_player()


func enter():
	this_entity.velocity = Vector2.ZERO
	print_debug(this_entity.name + " entered EnemyDeath state")
	this_animation_player.play("death")
	
	await this_animation_player.animation_finished
	if this_entity:
		GameData.emit_npc_died(this_entity)
		GameData.add_score(this_entity.kill_score)
		this_entity.queue_free()
