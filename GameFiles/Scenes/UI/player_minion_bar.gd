extends Control

signal MinionConverted
signal MinionDied

const maxnumberofminions = 15
const minions_inUpper_Slots = 9

var current_number_minions: int = 0
var current_max_minions

@onready var Minions = [$PlayerMinion1, $PlayerMinion2, $PlayerMinion3, $PlayerMinion4, $PlayerMinion5, $PlayerMinion6, $PlayerMinion7, $PlayerMinion8, $PlayerMinion9, $PlayerMinion10, $PlayerMinion11, $PlayerMinion12, $PlayerMinion13, $PlayerMinion14, $PlayerMinion15]

func _ready():
	
	GameData.npc_converted.connect(OnMinionConvered)
	GameData.follower_died.connect(OnMinionDied)
		
	current_max_minions = GameData.GetPersistantGameData().MaxMinions
		
	var id = 0
	for Minion in Minions:
		if id < current_max_minions:
			Minion.set_minion_slot_empty()
		else:
			Minion.set_invisible()
		id += 1
			

func OnMinionConvered(npc: NonPlayerCharacter):
	Minions[current_number_minions].set_minion_slot_occupied()
	current_number_minions += 1
	

func OnMinionDied(npc: NonPlayerCharacter):
	current_number_minions -= 1
	Minions[current_number_minions].set_minion_slot_empty()
