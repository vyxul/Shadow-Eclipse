extends Node2D

@onready var audio_stream_player = $AudioStreamPlayer
@onready var audio_stream_player_2 = $AudioStreamPlayer2
@onready var timer = $Timer
@onready var defeat_screen = $"UI/Defeat Screen"
@onready var victory_screen = $"UI/Victory Screen"

# exports for editor
@export var fog: Sprite2D
@export var fogWidth = 1550
@export var fogHeight = 1550
@export var LightTexture: CompressedTexture2D
@export var lightWidth = 300
@export var lightHeight = 300
@export var Player: CharacterBody2D
@export var debounce_time = 0.01

# debounce counter helper
var time_since_last_fog_update = 0.0

var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

# here we cache things when Node2D is ready
func _ready():
  # get Image from CompressedTexture2D and resize it
	lightImage = LightTexture.get_image()
	lightImage.resize(lightWidth, lightHeight)
	time_since_last_fog_update = Time.get_ticks_msec()
  # get center
	light_offset = Vector2(lightWidth/2, lightHeight/2)

  # create black canvas (fog)
	fogImage = Image.create(fogWidth, fogHeight, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color.BLACK)
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

  # get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())

  # update fog once or player will be under fog until you start move
	update_fog(Player.position)
	
	GameData.player_died.connect(on_player_died)
	GameState.game_state_changed.connect(on_game_state_changed)
	GameState.game_start()
	
# update our fog
func update_fog(pos):	
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)


func level_complete():
	victory_screen.appear()


func _on_player_player_moved(NewPosition):
	var current_time = Time.get_ticks_msec()
	if time_since_last_fog_update + debounce_time <= current_time:
		time_since_last_fog_update = current_time
		call_deferred("update_fog", NewPosition)


func _on_timer_timeout():
	audio_stream_player.play()
	audio_stream_player_2.stop()


func on_player_died():
	GameState.PlayerDied()
	defeat_screen.appear()


func on_game_state_changed(game_state):
	match (game_state):
		GameState.EGameState.Conquer:
			timer.start()
		GameState.EGameState.Expansion:
			timer.stop()
			audio_stream_player_2.play()
			audio_stream_player.stop()
		GameState.EGameState.Finished:
			timer.stop()
			level_complete()



