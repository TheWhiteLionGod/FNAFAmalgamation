"""
This Node Will Handle and Change Cameras on Signal
"""
extends Node3D

const CAMERA_ROTATION_SPEED_PER_SECOND: float = 10 # In Degrees
const CAMERA_MAX_ROTATION: float = 30 # In Degrees

@onready var currentCamera: Camera3D = get_node(enumToName(GameState.activeCamera))
@onready var cameras: Array[Node] = get_children()
@onready var cameraInitialRotations: Array[Vector3] = []

func _ready() -> void:
	cameraInitialRotations.resize(get_child_count())
	for cam in cameras:
		cameraInitialRotations[nameToEnum(cam.name)] = cam.rotation

	GameState.switchCamera.connect(changeCamera)

var rotateSign: int = 1
func _process(delta: float) -> void:
	var cameraRotationY: float = currentCamera.rotation_degrees.y # Current Camera Rotation (In Degrees)
	
	# Rotating Camera
	if cameraRotationY > cameraInitialRotations[GameState.activeCamera].y + CAMERA_MAX_ROTATION:
		rotateSign = -1
	elif cameraRotationY < cameraInitialRotations[GameState.activeCamera].y - CAMERA_MAX_ROTATION:
		rotateSign = 1
	
	currentCamera.rotation_degrees.y += CAMERA_ROTATION_SPEED_PER_SECOND * delta * rotateSign

func changeCamera() -> void:
	var newCamera: Camera3D = get_node(enumToName(GameState.activeCamera))
	newCamera.current = true
	currentCamera = newCamera

func enumToName(cam: int) -> String:
	return GameState.Camera.keys()[cam]

func nameToEnum(cam: String) -> int:
	return GameState.Camera[cam]
