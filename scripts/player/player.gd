"""
This Script Controls Player Behavior
"""
extends Node3D

@export var main: Node3D

@onready var leftDoorAnimations: AnimationPlayer = main.get_node("Rooms").get_node("Office").get_node("LeftWall").get_node("LeftDoorAnimation")
@onready var rightDoorAnimations: AnimationPlayer = main.get_node("Rooms").get_node("Office").get_node("RightWall").get_node("RightDoorAnimation")

@onready var leftDoorCloseAnimation: Animation = leftDoorAnimations.get_animation("close_left_door")
@onready var leftDoorOpenAnimation: Animation = leftDoorAnimations.get_animation("open_left_door")

@onready var rightDoorCloseAnimation: Animation = rightDoorAnimations.get_animation("close_right_door")
@onready var rightDoorOpenAnimation: Animation = rightDoorAnimations.get_animation("open_right_door")

@onready var camera = $"Camera"

# Shake Parameters
var trauma := 0.0          # Current intensity (0 to 1)
var trauma_decay := 0.8    # How fast it fades
var max_offset := 0.5      # Max distance (m) the camera can shift
var max_roll := 0.1        # Max rotation (radians) for side-to-side tilt
var noise_speed := 50.0    # Speed of the noise sampling

var time_passed := 0.0
var noise = FastNoiseLite.new()

# States
var adjustingLeftDoor: bool = false
var adjustingRightDoor: bool = false

var doorDebounceExtraOffset: float = 0.35

func canEnterCams() -> bool:
	return (!GameState.playerState.maskOn and 
			GameState.playerState.facing == GameState.Facing.OFFICE)

func canUseMask() -> bool:
	return (!GameState.playerState.inCameras and 
			(GameState.playerState.facing == GameState.Facing.OFFICE or 
			GameState.playerState.facing == GameState.Facing.TOP_VENT) and
			!$"Mask".adjustingMask)

func canUseFlashlight() -> bool:
	return !GameState.playerState.maskOn and !GameState.officeFlashlightDisabled

func canUseLeftDoor() -> bool:
	return !adjustingLeftDoor and !GameState.playerState.maskOn

func canUseRightDoor() -> bool:
	return !adjustingRightDoor and !GameState.playerState.maskOn

func canUseAudioLure() -> bool:
	return GameState.playerState.inCameras

func _input(event: InputEvent) -> void:
	if GameState.playerState.playerDead: 
		return

	if event.is_action_pressed("mask"):
		if !canUseMask():
			return

		if GameState.playerState.maskOn: 
			GameState.maskOff.emit()
			return
		GameState.maskOn.emit()

	elif event.is_action_pressed("flashlight") or event.is_action_released("flashlight"):
		if !canUseFlashlight() or event.is_action_released("flashlight"):
			GameState.flashlightOff.emit()
			$"Flashlight".visible = false
			return
		
		GameState.flashlightOn.emit()
		$"Flashlight".visible = true

	elif event.is_action_pressed("left_door"):
		leftDoor()
	
	elif event.is_action_pressed("right_door"):
		rightDoor()
	
	elif event.is_action_pressed("cameras"):
		if !canEnterCams():
			return

		if GameState.playerState.inCameras:
			GameState.closeCamera.emit()
			return

		if GameState.isCameraDisabled:
			return
		
		GameState.openCamera.emit()
		
	elif event.is_action_pressed("audio_lure"):
		if !canUseAudioLure():
			return

		if GameState.playerState.activeCamera == GameState.Camera.CAM3 or GameState.playerState.activeCamera == GameState.Camera.CAM4:
			# Vent Already Sealed
			if GameState.sealedCam != -1:
				return
			GameState.sealVent.emit(GameState.playerState.activeCamera)
			return

		# Audio Already Placed
		if GameState.audioCam != -1:
			return
		GameState.placeAudioLure.emit(GameState.playerState.activeCamera)

func _ready():
	GameState.restartGame.connect(restart)

	noise.seed = randi()
	noise.frequency = 0.5

	GameState.shakeScreen.connect(cameraShake)
	GameState.playerNode = self

func _process(delta):
	if !GameState.playerState.playerDead:
		if GameState.playerState.inCameras and !GameState.camFlashlightDisabled:
			$"Flashlight".global_transform = GameState.curCamNode.global_transform
		else:
			$"Flashlight".global_transform = global_transform
	
	# Shake Screen
	if trauma > 0:
		# 1. Decay trauma over time
		trauma = max(trauma - trauma_decay * delta, 0)
		time_passed += delta * noise_speed
		
		# 2. Apply shake using trauma squared for a more impactful feel
		var shake_amount = pow(trauma, 2)
		
		# Apply noise-based position offsets
		camera.h_offset = max_offset * shake_amount * noise.get_noise_2d(time_passed, 0)
		camera.v_offset = max_offset * shake_amount * noise.get_noise_2d(time_passed, 100)
		
		# Apply noise-based rotation (Roll is usually enough for 3D)
		camera.rotation.z = max_roll * shake_amount * noise.get_noise_2d(time_passed, 200)
	else:
		# 3. Clean up when shake ends
		camera.h_offset = 0
		camera.v_offset = 0
		camera.rotation.z = 0

func restart():
	leftDoor(true)
	rightDoor(true)

func cameraShake(intensity: float = 1, decay_rate: float = 0.8):
	trauma = clamp(trauma + intensity, 0.0, 1.0)
	trauma_decay = decay_rate

func leftDoor(restarting: bool = false):
	if !canUseLeftDoor():
		return

	adjustingLeftDoor = true

	if GameState.playerState.leftDoorClosed or restarting:
		GameState.leftDoorOpen.emit()

		leftDoorAnimations.play("open_left_door")
		await GameState.wait(leftDoorOpenAnimation.length + doorDebounceExtraOffset)
		adjustingLeftDoor = false

		return
	
	GameState.leftDoorClose.emit()

	leftDoorAnimations.play("close_left_door")
	await GameState.wait(leftDoorCloseAnimation.length + doorDebounceExtraOffset)
	adjustingLeftDoor = false

func rightDoor(restarting: bool = false):
	if !canUseRightDoor():
		return
		
	adjustingRightDoor = true
		
	if GameState.playerState.rightDoorClosed or restarting:
		GameState.rightDoorOpen.emit()

		rightDoorAnimations.play("open_right_door")
		await GameState.wait(rightDoorOpenAnimation.length + doorDebounceExtraOffset)
		adjustingRightDoor = false

		return

	GameState.rightDoorClose.emit()

	rightDoorAnimations.play("close_right_door")
	await GameState.wait(rightDoorCloseAnimation.length + doorDebounceExtraOffset)
	adjustingRightDoor = false