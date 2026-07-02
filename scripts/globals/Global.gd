extends Node

signal room_set
var rooms: Node3D: 
	set(value): rooms = value; room_set.emit() 
var player: Player

func _ready() -> void:
	await room_set
	var office = rooms.get_node_or_null("Office")
	if office is Room:
		player.camera = office.get_camera()
