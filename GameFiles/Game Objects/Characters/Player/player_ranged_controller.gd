extends Node2D

@onready var player_range_attack = preload("res://GameFiles/Game Objects/Characters/Player/player_ranged_attack.tscn")
@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer

@export var mana_component: ManaComponent
@export_range(100, 2000) var projectile_speed: float = 100
@export_range(.1, 10) var projectile_time: float = 5
@export_range(1, 999) var range_attack_damage: int = 1
@export_range(1, 999) var range_attack_pierce_limit: int = 1
@export var attack_cooldown: float = .2
@export var mana_cost: float = 4

var is_attacking: bool = false
var damage_multiplier: float = 0
var current_damage: float = 0

func attack():
	if is_attacking:
		return
	
	var enough_mana = mana_component.get_current_mana() >= mana_cost
	if !enough_mana:
		return
		
	mana_component.use(mana_cost)
	
	is_attacking = true
	calculate_damage()
	timer.wait_time = attack_cooldown
	timer.start()
	
	var player_range_attack_instance = player_range_attack.instantiate()
	var projectiles_layer = get_tree().get_first_node_in_group("projectiles")
	projectiles_layer.add_child(player_range_attack_instance)
	
	player_range_attack_instance.set_projectile_speed(projectile_speed)
	player_range_attack_instance.set_projectile_time(projectile_time)
	player_range_attack_instance.set_damage(current_damage)
	player_range_attack_instance.set_pierce_limit(range_attack_pierce_limit)
	player_range_attack_instance.set_faction(GameData.Factions.SHADOW)
	
	player_range_attack_instance.attack()
	
	audio_stream_player.play()
	
	var player = get_parent()
	var animation_player = player.animation_player
	animation_player.play("attack", -1, 2)
	var attack_direction = get_global_mouse_position() - player.global_position
	if attack_direction.x < 0:
		player.sprite_2d.flip_h = true
		player.direction = -1
	elif attack_direction.x > 0:
		player.sprite_2d.flip_h = false
		player.direction = 1


func calculate_damage():
	current_damage = range_attack_damage + (range_attack_damage * damage_multiplier)


func set_damage_multiplier(num: float):
	damage_multiplier = num


func _on_timer_timeout():
	is_attacking = false
