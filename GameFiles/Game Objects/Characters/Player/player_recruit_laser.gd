extends RayCast2D

@onready var line_2d = $Line2D


func _physics_process(delta):
	var cast_point = target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	line_2d.points[1] = cast_point


func appear():
	var tween = create_tween()
	#tween.tween_property(line_2d, "width",  0,  0)
	tween.tween_property(line_2d, "width", 10, .2)


func disappear():
	var tween = create_tween()
	#tween.tween_property(line_2d, "width", 10,  0)
	tween.tween_property(line_2d, "width",  0, .2)
