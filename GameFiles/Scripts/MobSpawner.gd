extends Node

var enemy_scene = preload("uid://dimxkh5vbaxfx") #Enemy scene to instantiate
var spawn_timer = Timer.new()
var numOfChildren = 0
@export var maxEnemies = 10
var maxToSpawn = 0 #this is used to switch between continous or one time
@export var spawnRadius = 50
@export var continousSpawn = true
func _ready():
	maxToSpawn = maxEnemies
	print("Im alive")
	# Add the Timer as a child so that it becomes part of the scene
	add_child(spawn_timer)
	
	# Connect the timeout signal to the function that spawns enemies
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	
	# Set the timer to repeat every 5 seconds
	# Until
	spawn_timer.wait_time = 2
	spawn_timer.one_shot = false
	spawn_timer.start()
	numOfChildren = get_child_count()
	

# Function called when the Timer times out
func _on_spawn_timer_timeout():
	
	if(continousSpawn):
		maxToSpawn = get_child_count()
	# Instantiate the enemy object
	if(maxToSpawn < maxEnemies+numOfChildren):
		var enemy_instance = enemy_scene.instantiate()
		var rIntX = 2*randi_range(-spawnRadius, spawnRadius)
		var rIntY = 2*randi_range(-spawnRadius, spawnRadius)
		enemy_instance.translate(Vector2(rIntX, rIntY))
		print("I spawned a guy")
	# Add the enemy instance as a child of the current node or another node
		add_child(enemy_instance)
	if(!continousSpawn):
		maxToSpawn += 1
