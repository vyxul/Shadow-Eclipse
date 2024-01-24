extends CharacterBody2D
class_name Player

@export var faction: GameData.Factions = GameData.Factions.SHADOW
@export var player_speed: float = 500
@export var run_speed_multiplier: float = 1.5

@onready var marker_2d = $Marker2D
@onready var sprite_2d = $Sprite2D
@onready var player_melee_controller = $PlayerMeleeController
@onready var player_ranged_controller = $PlayerRangedController
@onready var health_component: HealthComponent = $HealthComponent
@onready var mana_component: ManaComponent = $ManaComponent

# another way i could spread out summons is:
# 360 degrees / number of followers, create a point at each multiple
# helps with even spreading
var followers: Dictionary = {}
var follower_markers: Array = []


func _ready():
	var index = 0
	for child in $FollowerMarkers.get_children():
		followers[index] = null
		follower_markers.append(child)
		index += 1
		
	GameData.player_hp_ui_ready.connect(on_player_hp_ui_ready)
	GameData.player_mp_ui_ready.connect(on_player_mp_ui_ready)


func _process(delta):
	#update_follower_markers()
	pass


func _physics_process(delta):
	
	update_follower_markers()
	move(delta)
	if Input.is_action_just_pressed("left_click"):
		melee_attack()
		
	if Input.is_action_just_pressed("right_click"):
		ranged_attack()

	if Input.is_action_just_pressed("x"):
		command_followers_move()

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
			return follower_markers[key]
	
	return null


func set_follower_slot(follower_marker: Marker2D, follower: NonPlayerCharacter):
	var index = 0
	var key
	for marker in follower_markers:
		if marker == follower_marker:
			key = index
		index += 1
	
	followers[key] = follower


func update_follower_markers():
	for key in followers.keys():
		var follower = followers[key]
		if follower != null:
			var follower_marker = follower_markers[key] as Marker2D
			var marker_raycasts = $FollowerRaycasts.get_children()
			var marker_raycast = marker_raycasts[key] as RayCast2D
			marker_raycast.force_raycast_update()
			if marker_raycast.is_colliding():
				var colliding_point = marker_raycast.get_collision_point()
				
				follower_marker.position = to_local(colliding_point)
			else:
				follower_marker.position = marker_raycast.target_position


func melee_attack():
	player_melee_controller.attack(sprite_2d)


func ranged_attack():
	player_ranged_controller.attack()


func emit_player_hp():
	GameData.player_health_changed.emit(health_component.current_health_points, health_component.max_health_points)


func emit_player_mp():
	GameData.player_mana_changed.emit(mana_component.current_mana_points, mana_component.max_mana_points)


func _on_health_component_health_lost():
	emit_player_hp()


func _on_health_component_health_depleted():
	GameData.player_died.emit()


func _on_mana_component_mana_lost():
	emit_player_mp()


func _on_mana_component_mana_depleted():
	GameData.player_mana_empty.emit()


func on_player_hp_ui_ready():
	emit_player_hp()


func on_player_mp_ui_ready():
	emit_player_mp()
func command_followers_move():
	var mouse_position = get_global_mouse_position()
	var nav_agent = $NavigationAgent2D
	nav_agent.target_position = mouse_position
	if nav_agent.is_target_reachable():
		GameData.follow_target_set.emit(mouse_position)
