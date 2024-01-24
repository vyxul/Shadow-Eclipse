extends Area2D
class_name HurtboxComponent

signal hurt

@export var health_component : HealthComponent
var conversionComponent = null

func GetConversionComponent() -> ConversionComponent:
	return conversionComponent

func SetConversionComponent(_ConversionComponent):
	conversionComponent = _ConversionComponent

func damage(dmg: int):
	if !health_component:
		return

	health_component.damage(dmg)
	hurt.emit()
