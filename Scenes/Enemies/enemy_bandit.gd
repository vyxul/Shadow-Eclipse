extends CharacterBody2D

@onready var health_component = $HealthComponent

func _ready():
	health_component.health_depleted.connect(on_health_depleted)


func death():
	queue_free()


func on_health_depleted():
	death()
