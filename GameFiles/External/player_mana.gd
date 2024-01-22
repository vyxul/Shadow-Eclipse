extends Control

@onready var animation_player = $AnimationPlayer
@onready var full_mana_sprite = $FullManaSprite
@onready var partial_mana = $PartialMana
@onready var partial_mana_progress_bar = %PartialManaProgressBar


func set_mana_full():
	full_mana_sprite.visible = true
	partial_mana.visible = false
	# make sure animation plays from beginning
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("mana_full")


func set_mana_partial(number: float):
	full_mana_sprite.visible = false
	partial_mana.visible = true
	# stop animation
	if animation_player.is_playing():
		animation_player.stop()
	
	# set the value for the mana progress bar
	partial_mana_progress_bar.value = number


func set_mana_empty():
	full_mana_sprite.visible= false
	partial_mana.visible = true
	# stop animation
	if animation_player.is_playing():
		animation_player.stop()
	
	# set the value for mana progress bar to 0
	partial_mana_progress_bar.value = 0
