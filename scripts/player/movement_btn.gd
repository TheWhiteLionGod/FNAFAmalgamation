extends MarginContainer

var playerKilled: bool = false

func _ready() -> void:
	GameState.playerKilled.connect(killPlayer)

func killPlayer() -> void:
	playerKilled = true

func _turn_left() -> void:
	if playerKilled: return
	print("Turn Left")

func _turn_right() -> void:
	if playerKilled: return
	print("Turn Right")

func _look_up() -> void:
	if playerKilled: return
	print("Look Up")

func _mask_btn() -> void:
	if playerKilled: return
	if GameState.playerNode.get_node("Mask").adjustingMask || GameState.playerActions["cameras"]:
		return

	GameState.playerActions["mask"] = !GameState.playerActions["mask"]
	if GameState.playerActions["mask"]: 
		GameState.maskOn.emit()
	else: 
		GameState.maskOff.emit()

func _cam_btn() -> void:
	if playerKilled: return
	if GameState.playerActions["mask"]:
		return

	GameState.playerActions["cameras"]  = !GameState.playerActions["cameras"]
	if GameState.playerActions["cameras"]: 
		GameState.openCamera.emit()
	else: 
		GameState.closeCamera.emit()
