extends Node3D
class_name Room

@onready var camera: Camera3D = $"Camera3D"
# @onready var mesh: Node3D = $"Mesh"
var occupants: Dictionary[Marker3D, Animatronic]

func _ready() -> void:
	var marker_folder: Node3D = $"Markers"
	for child in marker_folder.get_children():
		if child is not Marker3D:
			continue	

		occupants[child as Marker3D] = null

func occupy_marker(marker: Marker3D, animatronic: Animatronic) -> bool:
	# If Marker Doesn't Exist In Table, We Don't Want to Move Animatronic To Marker, So Return True
	if occupants.get(marker, true):
		return false

	var key: Marker3D = occupants.find_key(animatronic)
	if key:
		occupants.set(key, null)
	
	occupants[marker] = animatronic
	animatronic.global_position = marker.global_position
	return true

func get_camera() -> Camera3D:
	return camera
