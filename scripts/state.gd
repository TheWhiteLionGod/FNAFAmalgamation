"""
Global Node to Control the State of the Game
"""

extends Node3D

enum Camera {
	CAM1, CAM2, CAM3, CAM4, CAM5A, CAM5B, CAM5C, CAM6, CAM7, CAM8, CAM9
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

@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
var sealedCam: Camera = -1
@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
var audioCam: Camera = -1

var playerNode: Node3D
var playerState: PlayerState = PlayerState.new()

signal openCamera()
signal closeCamera()
signal switchCamera(camera: Camera)
signal maskOn()
signal maskOff()
signal flashlightOn()
signal flashlightOff()
signal leftDoorOpen()
signal leftDoorClose()
signal rightDoorOpen()
signal rightDoorClose()
signal turn(dir: Facing)
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
	
	openCamera.connect(func(): playerState.inCameras = true)
	closeCamera.connect(func(): playerState.inCameras = false)
	switchCamera.connect(func(camera): playerState.activeCamera = camera)
	maskOn.connect(func(): playerState.maskOn = true)
	maskOff.connect(func(): playerState.maskOn = false)
	flashlightOn.connect(func(): playerState.flashlightOn = true)
	flashlightOff.connect(func(): playerState.flashlightOn = false)
	leftDoorOpen.connect(func(): playerState.leftDoorClosed = false)
	leftDoorClose.connect(func(): playerState.leftDoorClosed = true)
	rightDoorOpen.connect(func(): playerState.rightDoorClosed = false)
	rightDoorClose.connect(func(): playerState.rightDoorClosed = true)
	turn.connect(func(dir): playerState.facing = dir)
	# Music Box Empty Doesn't Change State
	playerKilled.connect(func(): playerState.playerDead = true)
	# Shake Screen Doesn't Affect State
	blackoutStart.connect(func(_dur: int): playerState.inBlackout = true)
	blackoutEnd.connect(func(): playerState.inBlackout = false)
	sealVent.connect(func(camera): 
		sealedCam = camera
		wait(10)
		@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
		sealedCam = -1
	)
	placeAudioLure.connect(func(camera):
		audioCam = camera
		wait(10)
		@warning_ignore("INT_AS_ENUM_WITHOUT_CAST", "INT_AS_ENUM_WITHOUT_MATCH")
		audioCam = -1
	)

## Wait for x seconds
func wait(duration: float):
	await get_tree().create_timer(duration).timeout
