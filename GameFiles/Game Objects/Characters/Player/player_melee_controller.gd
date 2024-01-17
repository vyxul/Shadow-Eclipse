extends Node

@onready var player_melee_attack = preload("res://GameFiles/Game Objects/Characters/Player/player_melee_attack.tscn")

@export var melee_attack_damage: int = 1


func attack(player_sprite: Node):
	var player_melee_attack_instance = player_melee_attack.instantiate()
	player_sprite.add_child(player_melee_attack_instance)
	player_melee_attack_instance.set_damage(melee_attack_damage)
	player_melee_attack_instance.attack()
