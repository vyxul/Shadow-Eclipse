extends Node

enum EGameState {Conquer, Expansion}

signal SpawnEnemy

@onready var EnemySpawnTimer = $EnemySpawnTimer
@export var GameState : EGameState = EGameState.Conquer
@export var ConquerSpawnTimer : float = 30
@export var ExpansionSpawnTimer : float = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	ChangeGameState(EGameState.Conquer)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match (GameState):
		EGameState.Conquer:
			ProcessConquer(delta)
		EGameState.Expansion:
			ProcessExpansion(delta)
	
func ChangeGameState(gameState):
	GameState = gameState
	EnemySpawnTimer.stop()
	match (GameState):
		EGameState.Conquer:
			EnemySpawnTimer.start(ConquerSpawnTimer)
		EGameState.Expansion:
			EnemySpawnTimer.start(ExpansionSpawnTimer)
	
func ProcessConquer(delta):
	pass	
	
func ProcessExpansion(delta):
	pass

func SendAllEnemiesToFountain():
	pass

func GetGameState() -> EGameState :
	return GameState

func _on_enemy_spawn_timer_timeout():
	SpawnEnemy.emit()
