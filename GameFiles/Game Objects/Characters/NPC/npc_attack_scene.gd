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


func set_attack_position(this_entity: NonPlayerCharacter, direction: Vector2):
	var entity_position = this_entity.get_weapon_origin() as Vector2
	var weapon_position = entity_position + (direction * extension_range)
	var weapon_angle = direction.angle()
	print_debug("weapon_angle = " + str(weapon_angle))
	global_position = weapon_position
	rotation = weapon_angle + (PI/2)
	#rotation = weapon_angle
	print_debug("rotation = " + str(rad_to_deg(rotation)))


func attack(this_entity: NonPlayerCharacter, target: CharacterBody2D):
	var entity_position = this_entity.get_weapon_origin() as Vector2
	var target_direction = entity_position.direction_to(target.position)
	#var target_direction = target.position.direction_to(entity_position)
	set_attack_position(this_entity, target_direction)
	var animation_player = $AnimationPlayer as AnimationPlayer
	animation_player.play("attack")


func attack_direction(this_entity: NonPlayerCharacter, direction: Vector2):
	set_attack_position(this_entity, direction)
	var animation_player = $AnimationPlayer as AnimationPlayer
	animation_player.play("attack")
	


func emit_finished():
	finished.emit()
