extends CharacterBody2D
class_name NonPlayerCharacter

@export var faction: GameData.Factions
@export var attack_component: NpcAttackComponent

@onready var marker_2d = $Marker2D

func _process(delta):
	move_and_slide()


func get_faction() -> int:
	return faction


func get_sprite() -> Sprite2D:
	return $Sprite2D


func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer


func get_navigation_agent() -> NavigationAgent2D:
	return $NavigationAgent2D


func get_navigation_timer() -> Timer:
	return $NavigationTimer


func get_conversion_component() -> ConversionComponent:
	return $ConversionComponent


func get_weapon_origin():
	return marker_2d.global_position
