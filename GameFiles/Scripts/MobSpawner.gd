extends Node

@export var EnemyToSpawn : PackedScene = null
var spawn_timer = Timer.new()
var initialNumOfChildren = 0
@export var maxEnemies = 10
var spawnedEnemies = 0
@export var spawnRadius = 50
@export var spawnWaitTime_seconds = 2
func _ready():
	GameState.SpawnEnemy.connect(spawn_ememy)

# Function called when the Timer times out
func spawn_ememy():
	
	spawnedEnemies = get_child_count()
	# Instantiate the enemy object
	if(spawnedEnemies < maxEnemies+initialNumOfChildren):
		var enemy_instance = EnemyToSpawn.instantiate()
		var rIntX = 2*randi_range(-spawnRadius, spawnRadius)
		var rIntY = 2*randi_range(-spawnRadius, spawnRadius)
		enemy_instance.translate(Vector2(rIntX, rIntY))
	# Add the enemy instance as a child of the current node or another node
		add_child(enemy_instance)
		await get_tree().process_frame
		enemy_instance.swarm_phase = true
