extends Node

signal follow_target_set
signal follow_player
signal attack_target_command
signal npc_died(npc: NonPlayerCharacter)
signal npc_converted(npc: NonPlayerCharacter)
signal player_health_changed(player_current_health, player_max_health)
signal player_mana_changed(player_current_mana, player_max_mana)
signal player_died
signal player_mana_empty

signal player_hp_ui_ready
signal player_mp_ui_ready
signal follow_target_set(follow_target_position: Vector2)

enum Factions {SHADOW, LIGHT, MONSTER}

var targets_under_mouse: Array
var follow_target_position
var attack_target: NonPlayerCharacter
var player_score: int

func is_faction_ally(faction_1: Factions, faction_2: Factions): 
	if faction_1 == faction_2:
		return true
	else:
		return false


func emit_follow_target(new_follow_target_position: Vector2):
	follow_target_position = new_follow_target_position
	follow_target_set.emit()


func emit_follow_player():
	follow_player.emit()


func emit_attack_target_command():
	attack_target_command.emit()


func emit_npc_died(npc: NonPlayerCharacter):
	npc_died.emit(npc)


func emit_npc_converted(npc: NonPlayerCharacter):
	npc_converted.emit(npc)


func add_target_under_mouse(target: NonPlayerCharacter):
	if targets_under_mouse.has(target):
		return
	
	targets_under_mouse.append(target)


func remove_target_under_mouse(target: NonPlayerCharacter):
	targets_under_mouse.erase(target)


func closest_target_to_mouse(mouse_position: Vector2):
	var closest_target = targets_under_mouse[0]
	var closest_distance = (closest_target.global_position - mouse_position).length()
	
	for index in range(1, targets_under_mouse.size()):
		var current_target = targets_under_mouse[index]
		var distance = (current_target.global_position - mouse_position).length()
		if distance < closest_distance:
			closest_target = current_target
			closest_distance = distance
	
	return closest_target


func set_attack_target(target: NonPlayerCharacter):
	attack_target = target


func get_attack_target() -> NonPlayerCharacter:
	return attack_target


func add_score(score: int):
	player_score += score
