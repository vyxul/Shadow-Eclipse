extends Node
class_name ManaComponent

signal mana_depleted
signal mana_changed

@onready var timer = $Timer

@export var max_mana_points: float = 0
@export var current_mana_points: float = 0
@export var start_mana_hp: bool = true
@export var mana_regen_timer: float = 1
@export var mana_regen_amount: float = 1

func _ready():
	if start_mana_hp:
		current_mana_points = max_mana_points
		
	timer.wait_time = mana_regen_timer


func check_mana_in_range():
	# forcibly set current_mana_points to be within acceptable range
	current_mana_points = clamp(current_mana_points, 0, max_mana_points)
	
	if current_mana_points == 0:
		mana_depleted.emit()

	if current_mana_points == max_mana_points:
		timer.stop()

func use(mana_used: float):
	if mana_used <= 0:
		return
	
	current_mana_points -= mana_used
	mana_changed.emit()
	
	check_mana_in_range()
	timer.start()


func regain():
	current_mana_points += mana_regen_amount
	check_mana_in_range()
	mana_changed.emit()


func get_current_mana() -> float:
	return current_mana_points


func _on_timer_timeout():
	regain()
	print_debug("test")
