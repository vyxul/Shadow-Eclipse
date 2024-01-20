extends Node



@export var SavePath = "res://GameFiles/Assets/GameData/Settings/settings.save"



func  SaveSettings(i_arg:Array) -> bool:
	var File = FileAccess.open(SavePath,FileAccess.WRITE)
	File.store_var(GameSettings.GetMusicVolume())
	File.store_var(GameSettings.GetSFXVolume())
	File.store_var(GameSettings.GetVoiceVolume())
	return FileAccess.file_exists(SavePath)
		
func LoadSettings():
	if FileAccess.file_exists(SavePath):
		var File = FileAccess.open(SavePath,FileAccess.READ)
		GameSettings.SetMusicVolume(File.get_var(GameSettings.GetMusicVolume()))
		GameSettings.SetSFXVolume(File.get_var(GameSettings.GetSFXVolume()))
		GameSettings.SetVoiceVolume(File.get_var(GameSettings.GetVoiceVolume()))
	else:
		print("No Data Saved")
		GameSettings.SetMusicVolume(10)
		GameSettings.SetSFXVolume(10)
		GameSettings.SetVoiceVolume(10)
		
