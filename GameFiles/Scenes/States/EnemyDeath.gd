extends State
class_name EnemyDeath


func enter():
	var this_entity = get_parent().get_this_entity()
	this_entity.velocity = Vector2.ZERO
	print_debug(this_entity.name + " entered EnemyDeath state")
	var animation_player = get_parent().get_animation_player()
	animation_player.play("death")
	
	await animation_player.animation_finished
	if this_entity:
		GameData.emit_npc_died(this_entity)
		GameData.add_score(this_entity.kill_score)
		this_entity.queue_free()
