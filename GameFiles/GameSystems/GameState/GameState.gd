extends Node

enum EGameState {Conquer, Expansion, Finished}

signal SpawnEnemy(spawn_times: int)
signal game_state_changed(state: EGameState)

@onready var EnemySpawnTimer = $EnemySpawnTimer
@onready var StateChangeTimer = $StateTimer
@export var _Game_State : EGameState = EGameState.Finished
@export var ConquerSpawnTimer : float = 300
@export var ExpansionSpawnTimer : float = 40
@export var ConquerTimeMaxScore : float = 4

var ConquerStateTimerRange : Vector2 = Vector2(420,720)
var ExpansionStateTimerRange : Vector2 = Vector2(180,300)
var spawn_times: int = 0

@export var ConquerStateTimerMaxScore : int = 7200

var StartTime: int = 0
var ConquerStateTime: int = 0
var ExpansionStateTime: int = 0
var playerdied : bool = false

# Called when the node enters the scene tree for the first time.
func game_start():
	playerdied = false
	ChangeGameState(EGameState.Conquer)
	StartTime = Time.get_ticks_msec()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match (GameState):
		EGameState.Conquer:
			ProcessConquer(delta)
		EGameState.Expansion:
			ProcessExpansion(delta)
		EGameState.Finished:
			pass

func ChangeGameState(gameState : EGameState):
	if _Game_State == gameState:
		return
	_Game_State = gameState
	EnemySpawnTimer.stop()
	match (gameState):
		EGameState.Conquer:
			var ConquerSateDuration = randf_range(ConquerStateTimerRange.x, ConquerStateTimerRange.y)
			StateChangeTimer.start(ConquerSateDuration)
			EnemySpawnTimer.start(ConquerSpawnTimer)
		EGameState.Expansion:
			ConquerStateTime = Time.get_ticks_msec() - StartTime
			var ExpansionSateDuration = randf_range(ExpansionStateTimerRange.x, ExpansionStateTimerRange.y)
			StateChangeTimer.start(ExpansionSateDuration)
			EnemySpawnTimer.start(ExpansionSpawnTimer)
		EGameState.Finished:
			ExpansionStateTime = Time.get_ticks_msec() - ConquerStateTime
			CalculateTimerScore()
	
	game_state_changed.emit(gameState)
	
	
func ProcessConquer(delta):
	pass	
	
func ProcessExpansion(delta):
	pass

func SendAllEnemiesToFountain():
	pass

func GetGameState() -> EGameState :
	return _Game_State


func reset():
	game_start()


func _on_enemy_spawn_timer_timeout():
	SpawnEnemy.emit(spawn_times)
	spawn_times += 1


func _on_state_timer_timeout():
	match (_Game_State):
		EGameState.Conquer:
			ChangeGameState(EGameState.Expansion)
		EGameState.Expansion:
			ChangeGameState(EGameState.Finished)

func PlayerDied():
	playerdied = true

func CalculateTimerScore():
	var score
	match (_Game_State):
		EGameState.Expansion:
			score = ((Time.get_ticks_msec() - StartTime) / 10) * (GameData.GetPlayerScore())
		EGameState.Expansion:
			score = ConquerStateTimerMaxScore - (ConquerStateTime / 100)
			score *= 0.5
		EGameState.Finished:
			
			score = ConquerStateTimerMaxScore - (ConquerStateTime / 100)
	
	score = clamp(score, 0, 999999)
	GameData.add_score(score)


func CalculateAndIncreaseDarknessFromScore(multiplier : float):
	var player_score = GameData.GetPlayerScore()
	var darkness = multiplier * player_score
	GameData.GetPersistantGameData().IncreaseDarkness(darkness)
	
