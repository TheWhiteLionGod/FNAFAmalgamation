extends CanvasLayer

@export var Events: Node3D

func _ready() -> void:
	if Events == null:
		print("ERROR: Export Variable 'Events' Not Defined")
