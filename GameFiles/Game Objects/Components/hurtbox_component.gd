extends Area2D
class_name HurtboxComponent

signal hurt

@export var health_component : HealthComponent


func damage(dmg: int):
	if !health_component:
		return

	health_component.damage(dmg)
	hurt.emit()
