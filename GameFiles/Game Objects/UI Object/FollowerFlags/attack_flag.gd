extends Node2D

var attack_target: NonPlayerCharacter


func _ready():
	GameData.npc_died.connect(on_npc_died)


func _process(delta):
	global_position = attack_target.global_position


func on_npc_died(npc: NonPlayerCharacter):
	if attack_target == npc:
		queue_free()
