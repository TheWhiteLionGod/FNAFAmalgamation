extends MarginContainer

var playerKilled: bool = false

func _ready() -> void:
	GameState.playerKilled.connect(killPlayer)

func killPlayer() -> void:
	playerKilled = true

func _turn_left() -> void:
	print("Turn Left")
	pass # Replace with function body.

func _turn_right() -> void:
	print("Turn Right")
	pass # Replace with function body.

func _look_up() -> void:
	print("Look Up")
	pass # Replace with function body.

func _mask_btn() -> void:
	print("Mask")
	pass # Replace with function body.

func _cam_btn() -> void:
	if playerKilled: return

	GameState.playerActions["cameras"]  = !GameState.playerActions["cameras"]
	if GameState.playerActions["cameras"]: GameState.openCamera.emit()
	else: GameState.closeCamera.emit()
