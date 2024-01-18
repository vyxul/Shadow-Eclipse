extends Node2D

@onready var player_recruitment: RayCast2D = $PlayerRecruitLaser

@export var player: CharacterBody2D
@export var laser_range: float = 500

var is_casting: bool = false


func _ready():
	set_physics_process(false)
	player_recruitment.line_2d.points[1] = Vector2.ZERO


func _process(delta):
	if Input.is_action_just_pressed("r"):
		set_is_casting(!is_casting)
	
	#player_recruitment.position = player.get_weapon_origin()
	var target_direction = (get_global_mouse_position() - player.global_position).normalized()
	player_recruitment.target_position = target_direction * laser_range


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		player_recruitment.appear()
	else:
		player_recruitment.disappear()
