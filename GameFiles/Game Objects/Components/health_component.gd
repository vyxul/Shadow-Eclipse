extends Node
class_name HealthComponent

signal health_depleted
signal health_lost

@export var max_health_points: int = 1
@export var current_health_points: int = 1


func check_hp_in_range():
	# forcibly set current_health_points to be within acceptable range
	current_health_points = clamp(current_health_points, 0, max_health_points)
	
	if current_health_points == 0:
		health_depleted.emit()


func damage(dmg: int):
	if dmg <= 0:
		return
	
	current_health_points -= dmg
	health_lost.emit()
	
	check_hp_in_range()
