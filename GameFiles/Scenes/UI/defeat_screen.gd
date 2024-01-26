extends CanvasLayer

@onready var score_value_label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ScoreValueLabel
@onready var retry_button = $ColorRect/MarginContainer/HBoxContainer/RetryButton
@onready var quit_button = $ColorRect/MarginContainer/HBoxContainer/QuitButton

var Game = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"

func _ready():
	visible = false
	retry_button.disabled = true
	quit_button.disabled = true


func get_score() -> int:
	return GameData.player_score


func appear():
	visible = true
	retry_button.disabled = false
	quit_button.disabled = false
	score_value_label.text = str(get_score())
	get_tree().paused = true


func disappear():
	visible = false
	retry_button.disabled = true
	quit_button.disabled = true
	get_tree().paused = false


func _on_retry_button_pressed():
	disappear()
	GameData.reset()
	GameState.reset()
	LoadManager.load_scene(Game)


func _on_quit_button_pressed():
	get_tree().quit()
