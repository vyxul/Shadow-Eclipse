extends CanvasLayer

@onready var label = $Label

var state_timer: Timer
var format_string = "%2.0f"

func _ready():
	state_timer = GameState.StateChangeTimer
	label.visible = false
	GameState.game_state_changed.connect(on_game_state_changed)


func _process(delta):
	var time_left = state_timer.time_left
	if time_left < 60:
		label.text = format_string % time_left


func on_game_state_changed(game_state):
	if game_state == GameState.EGameState.Finished:
		label.visible = true
