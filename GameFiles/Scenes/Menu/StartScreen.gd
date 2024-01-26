extends Node2D

@onready var SettingsScreen = $"SettingsMenu"
@onready var Shop_texture = $Interactables/ShopButton/ShopTexture
@onready var StartScreen = $StartScreen
@onready var Shop = $Shop

var Game : String = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsScreen.ShowStartMenuButtons.connect(ShowStartMenuButtons)
	Shop.hide()
	Shop.ShopClosed.connect(ShowStartMenuButtons)
	ShowStartMenuButtons()
	SaveAndLoad.LoadData.emit()
	
func _on_start_button_pressed():
	SaveAndLoad.LoadData.emit()
	LoadManager.load_scene(Game)


func HideButtons():
	StartScreen.z_index = 10

	
func ShowStartMenuButtons():
	StartScreen.z_index = 0


func _on_quit_button_pressed():
	get_tree().quit()


func _on_shop_button_pressed():
	HideButtons()
	Shop.OpenShop.emit()


