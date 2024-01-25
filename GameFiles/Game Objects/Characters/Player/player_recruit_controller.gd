extends Node2D

@onready var player_recruitment: RayCast2D = $PlayerRecruitLaser
@onready var timer = $Timer

@export var mana_component: ManaComponent
@export var hurtbox_component: HurtboxComponent
@export var player: CharacterBody2D
@export var laser_range: float = 500
@export var focus_time_needed: float = 1
@export var conversion_damage: int = 1
@export var mana_use_timer: float = 1
@export var mana_cost: float = 5

var is_casting: bool = false


func _ready():
	set_physics_process(false)
	player_recruitment.line_2d.points[1] = Vector2.ZERO
	timer.wait_time = mana_use_timer
	hurtbox_component.hurt.connect(on_hurt)


func _process(delta):
	if Input.is_action_just_pressed("r"):
		set_is_casting(!is_casting)
	
	#player_recruitment.position = player.get_weapon_origin()
	var target_direction = (get_global_mouse_position() - player.global_position).normalized()
	player_recruitment.target_position = target_direction * laser_range
	
	player.sprite_2d.flip_h = target_direction.x < 0


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		var enough_mana = mana_component.get_current_mana() >= mana_cost
		if !enough_mana:
			return
			
		mana_component.use(mana_cost)
		player_recruitment.appear()
		timer.start()
	else:
		player_recruitment.disappear()
		timer.stop()


func _on_timer_timeout():
	var enough_mana = mana_component.get_current_mana() >= mana_cost
	if !enough_mana:
		set_is_casting(false)
		return
		
	mana_component.use(mana_cost)


func on_hurt():
	if is_casting:
		set_is_casting(false)
