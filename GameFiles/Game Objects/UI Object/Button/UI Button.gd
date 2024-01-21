extends BaseButton

const loading_scene_path = "res://GameFiles/Game Objects/UI Object/LoadingScreen/LoadingScreen.tscn"

func _ready():
	var button = Button.new()
	button.pressed.connect(self._on_pressed)
	add_child(button)

func _on_pressed():	
	get_tree().change_scene_to_file(loading_scene_path)
