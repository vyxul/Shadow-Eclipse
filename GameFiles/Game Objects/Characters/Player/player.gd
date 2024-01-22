extends CharacterBody2D
class_name Player

@export var faction: GameData.Factions = GameData.Factions.SHADOW
@export var player_speed: float = 500
@export var run_speed_multiplier: float = 1.5

@onready var marker_2d = $Marker2D
@onready var sprite_2d = $Sprite2D
@onready var player_melee_controller = $PlayerMeleeController
@onready var player_ranged_controller = $PlayerRangedController

# another way i could spread out summons is:
# 360 degrees / number of followers, create a point at each multiple
# helps with even spreading
var followers: Dictionary = {}


func _ready():
	for child in $FollowerMarkers.get_children():
		followers[child] = null


func _physics_process(delta):
	move(delta)
	if Input.is_action_just_pressed("left_click"):
		melee_attack()
		
	if Input.is_action_just_pressed("right_click"):
		ranged_attack()


func move(delta: float):
	var move_direction = Input.get_vector("left", "right", "up", "down")
	move_direction = move_direction.normalized()
	
	var player_running = Input.is_action_pressed("shift")
	var move_speed: float
	if player_running:
		move_speed = player_speed * run_speed_multiplier
	else:
		move_speed = player_speed
	
	var target_velocity = move_direction * move_speed
	#velocity = velocity.lerp(target_velocity, 1 - exp(-delta * 5))
	velocity = target_velocity
	
	move_and_slide()


func get_weapon_origin():
	return marker_2d.global_position


func get_faction() -> GameData.Factions:
	return faction


func get_empty_follower_slot() -> Marker2D:
	for key in followers.keys():
		if followers[key] == null:
			return key
	
	return null


func set_follower_slot(marker2d_key: Marker2D, follower: NonPlayerCharacter):
	followers[marker2d_key] = follower


func melee_attack():
	player_melee_controller.attack(sprite_2d)


func ranged_attack():
	player_ranged_controller.attack()
