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
signal OpenShop

func _ready():
	OpenShop.connect(Open_Shop)
	
func Open_Shop():
	UpdateAllLabels()
	PostBuyUpdate()
	show()
	
func GetGameData() -> Persiststant_Game_Data:
	return GameData.GetPersistantGameData()
	
func PostBuyUpdate():
	TotalDarknessLabel.text = str(GetGameData().GetDarkness())
	UpdateButtons()

func UpdateButtons():
	var TotalDarkenss = GetGameData().GetDarkness()
	
	var HealthCost = GetGameData().GetExtraHealthCost()
	if HealthCost < -1 || TotalDarkenss < HealthCost:
		BuyExtraHealthButton.disabled = true
	else:
		BuyExtraHealthButton.disabled = false
		
		
	var ManaCost = GetGameData().GetExtraManaCost()
	if ManaCost < -1 || TotalDarkenss < ManaCost:
		BuyExtraManaButton.disabled = true
	else:
		BuyExtraManaButton.disabled = false
		
	var MinionsCost = GetGameData().GetExtraMinionsCost()
	if MinionsCost < -1 || TotalDarkenss < MinionsCost:
		BuyExtraMinionsButton.disabled = true
	else:
		BuyExtraMinionsButton.disabled = false
		
	var DamagePercentCost = GetGameData().GetExtraDamageCost()
	if DamagePercentCost < -1 || TotalDarkenss < DamagePercentCost:
		BuyExtraAttackButton.disabled = true
	else:
		BuyExtraAttackButton.disabled = false
	
func UpdateAllLabels():
	UpdateExtraHealthCostLabel()
	UpdateExtraManaCostLabel()
	UpdateExtraAttackCostLabel()
	UpdateExtraMinionsCostLabel()

func UpdateExtraHealthCostLabel():
	var HealthCost = GetGameData().GetExtraHealthCost()
	if HealthCost > -1:
		ExtraHealthCostLabel.text  = str(HealthCost)
	else:
		ExtraHealthCostLabel.text  = "Maxed"

func UpdateExtraManaCostLabel():
	var ManaCost = GetGameData().GetExtraManaCost()
	if ManaCost > -1:
		ExtraManaCostLabel.text  = str(ManaCost)
	else:
		ExtraManaCostLabel.text  = "Maxed"
	
func UpdateExtraAttackCostLabel():
	var ExtraAttackCost = GetGameData().GetExtraDamageCost()
	if ExtraAttackCost > -1:
		ExtraAttackCostLabel.text  = str(ExtraAttackCost)
	else:
		ExtraAttackCostLabel.text  = "Maxed"
	
func UpdateExtraMinionsCostLabel():
	var ExtraMinionsCost = GetGameData().GetExtraMinionsCost()
	if ExtraMinionsCost > -1:
		ExtraMinionsCostLabel.text  = str(ExtraMinionsCost)
	else:
		ExtraMinionsCostLabel.text  = "Maxed"


func _on_buy_extra_health_pressed():
	var TotalDarkness = GetGameData().GetDarkness()
	var NextHealthCost = GetGameData().GetExtraHealthCost()
	if TotalDarkness >= NextHealthCost:
		GetGameData().InreaseMaxHealth()
		GetGameData().DecreaseDarkness(NextHealthCost)
		UpdateExtraHealthCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Health")


func _on_buy_extra_mana_pressed():
	var TotalDarkness = GetGameData().GetDarkness()
	var NextManaCost = GetGameData().GetExtraManaCost()
	if TotalDarkness >= NextManaCost:
		GetGameData().InreaseMaxMana()
		GetGameData().DecreaseDarkness(NextManaCost)
		UpdateExtraManaCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Mana")


func _on_buy_extra_attack_pressed():
	PostBuyUpdate()
	var TotalDarkness = GetGameData().GetDarkness()
	var NextDamagePercentCost = GetGameData().GetExtraDamageCost()
	if TotalDarkness >= NextDamagePercentCost:
		GetGameData().InreaseMaxDamagePercent()
		GetGameData().DecreaseDarkness(NextDamagePercentCost)
		UpdateExtraAttackCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more DamagePercent")


func _on_buy_extra_minion_pressed():
	var TotalDarkness = GetGameData().GetDarkness()
	var NextMinionsCost = GetGameData().GetExtraMinionsCost()
	if TotalDarkness >= NextMinionsCost:
		GetGameData().InreaseMaxMinions()
		GetGameData().DecreaseDarkness(NextMinionsCost)
		UpdateExtraMinionsCostLabel()
		PostBuyUpdate()
	else:
		print("Not enough Darkness to buy more Minions")


func _on_continue_pressed():
	SaveAndLoad.SaveData.emit()
	hide()
	ShopClosed.emit()
