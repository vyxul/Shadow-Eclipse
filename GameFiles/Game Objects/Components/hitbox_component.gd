extends Area2D
class_name HitboxComponent

signal wall_hit
signal enemy_hit

func _on_area_entered(area):
	if area is HurtboxComponent:
		var this_faction = get_parent().get_faction()
		var that_faction = area.get_faction()
		if !GameData.is_faction_ally(this_faction, that_faction):
			var weapon_damage = owner.get_damage()
			area.damage(weapon_damage)
			enemy_hit.emit()
