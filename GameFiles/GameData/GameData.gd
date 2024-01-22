extends Node

signal player_health_changed(player_current_health, player_max_health)
signal player_mana_changed(player_current_mana, player_max_mana)
signal player_died
signal player_mana_empty

signal player_hp_ui_ready
signal player_mp_ui_ready

enum Factions {SHADOW, LIGHT, MONSTER}


func is_faction_ally(faction_1: Factions, faction_2: Factions): 
	if faction_1 == faction_2:
		return true
	else:
		return false
