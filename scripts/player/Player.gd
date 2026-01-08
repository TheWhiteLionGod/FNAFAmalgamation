extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		GameState.playerActions["flashlight"] = true
	elif event.is_action_released("flashlight"):
		GameState.playerActions["flashlight"] = false
	
	elif event.is_action_pressed("left_door"):
		if not GameState.playerActions["left_door"]:
			GameState.playerActions["left_door"] = true
		else:
			GameState.playerActions["left_door"] = false
	
	elif event.is_action_pressed("right_door"):
		if not GameState.playerActions["right_door"]:
			GameState.playerActions["right_door"] = true
		else:
			GameState.playerActions["right_door"] = false
	
	elif event.is_action_pressed("cameras"):
		if not GameState.playerActions["cameras"]:
			GameState.playerActions["cameras"] = true
		else:
			GameState.playerActions["cameras"] = false
	
	elif event.is_action_pressed("mask"):
		if not GameState.playerActions["mask"]:
			GameState.playerActions["mask"] = true
		else:
			GameState.playerActions["mask"] = false
	
	elif event.is_action_pressed("audio_lure"):
		# TODO
		pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(GameState.playerActions)