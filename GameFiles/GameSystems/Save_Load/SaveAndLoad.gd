extends Node

signal SaveData
signal LoadData

@export var SavePath = "usr://saves/Progression.save"

func _ready():
	SaveData.connect(SaveGameData)
	LoadData.connect(LoadGameData)

func SaveGameData() -> bool:
	var File = FileAccess.open(SavePath,FileAccess.WRITE)
	File.store_var(GameData.GetDarkness())
	File.store_var(GameData.GetMaxHealth())
	File.store_var(GameData.GetMaxMana())
	File.store_var(GameData.GetDamagePercent())
	File.store_var(GameData.GetMaxMinions())
	return FileAccess.file_exists(SavePath)
		
func LoadGameData():
	if FileAccess.file_exists(SavePath):
		var File = FileAccess.open(SavePath,FileAccess.READ)
		GameData.SetDarkness(File.get_var(GameData.GetDarkness()))
		GameData.SetMaxHealth(File.get_var(GameData.GetMaxHealth()))
		GameData.SetMaxMana(File.get_var(GameData.GetMaxMana()))
		GameData.SetDamagePercent(File.get_var(GameData.GetDamagePercent()))
		GameData.SetMaxMinions(File.get_var(GameData.GetMaxMinions()))
	else:
		print("No Data Saved")
		GameData.SetDarkness(111111110)
		GameData.SetMaxHealth(2)
		GameData.SetMaxMana(2)
		GameData.SetDamagePercent(0)
		GameData.SetMaxMinions(2)
		
