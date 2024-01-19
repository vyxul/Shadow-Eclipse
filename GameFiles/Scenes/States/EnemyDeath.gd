extends State
class_name EnemyDeath


func enter():
	var enemy = get_parent().get_this_entity()
	print_debug(enemy.name + " entered EnemyDeath state")
	
	if enemy:
		enemy.queue_free()
