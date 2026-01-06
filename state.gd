"""
Global Node to Control the State of the Game
"""
extends Node3D

enum Camera {
	CAM1, CAM2, CAM3, CAM4, CAM5A, CAM5B, CAM5C, CAM6, CAM7, CAM8, CAM9
}

var globalTimer: float = 0.0
var activeCamera: Camera = Camera.CAM1

signal switchCamera(newCamera: Camera)

func _ready() -> void:
	globalTimer = 0
	activeCamera = Camera.CAM1