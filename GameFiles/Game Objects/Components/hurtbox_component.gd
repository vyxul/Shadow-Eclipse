extends Area2D
class_name HurtboxComponent

signal hurt

@export var health_component : HealthComponent
var conversionComponent = null

func get_conversion_component() -> ConversionComponent:
	return conversionComponent

func set_conversion_component(_ConversionComponent):
	conversionComponent = _ConversionComponent

func damage(dmg: int):
	if !health_component:
		return

	health_component.damage(dmg)
	hurt.emit()


func get_faction() -> GameData.Factions:
	return get_parent().get_faction()
