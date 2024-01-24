extends Node2D

class_name DarknessTile

signal TileDestroyed(_Tile : Node2D)
signal TileReceivedDamage(_damage : int)
@onready var  AnimSprite = $AnimatedSprite2D
var Coordinates : int = 0

func _ready():
	AnimSprite.frame = randi_range(0, 3)

func SetCoordinates(_coordinates):
	Coordinates = _coordinates
	
func GetCoordinates() -> int:
	return Coordinates

func _on_health_component_health_lost(damage):
	TileReceivedDamage.emit(damage)

func ShowBehindParent():
	show_behind_parent = true

func _on_health_component_health_depleted():
	TileDestroyed.emit(self)

func _on_hurtbox_component_hurt():
	pass # Replace with function body.