extends Node

@export var enemy_spawn_list: Array[PackedScene] = []
@export var maxEnemies = 10
@export var spawnRadius = 50
@export var spawnWaitTime_seconds = 2
@export var index: int = 0

var spawn_timer = Timer.new()
var spawnedEnemies = 0
var initialNumOfChildren = 0


func _ready():
	GameState.SpawnEnemy.connect(spawn_ememy)


# Function called when the Timer times out
func spawn_ememy(spawn_times: int):
	if spawn_times % 3 != index:
		return
	
	
	spawnedEnemies = get_child_count()
	# Instantiate the enemy object
	if(spawnedEnemies < maxEnemies+initialNumOfChildren):
		var enemy_to_spawn = enemy_spawn_list.pick_random()
		var enemy_instance = enemy_to_spawn.instantiate()
		var rIntX = 2*randi_range(-spawnRadius, spawnRadius)
		var rIntY = 2*randi_range(-spawnRadius, spawnRadius)
		enemy_instance.translate(Vector2(rIntX, rIntY))
	# Add the enemy instance as a child of the current node or another node
		add_child(enemy_instance)
		enemy_instance.swarm_phase = true
