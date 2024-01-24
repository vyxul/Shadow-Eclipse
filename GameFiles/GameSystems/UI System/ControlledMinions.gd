extends HBoxContainer

var MinionControlCount = 0
@export_range (1, 18) var MaxMinionControl: int

# Called when the node enters the scene tree for the first time.
func _ready():
	for MinionIcon in get_children():
		MinionIcon.get_child(0).visible = false
	

func AddMinionControlCount(ControlCount) :
	MinionControlCount += ControlCount
	UpdateMinionCountVisuals()
	
func ResetMinionControlCount() : 
	MinionControlCount = 0
	UpdateMinionCountVisuals()
	
func SetMinionControlCount(ControlCount) :
	MinionControlCount = ControlCount
	UpdateMinionCountVisuals()

func UpdateMinionCountVisuals():
	var i = 0
	for MinionIcon in get_children():
		if i < MaxMinionControl:
			MinionIcon.visible = true
			if i < MinionControlCount:
				MinionIcon.get_child(0).visible = true
			else:
				MinionIcon.get_child(0).visible = false
		else:
			MinionIcon.visible = false
		i += 1
	
