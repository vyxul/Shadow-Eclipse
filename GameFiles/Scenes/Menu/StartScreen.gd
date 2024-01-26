extends Node2D

@onready var SettingsScreen = $"SettingsMenu"
@onready var continue_texture = $"Interactables/ContinueButton/ContinueTexture"
@onready var LoadingScreen = $"LoadingScreen"

var Game : String = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsScreen.ShowStartMenuButtons.connect(ShowStartMenuButtons)
	continue_texture.visible = false;
	
#func _on_options_button_pressed():
	#SettingsScreen.visible = true
	#Interactables.visible = false


func _on_start_button_pressed():
	LoadManager.load_scene(Game)
	
func ShowStartMenuButtons():
	pass

func _on_continue_button_pressed():
	pass

func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
