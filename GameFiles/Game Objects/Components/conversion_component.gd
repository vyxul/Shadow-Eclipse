extends Node
class_name ConversionComponent

signal conversion_hp_depleted
signal conversion_hp_lost(max_hp, current_hp, dmg)

@export var max_conversion_hp: int = 1
@export var current_conversion_hp: int = 1
@export var start_at_max_conversion_hp: bool = true


func _ready():
	if start_at_max_conversion_hp:
		current_conversion_hp = max_conversion_hp


func check_conversion_hp_in_range():
	current_conversion_hp = clamp(current_conversion_hp, 0, max_conversion_hp)
	
	if current_conversion_hp == 0:
		conversion_hp_depleted.emit()


func conversion_damage(convert_dmg: int):
	if convert_dmg <= 0:
		return
	
	current_conversion_hp -= convert_dmg
	conversion_hp_lost.emit(max_conversion_hp, current_conversion_hp, convert_dmg)
	check_conversion_hp_in_range()
