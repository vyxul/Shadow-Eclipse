extends Node

signal follow_target_set(follow_target_position: Vector2)

enum Factions {SHADOW, LIGHT, MONSTER}


func is_faction_ally(faction_1: Factions, faction_2: Factions): 
	if faction_1 == faction_2:
		return true
	else:
		return false
