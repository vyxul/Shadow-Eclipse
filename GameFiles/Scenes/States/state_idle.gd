extends State
class_name state_idle


var this_entity: CharacterBody2D
var this_search_radius: SearchRadius
var this_animation_player: AnimationPlayer

var idle_time
var wander_move_speed
var wander_max_time
var move_direction: Vector2
var current_idle_time: float
var current_wander_time: float

enum {IDLE, WANDER}
var current_motion


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	current_wander_time = randf_range(1, wander_max_time)


func switch_to_idle():
	current_motion = IDLE
	this_animation_player.play("idle")
	current_idle_time = idle_time
	get_parent().get_state_label().text = "Idle"


func switch_to_wander():
	current_motion = WANDER
	this_animation_player.play("walk")
	randomize_wander()
	get_parent().get_state_label().text = "Wander"


func setup():
	# set up component references
	this_entity = get_parent().get_this_entity()
	this_search_radius = get_parent().get_search_radius()
	this_animation_player = get_parent().get_animation_player()
	
	# set up state properties
	idle_time = get_parent().idle_time
	wander_move_speed = get_parent().wander_move_speed
	wander_max_time = get_parent().wander_max_time
	 
	# set up connections with search_radius
	get_parent().get_search_radius().tracking_enemy.connect(on_tracking_enemy)


func enter():
	switch_to_idle()
	
	get_parent().get_state_label().text = "Idle/Wander"
	
	# check to see if needs to go into combat right away
	#get_parent().get_search_radius().search_surroundings()
	this_search_radius.reset()


func exit():
	this_entity.velocity = Vector2.ZERO
	this_animation_player.play("RESET")


func update(delta: float):
	match current_motion:
		IDLE:
			if current_idle_time > 0:
				current_idle_time -= delta
			else:
				switch_to_wander()
		WANDER:
			if current_wander_time > 0:
				current_wander_time -= delta
			else:
				switch_to_idle()


func physics_update(delta: float):
	if this_entity:
		match current_motion:
			IDLE:
				this_entity.velocity = Vector2.ZERO
			WANDER:
				var new_velocity = move_direction * wander_move_speed
				this_entity.velocity = new_velocity
				this_entity.get_sprite().flip_h = new_velocity.x < 0


func on_tracking_enemy():
	transitioned.emit(self, "state_combat")
