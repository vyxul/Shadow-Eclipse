extends CanvasLayer
class_name MessageUI

@onready var timer = $Timer
@onready var color_rect = $ColorRect
@onready var label = $ColorRect/MarginContainer/ScrollContainer/Label
@onready var close_button = $ColorRect/CloseButton
@onready var sprite_2d = $Sprite2D

var message_close_on_timer: bool = false
var message_display_time: float
var message_to_display: String


func appear():
	if message_close_on_timer:
		timer.wait_time = message_display_time
		timer.start()
	
	visible = true
	color_rect.visible = true
	close_button.disabled = false
	sprite_2d.visible = true
	get_tree().paused = true


func disappear():
	color_rect.visible = false
	close_button.disabled = true
	sprite_2d.visible = false
	get_tree().paused = false
	


func set_close_on_timer(value: bool):
	message_close_on_timer = value


func set_display_time(num: float):
	message_display_time = num
	

func set_display_message(msg: String):
	message_to_display = msg
	label.text = message_to_display


func _on_timer_timeout():
	disappear()


func _on_close_button_pressed():
	disappear()
