extends Area2D
class_name NpcAttackComponent

signal attack_finished

@export var attack_scene: PackedScene

@export var attack_damage: int = 1

@onready var this_entity: NonPlayerCharacter = get_parent()

var attack_set: bool = false


func _ready():
	if attack_scene:
		attack_set = true


func attack(target: CharacterBody2D):
	if attack_set:
		#print_debug("npc attacking")
		var attack_scene_instance = attack_scene.instantiate()
		add_child(attack_scene_instance)
		attack_scene_instance.set_damage(attack_damage)
		attack_scene_instance.set_faction(this_entity.faction)
		attack_scene_instance.attack(this_entity, target)
		await attack_scene_instance.finished
		attack_finished.emit()


func attack_direction(direction: Vector2):
	if attack_set:
		var attack_scene_instance = attack_scene.instantiate()
		add_child(attack_scene_instance)
		attack_scene_instance.set_damage(attack_damage)
		attack_scene_instance.set_faction(this_entity.faction)
		attack_scene_instance.attack_direction(this_entity, direction)
		await attack_scene_instance.finished
		attack_finished.emit()


func is_body_in_attack_range(body: CharacterBody2D):
	var overlapping_bodies = get_overlapping_bodies()
	return overlapping_bodies.has(body)
