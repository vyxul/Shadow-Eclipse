extends CanvasLayer

@onready var health_bar = %HealthBar
@onready var mana_bar = %ManaBar


func _ready():
	update_hp_bar()
	update_mp_bar()
	#PlayerStats.player_stats_changed.connect(update_hp_bar)
	#PlayerStats.player_stats_changed.connect(update_mp_bar)


func update_hp_bar():
	pass
#	health_bar.max_value = PlayerStats.stats.current_max_hp
#	health_bar.value = PlayerStats.stats.current_hp


func update_mp_bar():
	pass
#	mana_bar.max_value = PlayerStats.stats.max_mana
#	mana_bar.value = PlayerStats.stats.current_mana
