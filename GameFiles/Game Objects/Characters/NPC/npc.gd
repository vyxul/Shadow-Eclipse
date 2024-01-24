extends CharacterBody2D
class_name NonPlayerCharacter

@export var faction: GameData.Factions

@export var animation_player: AnimationPlayer
@onready var conversion_component: ConversionComponent = $ConversionComponent
@onready var hurtboxComponent: HurtboxComponent = $HurtboxComponent


func _ready():
	hurtboxComponent.SetConversionComponent(conversion_component)

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
