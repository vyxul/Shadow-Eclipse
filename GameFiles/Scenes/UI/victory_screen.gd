extends CanvasLayer

@onready var score_value_label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ScoreValueLabel
@onready var continue_button = $ColorRect/MarginContainer/HBoxContainer/ContinueButton

var Game = "res://GameFiles/Scenes/Menu/StartScreen.tscn"

func _ready():
	visible = false
	continue_button.disabled = true


func get_score() -> int:
	return GameData.player_score


func appear():
	visible = true
	continue_button.disabled = false
	score_value_label.text = str(get_score())
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
