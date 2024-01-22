extends Control

@onready var base_bar_h_box_container = $BaseBar_HBoxContainer
@onready var mana_bar_h_box_container = $ManaBar_HBoxContainer

var base_bar_1 = preload("res://GameFiles/Assets/Art/UI/PlayerUI/004 base bar - lower start.png")
var base_bar_2 = preload("res://GameFiles/Assets/Art/UI/PlayerUI/005 base bar - lower middle.png")
var base_bar_3 = preload("res://GameFiles/Assets/Art/UI/PlayerUI/006 base bar - lower end.png")
var player_mana_scene = preload("res://GameFiles/External/player_mana.tscn")

var current_orbs_displayed: int = 0
var player_max_mana: int = 100
var player_current_mana: int = 95
@export var mana_per_orb: int = 10

func _ready():
	update_mana_display()
	PlayerStats.player_mana_changed.connect(update_mana_display)
	pass


func clear_mana_display():
	var children = base_bar_h_box_container.get_children()
	for child in children:
		child.call_deferred("queue_free")
		
	children = mana_bar_h_box_container.get_children()
	for child in children:
		child.call_deferred("queue_free")


func set_max_orbs():
	# set up max hearts
	player_max_mana = PlayerStats.stats.current_max_mana
	var orbs_to_display = ceil(float(player_max_mana) / mana_per_orb)
	current_orbs_displayed = orbs_to_display
	var base_bar_number = 1
	for i in range(orbs_to_display):
		# add orb to hboxcontainer
		var player_mana_instance = player_mana_scene.instantiate()
		mana_bar_h_box_container.add_child(player_mana_instance)
		
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


func update_orbs_display():
	player_current_mana = PlayerStats.stats.current_mana
	
	# get counts of full, partial, and empty orbs
	var full_orbs_count = floor(player_current_mana / mana_per_orb)
	var partial_orb_count = 0
	# if player current mana is not cleanly divisible by mana_per_orb, 
	# we have a partial orb
	if ((player_current_mana % mana_per_orb) > 0):
		partial_orb_count = 1
	# empty orbs should just be whatever is left after subtracting 
	# full and partial from total orb count
	var empty_orbs_count = current_orbs_displayed - (full_orbs_count + partial_orb_count)
	
	# we have the counts
	# now go through and update each of them
	var orbs = mana_bar_h_box_container.get_children()
	var index = 0
	# full orbs
	for i in range(full_orbs_count):
		orbs[index].set_mana_full()
		index += 1
	# partial orb, should only be 1 if not 0
	if partial_orb_count == 1:
		var mana_percentage = float(player_current_mana % mana_per_orb) / mana_per_orb
		orbs[index].set_mana_partial(mana_percentage)
		index += 1
	# empty orbs, could be 0 or up to max_orbs - 1
	for i in range(empty_orbs_count):
		orbs[index].set_mana_empty()
		index += 1


func update_mana_display(current_mana = 0, max_mana = 0):
	clear_mana_display()
	# give time for clear_hp_display() to actually remove the old nodes
	await get_tree().process_frame
	set_max_orbs()
	update_orbs_display()
