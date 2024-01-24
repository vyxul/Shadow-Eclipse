extends Node2D

signal ShowStartMenuButtons

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false 
	pass # Replace with function body.

#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#sets fullscreen mode

#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#sets window mode


func _on_back_button_pressed():
	visible = false 
	ShowStartMenuButtons.emit()
