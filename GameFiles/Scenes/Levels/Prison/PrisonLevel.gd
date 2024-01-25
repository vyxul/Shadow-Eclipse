extends Node2D

# exports for editor
@export var fog: Sprite2D
@export var fogWidth = 1530
@export var fogHeight = 1505
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
	
# update our fog
func update_fog(pos):	
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)


func _on_player_player_moved(NewPosition):
	var current_time = Time.get_ticks_msec()
	if time_since_last_fog_update + debounce_time <= current_time:
		time_since_last_fog_update = current_time
		call_deferred("update_fog", NewPosition)
