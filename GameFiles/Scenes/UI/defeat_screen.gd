extends CanvasLayer

@onready var score_value_label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ScoreValueLabel
@onready var continue_button = $ColorRect/MarginContainer/HBoxContainer/ContinueButton
@onready var ReasonLabel = $ColorRect/MarginContainer/VBoxContainer/ReasonLabel
var Game = "res://GameFiles/Scenes/Menu/StartScreen.tscn"

func _ready():
	visible = false
	continue_button.disabled = true


func get_score() -> int:
	return GameData.player_score


func appear(Reason : int = 0):
	match (Reason):
		0: 
			ReasonLabel.text = String("You Die")
		1:
			ReasonLabel.text = String("Fountain Destroyed")
	
	visible = true
	continue_button.disabled = false
	score_value_label.text = str(get_score())
	GameState.CalculateAndIncreaseDarknessFromScore(1)
	get_tree().paused = true


func disappear():
	visible = false
	continue_button.disabled = true
	get_tree().paused = false


func _on_continue_button_pressed():
	disappear()
	GameData.reset()
	GameState.reset()
	LoadManager.load_scene(Game)
