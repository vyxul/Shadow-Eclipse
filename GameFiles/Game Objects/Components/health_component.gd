extends Node
class_name HealthComponent

signal health_depleted
signal health_lost(healthDecrease : float)

@export var max_health_points: float = 1
@export var current_health_points: float = 1
@export var start_full_hp: bool = true

func _ready():
	if start_full_hp:
		current_health_points = max_health_points


func check_hp_in_range():
	# forcibly set current_health_points to be within acceptable range
	current_health_points = clamp(current_health_points, 0, max_health_points)
	
	if current_health_points == 0:
		health_depleted.emit()


func damage(dmg: float):
	if dmg <= 0:
		return
	
	current_health_points -= dmg
	health_lost.emit(dmg)
	
	check_hp_in_range()


func set_max_hp(num: float):
	max_health_points = num
	current_health_points = num
