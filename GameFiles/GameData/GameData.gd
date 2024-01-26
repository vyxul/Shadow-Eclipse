extends Node

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

const inf : int = -1

var ExtraMaxHealthCost =     [0,   0,    10, 100, 100, 150, 200,  300,  400,  500,  500,   600,  750, 1000, 1500, inf]
var ExtraMaxManaCost =       [0,   0,    10,  50,  50, 100, 150,  200,  300,  400,  500,   600,  750, 1000, 1500, inf]
var ExtraDamagePercentCost = [150, 250, 300, 450, 600, 800, 900, 1000, 1100, 1200, 1300,  1400, 1500, 1750, 2000, inf]
var ExtraMaxMinionsCost =     [0,   0,    0, 100, 200, 300, 400,  500,  600,  700,  800,   900, 1000, 1200, 1500, inf]

var Darkness : int = 0
var MaxHealth  : int = 0
var MaxMana : int = 0
var MaxDamage : int = 0
var MaxMinions : int = 0

var targets_under_mouse: Array
var follow_target_position
var attack_target: NonPlayerCharacter
var player_score: int
const TileSize = 32

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


func GetGameTileSize() -> int:
	return TileSize


func GetPlayerScore() -> int:
	return player_score


func reset():
	targets_under_mouse.clear()
	follow_target_position = null
	attack_target = null


func InreaseMaxHealth():
	MaxHealth += 1

func SetMaxHealth(maxHealth):
	MaxHealth = maxHealth

func GetMaxHealth() -> int:
	return MaxHealth

func InreaseMaxMana():
	MaxMana += 1
	
func SetMaxMana(maxMana):
	MaxMana = maxMana

func GetMaxMana() -> int:
	return MaxMana
	
func InreaseMaxDamagePercent():
	MaxDamage += 1

func GetDamagePercent() -> int:
	return MaxDamage
	
func SetDamagePercent(_MaxDamage):
	MaxDamage = _MaxDamage
	
func InreaseMaxMinions():
	MaxMinions += 1
	
func SetMaxMinions(maxMinions):
	MaxMinions = maxMinions

func GetMaxMinion() -> int:
	return MaxMinions

func SetDarkness(_Darkness):
	Darkness = _Darkness	
	
func IncreaseDarkness(_Darkness):
	Darkness += _Darkness
	
func DecreaseDarkness(_Darkness):
	Darkness -= _Darkness

func GetDarkness() -> int:
	return Darkness

func GetExtraHealthCost() -> int:
	return ExtraMaxHealthCost[MaxHealth]
	

func GetExtraManaCost() -> int:
	return ExtraMaxManaCost[MaxMana]
	

func GetExtraDamageCost() -> int:
	return ExtraDamagePercentCost[MaxDamage]
	

func GetExtraMinionsCost() -> int:
	return ExtraMaxMinionsCost[MaxMinions]
