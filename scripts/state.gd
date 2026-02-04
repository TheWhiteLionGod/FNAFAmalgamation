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

var playerActions: Dictionary = {
	"flashlight" : false,
	"left_door" : false,
	"right_door" : false,
	"cameras" : false,
	"mask" : false,
	"audio_lure" : false,
	"in_blackout": false,
	"direction": Facing.OFFICE
}

var globalTimer: float = 0.0
var activeCamera: Camera = Camera.CAM1
var curCamNode: Camera3D
var playerNode: Node3D
var playerDead: bool = false

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
	activeCamera = Camera.CAM1
	playerKilled.connect(killPlayer)

## Wait for x seconds
func wait(duration: float):
	await get_tree().create_timer(duration).timeout

func killPlayer() -> void:
	playerDead = true