extends Resource

class_name Persiststant_Game_Data
const inf : int = -1

var ExtraMaxHealthCost =     [  0,   0,  10, 100, 100, 150, 200,  300,  400,  500,  500,   600,  750, 1000, 1500, inf]
var ExtraMaxManaCost =       [  0,   0,  10,  50,  50, 100, 150,  200,  300,  400,  500,   600,  750, 1000, 1500, inf]
var ExtraDamagePercentCost = [150, 250, 300, 450, 600, 800, 900, 1000, 1100, 1200, 1300,  1400, 1500, 1750, 2000, inf]
var ExtraMaxMinionsCost =    [  0,   0,   0, 100, 200, 300, 400,  500,  600,  700,  800,   900, 1000, 1200, 1500, inf]

@export var Darkness = 0
@export var MaxHealth  = 2
@export var MaxMana = 2
@export var MaxDamage = 0
@export var MaxMinions = 2

func InreaseMaxHealth():
	MaxHealth += 1

func SetMaxHealth(maxHealth : int):
	MaxHealth = maxHealth

func GetMaxHealth() -> int:
	return MaxHealth

func InreaseMaxMana():
	MaxMana += 1
	
func SetMaxMana(maxMana : int):
	MaxMana = maxMana

func GetMaxMana() -> int:
	return MaxMana
	
func InreaseMaxDamagePercent():
	MaxDamage += 1

func GetDamagePercent() -> int:
	return MaxDamage
	
func SetDamagePercent(_MaxDamage : int):
	MaxDamage = _MaxDamage
	
func InreaseMaxMinions():
	MaxMinions += 1
	
func SetMaxMinions(maxMinions : int):
	MaxMinions = maxMinions

func GetMaxMinion() -> int:
	return MaxMinions

func SetDarkness(_Darkness : int):
	Darkness = _Darkness	
	
func IncreaseDarkness(_Darkness : int):
	Darkness += _Darkness
	
func DecreaseDarkness(_Darkness : int):
	Darkness -= _Darkness

func GetDarkness() -> int:
	return Darkness

func GetExtraHealthCost() -> int:
	return ExtraMaxHealthCost[MaxHealth]
	

func GetExtraManaCost() -> int:
	return ExtraMaxManaCost[MaxMana]
	

func GetExtraDamageCost() -> int:
	return ExtraDamagePercentCost[MaxDamage]
	

func GetExtraMinionsCost() -> int:
	return ExtraMaxMinionsCost[MaxMinions]
