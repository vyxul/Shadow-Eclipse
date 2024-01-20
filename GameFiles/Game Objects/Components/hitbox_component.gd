extends Area2D
class_name HitboxComponent

signal enemy_hit

func _on_area_entered(area):
	if area is HurtboxComponent:
		var weapon_damage = owner.get_damage()
		area.damage(weapon_damage)
		enemy_hit.emit()
