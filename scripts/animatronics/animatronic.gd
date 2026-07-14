@abstract
extends Node3D
class_name Animatronic

@export var config: Resource

@abstract
func tick() -> void

@abstract
func move_to_start() -> void

func move_to_path(path_node) -> bool:
	# TODO: Get Room + Marker from Path, Then Move Animatronic
	var room: Room = Global.rooms.get_node_or_null(path_node.room_name)
	if not room:
		push_error("Room", path_node.room_name, "does not exist.")
		return false
	
	var occupy_any_marker: bool = not path_node.marker_name
	for marker in room.occupants:
		if occupy_any_marker and room.occupy_marker(marker, self):
			return true

		if marker.name == path_node.marker_name:
			return room.occupy_marker(marker, self)

	return false
