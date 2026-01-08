"""
This Node Will Handle and Change Cameras on Signal
"""
extends Node3D

const CAMERA_ROTATION_SPEED_PER_SECOND: float = 10 # In Degrees
const CAMERA_MAX_ROTATION: float = 30 # In Degrees

var rotateSign: int = 1

@onready var cameras: Array[Node] = get_children()
@onready var camInitalRotation: Array[Vector3] = []

@export var main: Node3D

@onready var player: Node3D = main.get_node("Player")

@onready var gui: CanvasLayer = main.get_node("GUI")
@onready var guiAnimationPlayer: AnimationPlayer = gui.get_node("AnimationPlayer")
@onready var cameraGui: MarginContainer = gui.get_node("Cams")
@onready var cameraShaders: Panel = gui.get_node("CameraShaders")

func _ready() -> void:
	camInitalRotation.resize(get_child_count())
	for cam in cameras:
		camInitalRotation[nameToEnum(cam.name)] = cam.rotation

	GameState.curCamNode = get_node(enumToName(GameState.activeCamera))
	GameState.switchCamera.connect(changeCamera)

var areCamerasOpen: bool = false
func _process(delta: float) -> void:
	var cameraRotationY: float = GameState.curCamNode.rotation_degrees.y # Current Camera Rotation (In Degrees)
	
	# Rotating Camera
	if cameraRotationY > camInitalRotation[GameState.activeCamera].y + CAMERA_MAX_ROTATION:
		rotateSign = -1
	elif cameraRotationY < camInitalRotation[GameState.activeCamera].y - CAMERA_MAX_ROTATION:
		rotateSign = 1
	
	GameState.curCamNode.rotation_degrees.y += CAMERA_ROTATION_SPEED_PER_SECOND * delta * rotateSign
	
	if GameState.playerActions["cameras"] == true:
		if areCamerasOpen == false:
			openCameras()
			areCamerasOpen = true
	else:
		if areCamerasOpen == true:
			closeCameras()
			areCamerasOpen = false

func changeCamera() -> void:
	GameState.curCamNode = get_node(enumToName(GameState.activeCamera))
	GameState.curCamNode.current = true

	guiAnimationPlayer.play("camera_open")

func openCameras() -> void:
	cameraGui.show()
	cameraShaders.show()
	GameState.curCamNode.current = true

	guiAnimationPlayer.play("camera_open")

@onready var cameraOpenAnimation: Animation = guiAnimationPlayer.get_animation("camera_open")
func closeCameras() -> void:
	print("Closing Cameras")
	guiAnimationPlayer.play("camera_close")
	await get_tree().create_timer(cameraOpenAnimation.length).timeout

	player.get_node("Camera").current = true
	cameraGui.hide()
	cameraShaders.hide()

func enumToName(cam: GameState.Camera) -> String:
	return GameState.Camera.keys()[cam]

func nameToEnum(cam: String) -> int:
	return GameState.Camera[cam]
