extends Node2D

const extension_range = 8

var melee_attack_damage: int = 0


#func _process(delta):
	#set_attack_position()


func set_damage(dmg: int):
	melee_attack_damage = dmg


func get_damage():
	return melee_attack_damage


func set_attack_position():
	var player = get_tree().get_first_node_in_group("player")
	var player_position = player.get_weapon_origin() as Vector2
	var weapon_direction = player_position.direction_to(get_global_mouse_position())
	var weapon_position = player_position + (weapon_direction * extension_range)
	var weapon_angle = weapon_direction.angle()
	global_position = weapon_position
	rotation = weapon_angle + (PI/2)

func attack():
	set_attack_position()
	$AnimationPlayer.play("attack")
