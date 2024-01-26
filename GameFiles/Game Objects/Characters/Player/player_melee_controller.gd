extends Node2D

@onready var player_melee_attack = preload("res://GameFiles/Game Objects/Characters/Player/player_melee_attack.tscn")
@onready var audio_stream_player = $AudioStreamPlayer

@export var melee_attack_damage: float = 1
var damage_multiplier: float = 0
var current_damage: float = 0

var is_attacking: bool


func attack(player_sprite: Node):
	if is_attacking:
		return
	
	is_attacking = true
	calculate_damage()
	var player_melee_attack_instance = player_melee_attack.instantiate()
	player_sprite.add_child(player_melee_attack_instance)
	player_melee_attack_instance.set_damage(current_damage)
	player_melee_attack_instance.set_faction(GameData.Factions.SHADOW)
	player_melee_attack_instance.finished.connect(on_finished)
	player_melee_attack_instance.attack()
	
	audio_stream_player.play()
	
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


func calculate_damage():
	current_damage = melee_attack_damage + (melee_attack_damage * damage_multiplier)


func set_damage_multiplier(num: float):
	damage_multiplier = num


func on_finished():
	is_attacking = false
