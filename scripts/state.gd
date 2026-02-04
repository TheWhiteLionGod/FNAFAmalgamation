"""
Global Node to Control the State of the Game
"""

extends Node3D

enum Camera {
	CAM1, CAM2, CAM3, CAM4, CAM5A, CAM5B, CAM5C,CAM6, CAM7, CAM8, CAM9
}

enum Facing {
	OFFICE, TABLE, OUTSIDE, MUSIC_BOX, TOP_VENT
}

class PlayerState:
	var flashlightOn: bool = false
	var leftDoorClosed: bool = false
	var rightDoorClosed: bool = false
	
	var inCameras: bool = false
	var maskOn: bool = false
	
	var inBlackout: bool = false
	var playerDead: bool = false

	var facing: Facing = Facing.OFFICE
	var activeCamera: Camera = Camera.CAM1

var globalTimer: float = 0.0
var curCamNode: Camera3D
var playerNode: Node3D
var playerState := PlayerState.new()

signal openCamera()
signal closeCamera()
signal switchCamera()
signal maskOn()
signal maskOff()
signal turn()
signal musicBoxEmpty()
signal playerKilled()
signal shakeScreen(intensity: float, decay_rate)
signal blackoutStart(duration: float)
signal blackoutEnd()
signal sealVent(camera: Camera)
signal placeAudioLure(camera: Camera)

func _ready() -> void:
	globalTimer = 0
	playerState.activeCamera = Camera.CAM1
	playerKilled.connect(killPlayer)

## Wait for x seconds
func wait(duration: float):
	await get_tree().create_timer(duration).timeout

func killPlayer() -> void:
	playerState.playerDead = true