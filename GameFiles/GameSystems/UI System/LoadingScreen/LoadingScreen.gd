extends Control

var target_scene_path = "res://GameFiles/Scenes/Levels/Prison/PrisonLevel.tscn"

var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	set_process(false)
	
func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
			set_process(false)
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")


func GoToNextScene() -> void:
	# Request to load the target scene:
	ResourceLoader.load_threaded_request(target_scene_path)
	set_process(true)

func SetNextScene(scene_path) :
	if ResourceLoader.exists(scene_path) :
		target_scene_path = scene_path
	else:
		print("Warning: Given scene path does not exist")
