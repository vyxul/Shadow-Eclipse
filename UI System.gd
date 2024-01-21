extends CanvasLayer

var LoadingScreen : PackedScene = null 
@onready var EndOfGameScreen = $EndOfGameScreen

var FinalScore = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	LoadingScreen = preload("res://GameFiles/GameSystems/UI System/LoadingScreen/LoadingScreen.tscn")
	LoadNextScene("res://GameFiles/Scenes/Menu/StartScreen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func LoadNextScene(ScenePath):
	LoadingScreen.SetNextScene(ScenePath)
	get_tree().change_scene_to_file(ScenePath)

func _on_next_button_pressed():
	get_tree().unload_current_scene()
	LoadNextScene("res://GameFiles/Scenes/Menu/StartScreen.tscn")

func SetFinalScore(score : int):
	FinalScore = score

func OnGameOver():
	EndOfGameScreen.visible = true
	$EndOfGameScreen/EndText/Score.text = "%d" % FinalScore
	
	
	
