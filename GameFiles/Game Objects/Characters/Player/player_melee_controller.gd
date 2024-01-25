extends Node2D

@onready var player_melee_attack = preload("res://GameFiles/Game Objects/Characters/Player/player_melee_attack.tscn")

@export var melee_attack_damage: int = 1

var is_attacking: bool


func attack(player_sprite: Node):
	if is_attacking:
		return
	
	is_attacking = true
	var player_melee_attack_instance = player_melee_attack.instantiate()
	player_sprite.add_child(player_melee_attack_instance)
	player_melee_attack_instance.set_damage(melee_attack_damage)
	player_melee_attack_instance.set_faction(GameData.Factions.SHADOW)
	player_melee_attack_instance.finished.connect(on_finished)
	player_melee_attack_instance.attack()
	
	var player = get_parent()
	var animation_player = player.animation_player
	animation_player.play("attack")
	var attack_direction = get_global_mouse_position() - player.global_position
	if attack_direction.x < 0:
		player.sprite_2d.flip_h = true
		player.direction = -1
	elif attack_direction.x > 0:
		player.sprite_2d.flip_h = false
		player.direction = 1


func on_finished():
	is_attacking = false
