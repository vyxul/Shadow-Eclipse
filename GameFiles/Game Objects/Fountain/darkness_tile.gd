extends Node2D

class_name DarknessTile

signal TileDestroyed(_Tile : Node2D)
signal TileReceivedDamage(_damage : int)

var Coordinates : int = 0

func SetCoordinates(_coordinates):
	Coordinates = _coordinates
	
func GetCoordinates(_coordinates) -> int:
	return Coordinates

func _on_health_component_health_lost(damage):
	TileReceivedDamage.emit(damage)

func ShowBehindParent():
	show_behind_parent = true

func _on_health_component_health_depleted():
	TileDestroyed.emit(self)


func _on_hurtbox_component_hurt():
	pass # Replace with function body.
