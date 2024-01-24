extends Node

@onready var player_range_attack = preload("res://GameFiles/Game Objects/Characters/Player/player_ranged_attack.tscn")

@export_range(100, 2000) var projectile_speed: float = 100
@export_range(.1, 10) var projectile_time: float = 5
@export_range(1, 999) var range_attack_damage: int = 1
@export_range(1, 999) var range_attack_pierce_limit: int = 1


func attack():
	var player_range_attack_instance = player_range_attack.instantiate()
	var projectiles_layer = get_tree().get_first_node_in_group("projectiles")
	projectiles_layer.add_child(player_range_attack_instance)
	
	player_range_attack_instance.set_projectile_speed(projectile_speed)
	player_range_attack_instance.set_projectile_time(projectile_time)
	player_range_attack_instance.set_damage(range_attack_damage)
	player_range_attack_instance.set_pierce_limit(range_attack_pierce_limit)
	player_range_attack_instance.set_faction(GameData.Factions.SHADOW)
	
	player_range_attack_instance.attack()
