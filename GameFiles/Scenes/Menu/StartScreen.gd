extends Node2D

@onready var LoadingScreen = $"../LoadingScreen"
@onready var SettingsScreen = $"../SettingsMenu"
@onready var Interactables = $Interactables

var StartLevel = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsScreen.ShowStartMenuButtons.connect(ShowStartMenuButtons)
	
func _process(_delta: float):
	pass

func _on_options_button_pressed():
	SettingsScreen.visible = true
	Interactables.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	LoadingScreen.SetNextScene(StartLevel)
	get_tree().change_scene_to_packed(LoadingScreen)
	LoadingScreen.GoToNextScene()

func ShowStartMenuButtons():
	Interactables.visible = true
