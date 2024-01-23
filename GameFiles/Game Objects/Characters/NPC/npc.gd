extends CharacterBody2D
class_name NonPlayerCharacter

@export var faction: GameData.Factions

@export var animation_player: AnimationPlayer


func _process(delta):
	move_and_slide()


func get_faction() -> int:
	return faction


func get_animation_player() -> AnimationPlayer:
	return animation_player


func get_navigation_agent() -> NavigationAgent2D:
	return $NavigationAgent2D


func get_navigation_timer() -> Timer:
	return $NavigationTimer


func get_conversion_component() -> ConversionComponent:
	return $ConversionComponent
