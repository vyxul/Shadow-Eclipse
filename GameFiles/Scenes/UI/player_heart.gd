extends Control

@onready var animation_player = $AnimationPlayer
@onready var full_heart_sprite = $FullHeartSprite
@onready var partial_heart = $PartialHeart
@onready var partial_heart_progress_bar = %PartialHeartProgressBar


func set_heart_full():
	full_heart_sprite.visible = true
	partial_heart.visible = false
	# make sure animation plays from beginning
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("heart_full")


func set_heart_partial(number: float):
	full_heart_sprite.visible = false
	partial_heart.visible = true
	# stop animation
	if animation_player.is_playing():
		animation_player.stop()
	
	# set the value for the heart progress bar
	partial_heart_progress_bar.value = number


func set_heart_empty():
	full_heart_sprite.visible= false
	partial_heart.visible = true
	# stop animation
	if animation_player.is_playing():
		animation_player.stop()
	
	# set the value for heart progress bar to 0
	partial_heart_progress_bar.value = 0
