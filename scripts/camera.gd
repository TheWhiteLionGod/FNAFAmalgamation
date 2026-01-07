"""
This Node Will Handle and Change Cameras on Signal
"""
extends Node3D

const CAMERA_ROTATION_SPEED_PER_SECOND: float = 10 # In Degrees
const CAMERA_MAX_ROTATION: float = 30 # In Degrees

var rotateSign: int = 1

@onready var curCam: Camera3D = get_node(enumToName(GameState.activeCamera))
@onready var cameras: Array[Node] = get_children()
@onready var camInitalRotation: Array[Vector3] = []

func _ready() -> void:
	camInitalRotation.resize(get_child_count())
	for cam in cameras:
		camInitalRotation[nameToEnum(cam.name)] = cam.rotation

	GameState.switchCamera.connect(changeCamera)

func _process(delta: float) -> void:
	var cameraRotationY: float = curCam.rotation_degrees.y # Current Camera Rotation (In Degrees)
	
	# Rotating Camera
	if cameraRotationY > camInitalRotation[GameState.activeCamera].y + CAMERA_MAX_ROTATION:
		rotateSign = -1
	elif cameraRotationY < camInitalRotation[GameState.activeCamera].y - CAMERA_MAX_ROTATION:
		rotateSign = 1
	
	curCam.rotation_degrees.y += CAMERA_ROTATION_SPEED_PER_SECOND * delta * rotateSign

func changeCamera() -> void:
	var newCamera: Camera3D = get_node(enumToName(GameState.activeCamera))
	newCamera.current = true
	curCam = newCamera

func enumToName(cam: int) -> String:
	return GameState.Camera.keys()[cam]

func nameToEnum(cam: String) -> int:
	return GameState.Camera[cam]
