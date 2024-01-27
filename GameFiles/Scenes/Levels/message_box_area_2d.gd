extends Area2D


@export_multiline var message_to_display: String = "Message Here"
@export var message_display_time: float = 5
@export var message_display_count: int = 1
@export var message_close_on_timer: bool = false

var message_ui: MessageUI

var current_display_count: int = 0


func _ready():
	message_ui = get_tree().get_first_node_in_group("messageui") as MessageUI
	

func _on_body_entered(body):
	if body is Player:
		if current_display_count < message_display_count:
			message_ui.set_display_message(message_to_display)
			message_ui.set_close_on_timer(message_close_on_timer)
			message_ui.set_display_time(message_display_time)
			message_ui.appear()
			current_display_count += 1
