extends CanvasLayer

@onready var TotalDarknessLabel = $"TotalDarkness"
@onready var ExtraHealthCostLabel = $ExtraHealthCost
@onready var ExtraManaCostLabel = $ExtraManaCost
@onready var ExtraAttackCostLabel = $ExtraAttackCost
@onready var ExtraMinionsCostLabel = $ExtraMinionCost

@onready var BuyExtraHealthButton = $BuyExtraHealth
@onready var BuyExtraManaButton = $BuyExtraMana
@onready var BuyExtraAttackButton = $BuyExtraAttack
@onready var BuyExtraMinionsButton = $BuyExtraMinion

signal ShopClosed

func _ready():
	UpdateAllLabels()
	PostBuyUpdate()

func PostBuyUpdate():
	TotalDarknessLabel.text = str(GameData.GetDarkness())
	UpdateButtons()

func UpdateButtons():
	var TotalDarkenss = GameData.GetDarkness()
	
	var HealthCost = GameData.GetExtraHealthCost()
	if HealthCost < -1 || TotalDarkenss > HealthCost:
		BuyExtraHealthButton.disabled = true
		
	var ManaCost = GameData.GetExtraManaCost()
	if ManaCost < -1 || TotalDarkenss > ManaCost:
		BuyExtraManaButton.disabled = true
		
	var MinionsCost = GameData.GetExtraMinionsCost()
	if MinionsCost < -1 || TotalDarkenss > MinionsCost:
		BuyExtraMinionsButton.disabled = true
		
	var DamagePercentCost = GameData.GetExtraDamageCost()
	if DamagePercentCost < -1 || TotalDarkenss > DamagePercentCost:
		BuyExtraAttackButton.disabled = true
	
func UpdateAllLabels():
	UpdateExtraHealthCostLabel()
	UpdateExtraManaCostLabel()
	UpdateExtraAttackCostLabel()
	UpdateExtraMinionsCostLabel()

func UpdateExtraHealthCostLabel():
	var HealthCost = GameData.GetExtraHealthCost()
	if HealthCost > -1:
		ExtraHealthCostLabel.text  = str(HealthCost)
	else:
		ExtraHealthCostLabel.text  = "Maxed"

func UpdateExtraManaCostLabel():
	var ManaCost = GameData.GetExtraManaCost()
	if ManaCost > -1:
		ExtraManaCostLabel.text  = str(ManaCost)
	else:
		ExtraManaCostLabel.text  = "Maxed"
	
func UpdateExtraAttackCostLabel():
	var ExtraAttackCost = GameData.GetExtraDamageCost()
	if ExtraAttackCost > -1:
		ExtraAttackCostLabel.text  = str(ExtraAttackCost)
	else:
		ExtraAttackCostLabel.text  = "Maxed"
	
func UpdateExtraMinionsCostLabel():
	var ExtraMinionsCost = GameData.GetExtraMinionsCost()
	if ExtraMinionsCost > -1:
		ExtraMinionsCostLabel.text  = str(ExtraMinionsCost)
	else:
		ExtraMinionsCostLabel.text  = "Maxed"


func _on_buy_extra_health_pressed():
	var TotalDarkness = GameData.GetDarkness()
	var NextHealthCost = GameData.GetExtraHealthCost()
	if TotalDarkness >= NextHealthCost:
		GameData.InreaseMaxHealth()
		GameData.DecreaseDarkness(NextHealthCost)
		UpdateExtraHealthCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Health")


func _on_buy_extra_mana_pressed():
	var TotalDarkness = GameData.GetDarkness()
	var NextManaCost = GameData.GetExtraManaCost()
	if TotalDarkness >= NextManaCost:
		GameData.InreaseMaxMana()
		GameData.DecreaseDarkness(NextManaCost)
		UpdateExtraManaCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Mana")


func _on_buy_extra_attack_pressed():
	PostBuyUpdate()
	var TotalDarkness = GameData.GetDarkness()
	var NextDamagePercentCost = GameData.GetExtraDamageCost()
	if TotalDarkness >= NextDamagePercentCost:
		GameData.InreaseMaxDamagePercent()
		GameData.DecreaseDarkness(NextDamagePercentCost)
		UpdateExtraAttackCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more DamagePercent")


func _on_buy_extra_minion_pressed():
	var TotalDarkness = GameData.GetDarkness()
	var NextMinionsCost = GameData.GetExtraMinionsCost()
	if TotalDarkness >= NextMinionsCost:
		GameData.InreaseMaxMinions()
		GameData.DecreaseDarkness(NextMinionsCost)
		UpdateExtraMinionsCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Minions")


func _on_continue_pressed():
	SaveAndLoad.SaveData.emit()
	hide()
	ShopClosed.emit()
