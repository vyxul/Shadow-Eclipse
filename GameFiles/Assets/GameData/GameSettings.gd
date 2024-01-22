extends Node

class_name  GameSettings

static var MusicVolume:float = 10
static var SFXVolume:float = 10
static var VoiceVolume:float = 10

static func SetMusicVolume(volume) -> void:
	MusicVolume = volume

static func SetSFXVolume(volume) -> void:
	SFXVolume = volume

static func SetVoiceVolume(volume) -> void:
	VoiceVolume = volume

static func GetMusicVolume() -> float:
	return MusicVolume

static func GetSFXVolume() -> float:
	return SFXVolume

static func GetVoiceVolume() -> float:
	return VoiceVolume
	
	
