extends Node2D
class_name NpcAttackScene

signal finished

const extension_range = 8

var attack_damage: int = 0
var attack_faction: GameData.Factions


func set_damage(dmg: int):
	attack_damage = dmg


func get_damage():
	return attack_damage


func set_faction(faction: GameData.Factions):
	attack_faction = faction


func get_faction() -> GameData.Factions:
	return attack_faction


func set_attack_position(this_entity: NonPlayerCharacter, target: CharacterBody2D):
	var entity_position = this_entity.get_weapon_origin() as Vector2
	var weapon_direction = entity_position.direction_to(target.position)
	var weapon_position = entity_position + (weapon_direction * extension_range)
	var weapon_angle = weapon_direction.angle()
	global_position = weapon_position
	rotation = weapon_angle + (PI/2)


func attack(this_entity: NonPlayerCharacter, target: CharacterBody2D):
	set_attack_position(this_entity, target)
	var animation_player = $AnimationPlayer as AnimationPlayer
	animation_player.play("attack")


func emit_finished():
	finished.emit()
