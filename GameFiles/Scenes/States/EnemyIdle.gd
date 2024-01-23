extends State
class_name EnemyIdle

@export var move_speed: float = 10.0
@export var idle_time: float = 1
@export var wander_max_time: float = 3

var this_entity: CharacterBody2D
var animation_player: AnimationPlayer
var move_direction: Vector2
var current_idle_time: float
var current_wander_time: float

enum {IDLE, WANDERING}
var current_state


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	current_wander_time = randf_range(1, wander_max_time)


func enter():
	get_parent().get_state_label().text = "Idle"
	this_entity = get_parent().get_this_entity()
	animation_player = get_parent().get_animation_player()
	current_idle_time = idle_time
	current_state = IDLE
	animation_player.play("idle")
	
	# set up connections with search_radius
	get_parent().get_search_radius().tracking_enemy.connect(on_tracking_enemy)
	
	# check to see if needs to go into combat right away
	get_parent().get_search_radius().search_surroundings()


func exit():
	this_entity.velocity = Vector2.ZERO
	animation_player.play("RESET")


func update(delta: float):
	match current_state:
		IDLE:
			if current_idle_time > 0:
				current_idle_time -= delta
			else:
				randomize_wander()
				switch_state()
		WANDERING:
			if current_wander_time > 0:
				current_wander_time -= delta
			else:
				current_idle_time = idle_time
				switch_state()


func physics_update(delta: float):
	if this_entity:
		match current_state:
			IDLE:
				this_entity.velocity = Vector2.ZERO
			WANDERING:
				var new_velocity = move_direction * move_speed
				this_entity.velocity = new_velocity
				this_entity.get_sprite().flip_h = new_velocity.x < 0


func switch_state():
	match current_state:
		IDLE:
			var current_animation = animation_player.current_animation
			if current_animation == "idle" && animation_player.is_playing():
				animation_player.play("walk")
			current_state = WANDERING
			return
			
		WANDERING:
			var current_animation = animation_player.current_animation
			if current_animation == "walk" && animation_player.is_playing():
				animation_player.play("idle")
			current_state = IDLE
			return


func on_tracking_enemy():
	transitioned.emit(self, "enemycombat")
	#print_debug("Transitioning from idle to combat")
