extends Area2D
class_name HitboxComponent


func _on_area_entered(area):
	if area is HurtboxComponent:
		var weapon_damage = owner.get_damage()
		area.damage(weapon_damage)
