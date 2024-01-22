extends CharacterBody2D
class_name Player

@export var faction: GameData.Factions
@export var player_speed: float = 500
@export var run_speed_multiplier: float = 1.5

@onready var marker_2d = $Marker2D
@onready var sprite_2d = $Sprite2D
@onready var player_melee_controller = $PlayerMeleeController
@onready var player_ranged_controller = $PlayerRangedController
@onready var health_component: HealthComponent = $HealthComponent
@onready var mana_component: ManaComponent = $ManaComponent


func _ready():
	GameData.player_hp_ui_ready.connect(on_player_hp_ui_ready)
	GameData.player_mp_ui_ready.connect(on_player_mp_ui_ready)


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
