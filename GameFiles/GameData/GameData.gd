extends Node

enum Factions {SHADOW, LIGHT, MONSTER}


func is_faction_ally(faction_1: Factions, faction_2: Factions): 
	if faction_1 == faction_2:
		return true
	else:
		return false