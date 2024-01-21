extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var timer = $Timer

const extension_range = 16

var projectile_direction: Vector2
var projectile_speed: float
var projectile_time: float

var range_attack_damage: int = 0
var range_attack_pierce_limit: int = 1
var current_pierce_count: int = 0


func set_projectile_speed(number: float):
	var new_projectile_speed = max(100, number)
	projectile_speed = new_projectile_speed


func set_projectile_time(number: float):
	var new_projectile_time = max(1, number)
	projectile_time = new_projectile_time


func set_damage(number: int):
	var new_range_attack_damage = max(1, number)
	range_attack_damage = new_range_attack_damage


func set_pierce_limit(number: int):
	var pierce_limit = max(1, number)
	range_attack_pierce_limit = pierce_limit


func get_damage():
	return range_attack_damage


func set_attack_position():
	var player = get_tree().get_first_node_in_group("player")
	var player_position = player.get_weapon_origin() as Vector2
	projectile_direction = player_position.direction_to(get_global_mouse_position())
	var projectile_position = player_position + (projectile_direction * extension_range)
	var weapon_angle = projectile_direction.angle()
	
	global_position = projectile_position
	rotation = weapon_angle + (PI/2)


func attack():
	set_attack_position()
	velocity = projectile_direction * projectile_speed
	timer.wait_time = projectile_time
	timer.start()


func despawn():
	queue_free()


func _ready():
	hitbox_component.enemy_hit.connect(on_enemy_hit)
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	move_and_slide()


func on_enemy_hit():
	current_pierce_count += 1
	if current_pierce_count >= range_attack_pierce_limit:
		despawn()


func on_timer_timeout():
	despawn()
