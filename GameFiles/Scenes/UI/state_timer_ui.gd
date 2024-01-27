extends CanvasLayer


@onready var color_rect = $ColorRect
@onready var label = $ColorRect/Label

var state_timer: Timer
var format_string = "%3.0f"

func _ready():
	state_timer = GameState.StateChangeTimer
	color_rect.visible = false
	GameState.game_state_changed.connect(on_game_state_changed)


func _process(delta):
	var time_left = state_timer.time_left
	label.text = format_string % time_left


func on_game_state_changed(game_state):
	if game_state == GameState.EGameState.Expansion:
		color_rect.visible = true
