extends CharacterBody2D
class_name NonPlayerCharacter

@export var faction: GameData.Factions


func _process(delta):
	move_and_slide()


func get_faction() -> int:
	return faction
