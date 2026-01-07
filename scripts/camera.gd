"""
This Node Will Handle and Change Cameras on Signal
"""
extends Node3D

const CAMERA_ROTATION_SPEED_PER_SECOND: float = 10 # In Degrees
const CAMERA_MAX_ROTATION: float = 30 # In Degrees

var rotateSign: int = 1

@onready var cameras: Array[Node] = get_children()
@onready var camInitalRotation: Array[Vector3] = []

@export var camerasNode: Node3D

func _ready() -> void:
	camInitalRotation.resize(get_child_count())
	for cam in cameras:
		camInitalRotation[nameToEnum(cam.name)] = cam.rotation

	GameState.switchCamera.connect(changeCamera)
	changeCamera()

func _process(delta: float) -> void:
	var cameraRotationY: float = GameState.curCamNode.rotation_degrees.y # Current Camera Rotation (In Degrees)
	
	# Rotating Camera
	if cameraRotationY > camInitalRotation[GameState.activeCamera].y + CAMERA_MAX_ROTATION:
		rotateSign = -1
	elif cameraRotationY < camInitalRotation[GameState.activeCamera].y - CAMERA_MAX_ROTATION:
		rotateSign = 1
	
	GameState.curCamNode.rotation_degrees.y += CAMERA_ROTATION_SPEED_PER_SECOND * delta * rotateSign

func changeCamera() -> void:
	GameState.curCamNode = get_node(enumToName(GameState.activeCamera))
	GameState.curCamNode.current = true

func enumToName(cam: GameState.Camera) -> String:
	return GameState.Camera.keys()[cam]

func nameToEnum(cam: String) -> int:
	return GameState.Camera[cam]
