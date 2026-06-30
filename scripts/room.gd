extends Node3D
class_name Room

@onready var camera: Camera3D = $"Camera3D"
# @onready var mesh: Node3D = $"Mesh"
var markers: Array[Marker3D]
var occupants: Dictionary[Marker3D, String]

func _ready() -> void:
	var marker_folder: Node3D = $"Markers"
	for child in marker_folder.get_children():
		if child is not Marker3D:
			continue	
		
		var marker: Marker3D = child as Marker3D
		markers.append(marker)
		occupants[marker] = ""

	print(occupants)
