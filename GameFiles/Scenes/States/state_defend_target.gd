extends State
class_name state_defend_target


var this_entity: NonPlayerCharacter

var defend_target_distance

var defend_target: Vector2


func setup():
	this_entity = get_parent().get_this_entity()
	
	defend_target_distance = get_parent().defend_target_distance


func enter():
	defend_target = GameData.follow_target_position
	get_parent().get_state_label().text = "Defend Target"


func update(delta):
	var distance_to_target = (this_entity.global_position - defend_target).length()
	if distance_to_target >= defend_target_distance:
		transitioned.emit(self, "state_follow_target")

