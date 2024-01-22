extends Control


@onready var base_bar_h_box_container = $BaseBar_HBoxContainer
@onready var heart_bar_h_box_container = $HeartBar_HBoxContainer

var base_bar_1 = preload("res://assets/art/ui/001 base bar - upper start.png")
var base_bar_2 = preload("res://assets/art/ui/002 base bar - upper middle.png")
var base_bar_3 = preload("res://assets/art/ui/003 base bar - upper end.png")
var player_heart_scene = preload("res://ui/hud_ui/player_heart.tscn")

var current_hearts_displayed: int = 0
var player_max_hp: int = 100
var player_current_hp: int = 95
@export var hp_per_heart: int = 10


func _ready():
	update_hp_display()
	PlayerStats.player_hp_changed.connect(update_hp_display)
	pass


func clear_hp_display():
	var children = base_bar_h_box_container.get_children()
	for child in children:
		child.call_deferred("queue_free")
		
	children = heart_bar_h_box_container.get_children()
	for child in children:
		child.call_deferred("queue_free")


func set_max_hearts():
	# set up max hearts
	player_max_hp = PlayerStats.stats.current_max_hp
	var hearts_to_display = ceil(float(player_max_hp) / hp_per_heart)
	current_hearts_displayed = hearts_to_display
	var base_bar_number = 1
	for i in range(hearts_to_display):
		# add heart to hboxcontainer
		var player_heart_instance = player_heart_scene.instantiate()
		heart_bar_h_box_container.add_child(player_heart_instance)
		
		# add base_bar to hboxcontainer
		var base_bar_instance = TextureRect.new()
		match(base_bar_number):
			1:
				base_bar_instance.texture = base_bar_1
				base_bar_number = 2
			2:
				base_bar_instance.texture = base_bar_2
				base_bar_number = 1
		base_bar_h_box_container.add_child(base_bar_instance)
		
	# add the final base bar to end of hboxcontainer
	var base_bar_end_instance = TextureRect.new()
	base_bar_end_instance.texture = base_bar_3
	base_bar_h_box_container.add_child(base_bar_end_instance)


func update_hearts_display():
	player_current_hp = PlayerStats.stats.current_hp
	
	# get counts of full, partial, and empty hearts
	var full_hearts_count = floor(player_current_hp / hp_per_heart)
	var partial_heart_count = 0
	# if player current hp is not cleanly divisible by hp_per_heart, 
	# we have a partial heart
	if ((player_current_hp % hp_per_heart) > 0):
		partial_heart_count = 1
	# empty hearts should just be whatever is left after subtracting 
	# full and partial from total heart count
	var empty_hearts_count = current_hearts_displayed - (full_hearts_count + partial_heart_count)
	
	# we have the counts
	# now go through and update each of them
	var hearts = heart_bar_h_box_container.get_children()
	var index = 0
	# full hearts
	for i in range(full_hearts_count):
		hearts[index].set_heart_full()
		index += 1
	# partial heart, should only be 1 if not 0
	if partial_heart_count == 1:
		var heart_percentage = float(player_current_hp % hp_per_heart) / hp_per_heart
		hearts[index].set_heart_partial(heart_percentage)
		index += 1
	# empty hearts, could be 0 or up to max_hearts - 1
	for i in range(empty_hearts_count):
		hearts[index].set_heart_empty()
		index += 1


func update_hp_display(current_hp = 1, max_hp = 1):
	clear_hp_display()
	# give time for clear_hp_display() to actually remove the old nodes
	await get_tree().process_frame
	set_max_hearts()
	update_hearts_display()
