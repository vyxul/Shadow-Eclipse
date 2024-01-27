extends Control

class_name PlayerMinion

@onready var EmptyMinionSlotOverlay = $OccoupiedMinionSlot/EmptyMinionSlot
@onready var OccoupiedMinionSlot = $OccoupiedMinionSlot


func set_minion_slot_occupied():
	EmptyMinionSlotOverlay.visible = false

func set_minion_slot_empty():
	EmptyMinionSlotOverlay.visible = true
	
func set_invisible():
	OccoupiedMinionSlot.visible = false
	EmptyMinionSlotOverlay.visible = false
