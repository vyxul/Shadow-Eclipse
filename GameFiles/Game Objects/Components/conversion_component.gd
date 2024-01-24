extends Node
class_name ConversionComponent

signal conversion_hp_depleted
signal conversion_hp_lost(max_hp, current_hp, dmg)
signal no_follow_slot_available(entity: NonPlayerCharacter)
signal new_follower_added(entity: NonPlayerCharacter)

@export var max_conversion_hp: int = 1
@export var current_conversion_hp: int = 1
@export var start_at_max_conversion_hp: bool = true
@export var CanParentBecomeFollower: bool = true

var converted: bool = false

var this_entity: Node2D
var this_search_radius: SearchRadius
var player: Player
var follow_marker: Marker2D

func _ready():
	if start_at_max_conversion_hp:
		current_conversion_hp = max_conversion_hp
	
	this_entity = get_parent()
	this_search_radius = this_entity.get_search_radius()


func check_conversion_hp_in_range():
	current_conversion_hp = clamp(current_conversion_hp, 0, max_conversion_hp)
	
	if current_conversion_hp == 0:
		converted = true
		conversion_hp_depleted.emit()
		player = get_tree().get_first_node_in_group("player") as Player
		follow_marker = player.get_empty_follower_slot()
		this_entity.faction = GameData.Factions.SHADOW
		this_entity.collision_layer = 8
		GameData.emit_npc_converted(this_entity)
		
		if CanParentBecomeFollower:
			if !follow_marker:
				no_follow_slot_available.emit(this_entity)
			
			else:
				player.set_follower_slot(follow_marker, this_entity)
				new_follower_added.emit(this_entity)


func conversion_damage(convert_dmg: int):
	if converted:
		return
	
	if convert_dmg <= 0:
		return
	
	current_conversion_hp -= convert_dmg
	conversion_hp_lost.emit(max_conversion_hp, current_conversion_hp, convert_dmg)
	check_conversion_hp_in_range()
