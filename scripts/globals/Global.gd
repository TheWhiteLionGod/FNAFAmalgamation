extends Node

var rooms: Node3D
var player: Player

func _ready() -> void:
	var office = rooms.get_node_or_null("Office")
	if office is Room:
		player.camera = office.get_camera()
