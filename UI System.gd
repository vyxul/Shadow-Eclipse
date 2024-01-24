extends CanvasLayer

@onready var InGamePanel = $InGamePanel
@onready var EndOfGameScreen = $EndOfGameScreen
@onready var LoadingScreen = $"../LoadingScreen"
var StartScreen = "res://GameFiles/Scenes/Menu/StartScreen.tscn"

var FinalScore = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	InGamePanel.visible = true
	EndOfGameScreen.visible = false

func _on_next_button_pressed():
	SceneChanger.ChangeScene(StartScreen)

func SetFinalScore(score : int):
	FinalScore = score

func OnGameOver():
	EndOfGameScreen.visible = true
	$EndOfGameScreen/EndText/Score.text = "%d" % FinalScore

func _on_finish_game_pressed():
	SetFinalScore(randi() % 100000000)
	OnGameOver()
