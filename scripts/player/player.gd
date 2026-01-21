extends Node3D

@export var main: Node3D

@onready var leftDoorAnimations: AnimationPlayer = main.get_node("Rooms").get_node("Office").get_node("LeftWall").get_node("LeftDoorAnimation")
@onready var rightDoorAnimations: AnimationPlayer = main.get_node("Rooms").get_node("Office").get_node("RightWall").get_node("RightDoorAnimation")


@onready var leftDoorCloseAnimation: Animation = leftDoorAnimations.get_animation("close_left_door")
@onready var leftDoorOpenAnimation: Animation = leftDoorAnimations.get_animation("open_left_door")

@onready var rightDoorCloseAnimation: Animation = rightDoorAnimations.get_animation("close_right_door")
@onready var rightDoorOpenAnimation: Animation = rightDoorAnimations.get_animation("open_right_door")

var adjustingLeftDoor: bool = false
var adjustingRightDoor: bool = false
var adjustingMask: bool = false

var doorDebounceExtraOffset: float = 0.35

@onready var equipMaskAnimation: Animation = $"AnimationPlayer".get_animation("equip_mask")
@onready var unequipMaskAnimation: Animation = $"AnimationPlayer".get_animation("unequip_mask")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mask"):
		if adjustingMask:
			return
		adjustingMask = true

		GameState.playerActions["mask"] = !GameState.playerActions["mask"]

		if GameState.playerActions["mask"]:
			$"Mask".visible = true
			$"AnimationPlayer".play("equip_mask")

			await get_tree().create_timer(equipMaskAnimation.length).timeout
			adjustingMask = false
		else:
			$"AnimationPlayer".play("unequip_mask")

			await get_tree().create_timer(unequipMaskAnimation.length).timeout
			adjustingMask = false
			$"Mask".visible = false

	elif GameState.playerActions["mask"]:
		return # Player can't do anything with mask on

	elif event.is_action_pressed("flashlight"):
		GameState.playerActions["flashlight"] = true
		$"Flashlight".visible = true
	elif event.is_action_released("flashlight"):
		GameState.playerActions["flashlight"] = false
		$"Flashlight".visible = false

	elif event.is_action_pressed("left_door"):
		if adjustingLeftDoor:
			return
		adjustingLeftDoor = true

		GameState.playerActions["left_door"] = !GameState.playerActions["left_door"]

		if GameState.playerActions["left_door"]:
			leftDoorAnimations.play("close_left_door")

			await get_tree().create_timer(leftDoorCloseAnimation.length + doorDebounceExtraOffset).timeout
			adjustingLeftDoor = false
		else:
			leftDoorAnimations.play("open_left_door")

			await get_tree().create_timer(leftDoorOpenAnimation.length + doorDebounceExtraOffset).timeout
			adjustingLeftDoor = false
	
	elif event.is_action_pressed("right_door"):
		if adjustingRightDoor:
			return
		adjustingRightDoor = true
		
		GameState.playerActions["right_door"] = !GameState.playerActions["right_door"]

		if GameState.playerActions["right_door"]:
			rightDoorAnimations.play("close_right_door")

			await get_tree().create_timer(rightDoorCloseAnimation.length + doorDebounceExtraOffset).timeout
			adjustingRightDoor = false
		else:
			rightDoorAnimations.play("open_right_door")

			await get_tree().create_timer(rightDoorOpenAnimation.length + doorDebounceExtraOffset).timeout
			adjustingRightDoor = false
	
	elif event.is_action_pressed("cameras"):
		GameState.playerActions["cameras"] = !GameState.playerActions["cameras"]
		if GameState.playerActions["cameras"]:
			GameState.openCamera.emit()
		else:
			GameState.closeCamera.emit()
		
	elif event.is_action_pressed("audio_lure"):
		# TODO
		pass

@onready var camera = $"Camera"

# Shake Parameters
var trauma := 0.0          # Current intensity (0 to 1)
var trauma_decay := 0.8    # How fast it fades
var max_offset := 0.5      # Max distance (m) the camera can shift
var max_roll := 0.1        # Max rotation (radians) for side-to-side tilt
var noise_speed := 50.0    # Speed of the noise sampling

var time_passed := 0.0
var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.frequency = 0.5

	GameState.shakeScreen.connect(cameraShake)

func _process(delta):
	if GameState.playerActions["cameras"]:
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

func cameraShake(intensity: float = 1, decay_rate: float = 0.8):
	trauma = clamp(trauma + intensity, 0.0, 1.0)
	trauma_decay = decay_rate