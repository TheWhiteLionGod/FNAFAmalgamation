extends Node3D

func _ready() -> void:
	Global.rooms = get_node_or_null("Rooms")
