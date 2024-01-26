extends Control

class_name PlayerMinion

@onready var EmptyMinionSlotOverlay = $OccoupiedMinionSlot/EmptyMinionSlot


func set_minion_slot_occupied():
	EmptyMinionSlotOverlay.visible = false

func set_minion_slot_empty():
	EmptyMinionSlotOverlay.visible = true
	
