extends VBoxContainer

@onready var HealthBar = $HealthBar
@onready var ManaBar = $ManaBar
@onready var MinionControlText = $MinionControlText
@onready var ControlledMinions = $ControlledMinions

func _ready():
	HealthBar.value = 0.85
	ManaBar.value = 0.65
	ControlledMinions.UpdateMinionCountVisuals()
