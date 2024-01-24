extends CharacterBody2D
class_name NonPlayerCharacter

@export var faction: GameData.Factions
@export var kill_score: int = 1

@onready var marker_2d = $Marker2D
@export var animation_player: AnimationPlayer
@onready var conversion_component: ConversionComponent = $ConversionComponent
@onready var hurtboxComponent: HurtboxComponent = $HurtboxComponent


func _ready():
	hurtboxComponent.SetConversionComponent(conversion_component)

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


func get_npc_attack_component() -> NpcAttackComponent:
	return $NpcAttackComponent


func get_search_radius() -> SearchRadius:
	return $SearchRadius


func get_weapon_origin():
	return marker_2d.global_position


func _on_mouse_entered():
	if faction != GameData.Factions.SHADOW:
		GameData.add_target_under_mouse(self)


func _on_mouse_exited():
	GameData.remove_target_under_mouse(self)
