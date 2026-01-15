extends Node3D

@export var main: Node3D

@onready var rooms: Node3D = main.get_node("Rooms")

var adjustingLeftDoor: bool = false
var adjustingRightDoor: bool = false
var adjustingMask: bool = false

@onready var leftDoorCloseAnimation: Animation = rooms.get_node("AnimationPlayer").get_animation("close_left_door")
@onready var leftDoorOpenAnimation: Animation = rooms.get_node("AnimationPlayer").get_animation("open_left_door")

@onready var rightDoorCloseAnimation: Animation = rooms.get_node("AnimationPlayer").get_animation("close_right_door")
@onready var rightDoorOpenAnimation: Animation = rooms.get_node("AnimationPlayer").get_animation("open_right_door")

@onready var equipMaskAnimation: Animation = $"AnimationPlayer".get_animation("equip_mask")
@onready var unequipMaskAnimation: Animation = $"AnimationPlayer".get_animation("unequip_mask")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		GameState.playerActions["flashlight"] = true
		$"Flashlight".visible = true
	elif event.is_action_released("flashlight"):
		GameState.playerActions["flashlight"] = false
		$"Flashlight".visible = false

	elif event.is_action_pressed("left_door"):
		if not adjustingLeftDoor:
			adjustingLeftDoor = true
		else:
			return

		GameState.playerActions["left_door"] = !GameState.playerActions["left_door"]

		if GameState.playerActions["left_door"]:
			rooms.get_node("AnimationPlayer").play("close_left_door")

			await get_tree().create_timer(leftDoorCloseAnimation.length).timeout
			adjustingLeftDoor = false
		else:
			rooms.get_node("AnimationPlayer").play("open_left_door")

			await get_tree().create_timer(leftDoorOpenAnimation.length).timeout
			adjustingLeftDoor = false
	
	elif event.is_action_pressed("right_door"):
		if not adjustingRightDoor:
			adjustingRightDoor = true
		else:
			return
		
		GameState.playerActions["right_door"] = !GameState.playerActions["right_door"]

		if GameState.playerActions["right_door"]:
			rooms.get_node("AnimationPlayer").play("close_right_door")

			await get_tree().create_timer(rightDoorCloseAnimation.length).timeout
			adjustingRightDoor = false
		else:
			rooms.get_node("AnimationPlayer").play("open_right_door")

			await get_tree().create_timer(rightDoorOpenAnimation.length).timeout
			adjustingRightDoor = false
	
	elif event.is_action_pressed("cameras"):
		GameState.playerActions["cameras"] = !GameState.playerActions["cameras"]
		if GameState.playerActions["cameras"]:
			GameState.openCamera.emit()
		else:
			GameState.closeCamera.emit()
	
	elif event.is_action_pressed("mask"):
		if not adjustingMask:
			adjustingMask = true
		else:
			return

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
		
	elif event.is_action_pressed("audio_lure"):
		# TODO
		pass

func _process(_delta):
	if GameState.playerActions["cameras"]:
		$"Flashlight".global_transform = GameState.curCamNode.global_transform
	else:
		$"Flashlight".global_transform = global_transform
