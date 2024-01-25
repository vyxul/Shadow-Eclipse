extends Node2D

@export var faction: GameData.Factions
#@export var ExpansionSpeed = 1
@export_range(0.01, 10) var DamagePercentageTakenPerTileDamage = 0.1
@export var darknessTile: PackedScene

@export var MAX_EXPANSION_X = 15
@export var MAX_EXPANSION_Y = 15

@onready var healthComponent: HealthComponent = $HealthComponent	
@onready var conversion_component: ConversionComponent = $ConversionComponent
@onready var hurtboxComponent: HurtboxComponent = $HurtboxComponent
@onready var FountainOfDarkness = $"FountainOfLight Image/FountainOfDarkness Image"
@onready var _Timer = $Timer
@onready var Converted_30 = $"FountainOfLight Image/Converted_30"
@onready var Converted_60 = $"FountainOfLight Image/Converted_60"
@onready var Health_60 = $"FountainOfLight Image/Health_60"

var tileHalfSize = GameData.GetGameTileSize() / 2
var topLeftWorldLocation : Vector2i = Vector2i.ZERO
var TileCoordinates  = []
var LocationsToSpawnDarkness  = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	if MAX_EXPANSION_X % 2 == 0:
		MAX_EXPANSION_X += 1
	if MAX_EXPANSION_Y % 2 == 0:
		MAX_EXPANSION_Y += 1
	
	TileCoordinates.resize(MAX_EXPANSION_X * MAX_EXPANSION_Y)
	TileCoordinates.fill(0)
	
	var StartingID = GetStartIndex()
	var coordX = StartingID % MAX_EXPANSION_X		
	var coordY = floori(StartingID / MAX_EXPANSION_X)
	topLeftWorldLocation = -Vector2(coordX * tileHalfSize, coordY * tileHalfSize)
	
	OnFactionChanged(faction)
	hurtboxComponent.SetConversionComponent(conversion_component)
	

func OnFactionChanged(Faction : GameData.Factions):
	match Faction: 
		GameData.Factions.SHADOW: 
			var StartIndex = GetStartIndex()
			var Location = GetLocationFromIndex(StartIndex)
			AddNodeAndAttach(Vector3(Location.x, Location.y, StartIndex ))
			Expand()
			_Timer.start()
			GameState.ChangeGameState(GameState.EGameState.Expansion)
		GameData.Factions.LIGHT:
			FountainOfDarkness.visible = false
			_Timer.stop()

func AddNodeAndAttach(Locations):
		TileCoordinates[Locations.z] = 1
		var tile = darknessTile.instantiate()
		tile.position = Vector2(Locations.x, Locations.y)
		
		tile.TileDestroyed.connect(_on_darkness_tile_tile_destroyed)
		tile.TileReceivedDamage.connect(_on_darkness_tile_tile_received_damage)
		tile.SetCoordinates(Locations.z)
		tile.set_faction(faction)
		tile.ShowBehindParent()
		add_child(tile)

func Expand():
	var index = 0
	for TileNode in TileCoordinates:
		if TileNode == 0:
			if IsAdjacentSquareDark(index):
				var Location = GetLocationFromIndex(index)
				LocationsToSpawnDarkness.append(Vector3(Location.x, Location.y, index))
		index += 1

func _on_timer_timeout():
	SpawnOnLocations()
	call_deferred("Expand")

func _on_conversion_component_conversion_hp_depleted():
		Converted_30.visible = false
		Converted_60.visible = false
		FountainOfDarkness.visible = true
		OnFactionChanged(faction)

func _on_conversion_component_conversion_hp_lost(max_hp, current_hp, dmg):
	var ConvHealthPercentage =  float(current_hp) / float(max_hp)
	if (ConvHealthPercentage < 0.4):
		Converted_60.visible = true
		Converted_30.visible = false
	elif (ConvHealthPercentage < 0.7):
		Converted_30.visible = true
		Converted_60.visible = false
	print("Fountain Health: " + str(current_hp) + " out of " + str(max_hp))

func _on_darkness_tile_tile_destroyed(_Tile):	
	var coordinates = _Tile.GetCoordinates()
	TileCoordinates[coordinates] = 0
	remove_child(_Tile)
	print("Fountain Health " + str($HealthComponent.current_health_points))

func _on_darkness_tile_tile_received_damage(_damage):
	healthComponent.damage(_damage)

func GetUp(idx) -> int:
	var result = idx - MAX_EXPANSION_X
	return result
	
func GetRight(idx) -> int:
	var result = idx + 1
	if result >= MAX_EXPANSION_X * MAX_EXPANSION_Y:
		result = -1	
	return result

func GetLeft(idx) -> int:
	return idx - 1

func GetDown(idx) -> int:
	var result = idx + MAX_EXPANSION_X
	if result >= MAX_EXPANSION_X * MAX_EXPANSION_Y:
		result = -1	
	return result
	
func GetStartIndex() -> int:
	var result = (MAX_EXPANSION_Y / 2) * MAX_EXPANSION_X
	result += MAX_EXPANSION_X / 2 
	return result

func IsAdjacentSquareDark(idx) -> bool:
	var UpIDx = GetUp(idx)
	if UpIDx >= 0 && TileCoordinates[UpIDx] == 1:
		return true
	
	var RightIDx = GetRight(idx)
	if RightIDx >= 0 && TileCoordinates[RightIDx] == 1:
		return true
		
	var LeftIDx = GetLeft(idx)
	if LeftIDx >= 0 && TileCoordinates[LeftIDx] == 1:
		return true
		
	var DownIDx = GetDown(idx)
	if DownIDx >= 0 && TileCoordinates[DownIDx] == 1:
		return true
		
	return false
	
func GetLocationFromIndex(idx : int) -> Vector2:
		var coordX = idx % MAX_EXPANSION_X		
		var coordY = floori(idx / MAX_EXPANSION_X)
		return Vector2(topLeftWorldLocation.x + (coordX * tileHalfSize), topLeftWorldLocation.y + (coordY * tileHalfSize))

func SpawnOnLocations():
	for LocationToSpawn in LocationsToSpawnDarkness:
		AddNodeAndAttach(LocationToSpawn)
	LocationsToSpawnDarkness.clear()


func get_faction() -> int:
	return faction
