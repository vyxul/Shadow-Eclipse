extends State
class_name EnemyHurt

@export var invincibility_time: float = 0.5

var enemy: CharacterBody2D
var hurtbox_component: HurtboxComponent
var timer: float

func enter():
	enemy = get_parent().get_enemy()
	hurtbox_component = get_parent().get_hurtbox_component()
	get_parent().get_label().text = "Hurt"
	timer = invincibility_time
	
	if enemy:
		enemy.set_process(false)


func update(delta):
	timer -= delta
	
	if timer <= 0:
		if enemy:
			enemy.set_process(true)
		
		transitioned.emit(self, "enemyidle")
