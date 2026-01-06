"""
This Node Will Handle and Change Cameras on Signal
"""
extends Node3D

@onready var cameras: Array[Node] = get_children()

func _ready() -> void:
	GameState.switchCamera.connect(changeCamera)

func changeCamera() -> void:
	for cam in cameras:
		if cam.name == GameState.Camera.keys()[GameState.activeCamera]:
			cam.current = true