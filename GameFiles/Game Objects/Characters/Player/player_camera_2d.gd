extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_player(delta)


func follow_player(delta: float):
	var player_node = get_tree().get_first_node_in_group("player") as CharacterBody2D
	
	if player_node == null:
		return
		
	var target_position = player_node.global_position
	global_position = global_position.lerp(target_position, 1 - exp(-delta * 5))
