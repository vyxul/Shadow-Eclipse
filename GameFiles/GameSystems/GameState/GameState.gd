extends Node

enum EGameState {Conquer, Expansion}

signal SpawnEnemy
signal game_state_changed(state: EGameState)

@onready var EnemySpawnTimer = $EnemySpawnTimer
@export var _Game_State : EGameState = EGameState.Conquer
@export var ConquerSpawnTimer : float = 30
@export var ExpansionSpawnTimer : float = 4

# Called when the node enters the scene tree for the first time.
func game_start():
	ChangeGameState(EGameState.Conquer)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match (GameState):
		EGameState.Conquer:
			ProcessConquer(delta)
		EGameState.Expansion:
			ProcessExpansion(delta)

func ChangeGameState(gameState : EGameState):
	_Game_State = gameState
	EnemySpawnTimer.stop()
	match (gameState):
		EGameState.Conquer:
			EnemySpawnTimer.start(ConquerSpawnTimer)
		EGameState.Expansion:
			EnemySpawnTimer.start(ExpansionSpawnTimer)
	
	game_state_changed.emit(gameState)
	
	
func ProcessConquer(delta):
	pass	
	
func ProcessExpansion(delta):
	pass

func SendAllEnemiesToFountain():
	pass

func GetGameState() -> EGameState :
	return _Game_State

func _on_enemy_spawn_timer_timeout():
	SpawnEnemy.emit()

