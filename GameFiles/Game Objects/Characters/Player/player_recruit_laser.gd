extends RayCast2D

@onready var line_2d = $Line2D
@onready var casting_particles = $CastingParticles
@onready var collision_particles = $CollisionParticles
@onready var beam_particles = $BeamParticles

@export var laser_width: float = 25

signal DamageConversionComponent(TargetID, amage)

var laser_in_use: bool = false
var focus_time_needed: float
var current_focus_time: float = 0
var conversion_damage: int
var focus_target: Node2D


func _ready():
	visible = true
	casting_particles.emitting = false
	collision_particles.emitting = false
	#beam_particles.emitting = false
	collision_particles.process_material.emission_shape_offset.x = 0
	line_2d.width = 0
	focus_time_needed = get_parent().focus_time_needed
	conversion_damage = get_parent().conversion_damage


func _physics_process(delta):
	var cast_point = target_position
	force_raycast_update()
	
	collision_particles.emitting = laser_in_use && is_colliding()
	
	casting_particles.process_material.direction.x = cast_point.x
	casting_particles.process_material.direction.y = cast_point.y
	
	if is_colliding() && laser_in_use:
		# visuals
		cast_point = to_local(get_collision_point())
		collision_particles.position = cast_point
		
		collision_particles.process_material.direction.x = -cast_point.x
		collision_particles.process_material.direction.y = -cast_point.y
		
		# target conversion damage
		var collider = get_collider()
		if collider is HurtboxComponent:
			#print_debug("collider name = " + str(collider.get_parent().name))
			# will need to add code later to check for faction relationship
			var current_target = collider.get_parent()
			
			if current_target != focus_target:
				focus_target = current_target
				current_focus_time = 0
			
			else:
				current_focus_time += delta
			
			if current_focus_time >= focus_time_needed:
				current_focus_time = 0
				print_debug("Focused on the same target for the focus time needed")
				# Add code here to refer to the targets conversion component
				# and reduce their gauge after making that conversion component
				var target_conversion_component = collider.GetConversionComponent() as ConversionComponent
				target_conversion_component.conversion_damage(conversion_damage)
	
	else:
		focus_target = null
		current_focus_time = 0
	
	
	line_2d.points[1] = cast_point
	
	#beam_particles.process_material.emission_shape_offset.x = abs(cast_point.x * .5)
	#beam_particles.process_material.emission_box_extents.x = cast_point.x * .5
	#beam_particles.rotation = cast_point.angle()


func appear():
	laser_in_use = true
	casting_particles.emitting = true
	#beam_particles.emitting = true
	var tween = create_tween()
	tween.tween_property(line_2d, "width", laser_width, .2)


func disappear():
	laser_in_use = false
	casting_particles.emitting = false
	#beam_particles.emitting = false
	var tween = create_tween()
	tween.tween_property(line_2d, "width",  0, .2)
	focus_target = null
