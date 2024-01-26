extends Node

signal SaveData
signal LoadData

var SaveFilePath = "user://save/"
var SaveFileName = "PersistantData.tres"

func _ready():
	VerifyDirectory(SaveFilePath)
	SaveData.connect(SaveGameData)
	LoadData.connect(LoadGameData)

func VerifyDirectory(path : String):
	DirAccess.make_dir_absolute(SaveFilePath)

func SaveGameData() -> void:
	var PersGameData = GameData.GetPersistantGameData()
	var result = ResourceSaver.save(PersGameData, SaveFilePath + SaveFileName)
	assert(result == OK)
	
	
func LoadGameData():
	if ResourceLoader.exists(SaveFilePath + SaveFileName):
		var PersGameData = GameData.GetPersistantGameData()
		PersGameData = ResourceLoader.load(SaveFilePath + SaveFileName)
		if !PersGameData == null:
			GameData.SetPersistantGameData(PersGameData)
	else:
		print("Failed to find file.")
