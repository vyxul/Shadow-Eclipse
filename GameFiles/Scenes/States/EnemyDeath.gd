extends State
class_name EnemyDeath


func enter():
	var enemy = get_parent().get_this_entity()
	print_debug(enemy.name + " entered EnemyDeath state")
	var animation_player = get_parent().get_animation_player()
	animation_player.play("death")
	
	await animation_player.animation_finished
	if enemy:
		enemy.queue_free()
