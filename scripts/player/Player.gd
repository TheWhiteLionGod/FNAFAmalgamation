extends Node3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		GameState.playerActions["flashlight"] = true
	elif event.is_action_released("flashlight"):
		GameState.playerActions["flashlight"] = false
	
	elif event.is_action_pressed("left_door"):
		GameState.playerActions["left_door"] = !GameState.playerActions["left_door"]
	
	elif event.is_action_pressed("right_door"):
		GameState.playerActions["right_door"] = !GameState.playerActions["right_door"]
	
	elif event.is_action_pressed("cameras"):
		GameState.playerActions["cameras"] = !GameState.playerActions["cameras"]
		if GameState.playerActions["cameras"]:
			GameState.openCamera.emit()
		else:
			GameState.closeCamera.emit()
	
	elif event.is_action_pressed("mask"):
		GameState.playerActions["mask"] = !GameState.playerActions["mask"]
	
	elif event.is_action_pressed("audio_lure"):
		# TODO
		pass
