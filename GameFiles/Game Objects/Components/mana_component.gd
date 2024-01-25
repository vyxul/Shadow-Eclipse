extends Node
class_name ManaComponent

signal mana_depleted
signal mana_lost

@export var max_mana_points: float = 0
@export var current_mana_points: float = 0
@export var start_mana_hp: bool = true

func _ready():
	if start_mana_hp:
		current_mana_points = max_mana_points


func check_mana_in_range():
	# forcibly set current_mana_points to be within acceptable range
	current_mana_points = clamp(current_mana_points, 0, max_mana_points)
	
	if current_mana_points == 0:
		mana_depleted.emit()


func use(mana_used: float):
	if mana_used <= 0:
		return
	
	current_mana_points -= mana_used
	mana_lost.emit()
	
	check_mana_in_range()
