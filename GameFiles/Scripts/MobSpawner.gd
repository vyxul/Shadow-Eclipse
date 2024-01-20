extends Node

var enemy_scene = preload("res://GameFiles/Game Objects/Characters/Enemies/enemy_bandit.tscn") #Enemy scene to instantiate
var spawn_timer = Timer.new()
var initialNumOfChildren = 0
@export var maxEnemies = 10
var spawnedEnemies = 0
@export var spawnRadius = 50
@export var spawnWaitTime_seconds = 2
func _ready():
	# Add the Timer as a child so that it becomes part of the scene
	add_child(spawn_timer)
	# Connect the timeout signal to the function that spawns enemies
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	# Set the timer to repeat every 5 seconds
	# Until
	spawn_timer.wait_time = spawnWaitTime_seconds
	spawn_timer.one_shot = false
	spawn_timer.start()
	initialNumOfChildren = get_child_count()

# Function called when the Timer times out
func _on_spawn_timer_timeout():
	
	spawnedEnemies = get_child_count()
	# Instantiate the enemy object
	if(spawnedEnemies < maxEnemies+initialNumOfChildren):
		var enemy_instance = enemy_scene.instantiate()
		var rIntX = 2*randi_range(-spawnRadius, spawnRadius)
		var rIntY = 2*randi_range(-spawnRadius, spawnRadius)
		enemy_instance.translate(Vector2(rIntX, rIntY))
	# Add the enemy instance as a child of the current node or another node
		add_child(enemy_instance)
