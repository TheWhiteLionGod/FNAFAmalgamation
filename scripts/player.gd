extends Node3D
class_name Player

signal camera_set
var camera: Camera3D: 
	set(value): camera_set.emit()

func _ready() -> void:
	Global.player = self
	await camera_set
