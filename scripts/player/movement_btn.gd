extends MarginContainer

var playerKilled: bool = false

func _ready() -> void:
	GameState.playerKilled.connect(killPlayer)
	GameState.turn.connect(turnPlayer)

func killPlayer() -> void:
	playerKilled = true

func turnPlayer() -> void:
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		return

	# Turning Left and Right
	var tween = create_tween()
	var rotationY: float = lerp_angle(
		GameState.playerNode.rotation.y, 
		GameState.playerActions["direction"] * deg_to_rad(90), 
		1
	)
	
	tween.tween_property(
		GameState.playerNode, 
		"rotation",
		Vector3(
			GameState.playerNode.rotation.x, 
			rotationY,
			GameState.playerNode.rotation.z
			), 
		0.25)

func _turn_left() -> void:
	if playerKilled: return
	if GameState.playerActions["mask"] || GameState.playerActions["cameras"]:
		return
	
	GameState.playerActions["direction"] += 1
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		GameState.playerActions["direction"] += 1

	GameState.playerActions["direction"] %= GameState.Facing.size()
	GameState.turn.emit()

func _turn_right() -> void:
	if playerKilled: return
	if GameState.playerActions["mask"] || GameState.playerActions["cameras"]:
		return

	GameState.playerActions["direction"] -= 1
	if GameState.playerActions["direction"] < 0:
		GameState.playerActions["direction"] += GameState.Facing.size()
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		GameState.playerActions["direction"] -= 1
	
	GameState.turn.emit()

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
