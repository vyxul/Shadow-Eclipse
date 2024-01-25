extends Node2D

@onready var LoadingScreen = $"../LoadingScreen"
@onready var SettingsScreen = $"../SettingsMenu"
@onready var Interactables = $Interactables
@onready var continue_texture = $"../Interactables/ContinueButton/ContinueTexture"

var Game = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsScreen.ShowStartMenuButtons.connect(ShowStartMenuButtons)
	continue_texture.visible = false;
	
#func _on_options_button_pressed():
	#SettingsScreen.visible = true
	#Interactables.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	SceneChanger.ChangeScene(Game)

func ShowStartMenuButtons():
	Interactables.visible = true

func _on_continue_button_pressed():
	SceneChanger.ChangeScene(Game)