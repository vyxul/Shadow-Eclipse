extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var conversion_component: ConversionComponent = $ConversionComponent

func _ready():
	health_component.health_depleted.connect(on_health_depleted)
	conversion_component.conversion_hp_depleted.connect(on_conversion_hp_depleted)

func death():
	queue_free()


func on_health_depleted():
	death()


func get_conversion_component() -> ConversionComponent:
	return conversion_component


func on_conversion_hp_depleted():
	print_debug(name + " has lost all of it's conversion hp and will now be converted to an ally.")
