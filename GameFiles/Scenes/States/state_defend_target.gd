extends State
class_name state_defend_target


var this_entity: NonPlayerCharacter
var this_search_radius: SearchRadius
var defend_target_distance

var defend_target: Vector2


func setup():
	this_entity = get_parent().get_this_entity()
	this_search_radius = get_parent().get_search_radius()
	
	defend_target_distance = get_parent().defend_target_distance
	
	GameData.follow_player.connect(on_follow_player)
	GameData.follow_target_set.connect(on_follow_target_set)
	GameData.attack_target_command.connect(on_attack_target_command)
	this_search_radius.tracking_enemy.connect(on_tracking_enemy)
	this_search_radius.reset()


func enter():
	defend_target = GameData.follow_target_position
	get_parent().get_state_label().text = "Defend Target"
	this_entity.velocity = Vector2.ZERO


func update(delta):
	var distance_to_target = (this_entity.global_position - defend_target).length()
	if distance_to_target >= defend_target_distance:
		transitioned.emit(self, "state_follow_target")


func on_follow_player():
	transitioned.emit(self, "state_follow_player")


func on_follow_target_set():
	transitioned.emit(self, "state_follow_target")


func on_attack_target_command():
	transitioned.emit(self, "state_attack_target")


func on_tracking_enemy():
	transitioned.emit(self, "state_combat")
