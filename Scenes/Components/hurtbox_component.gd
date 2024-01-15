extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent


func damage(dmg: int):
	if !health_component:
		return

	health_component.damage(dmg)
