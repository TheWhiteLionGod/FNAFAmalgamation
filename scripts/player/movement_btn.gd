"""
This Script Controls The GUI Movement Buttons
"""
extends MarginContainer

@onready var leftBtn: Button = $"Buttons/Left"
@onready var rightBtn: Button = $"Buttons/Right"
@onready var topBtn: Button = $"Buttons/Vertical/Top"
@onready var camBtn: Button = $"Buttons/Vertical/Bottom/Cam"
@onready var maskBtn: Button = $"Buttons/Vertical/Bottom/Mask"

const visibleColor: Color = Color(1, 1, 1, 1)
const invisibleColor: Color = Color(1, 1, 1, 0)

func _ready() -> void:
	GameState.turn.connect(turnPlayer)

func makeInvisible(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "self_modulate", invisibleColor, 0.25)

	btn.disabled = true
	btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

func makeVisible(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "self_modulate", visibleColor, 0.25)

	btn.disabled = false
	btn.mouse_filter = Control.MOUSE_FILTER_PASS

func _process(_delta: float) -> void:
	if GameState.playerActions["cameras"]:
		makeInvisible(leftBtn)
		makeInvisible(rightBtn)
		makeInvisible(topBtn)
		makeVisible(camBtn)
		makeInvisible(maskBtn)
	
	elif GameState.playerActions["mask"]:
		makeInvisible(leftBtn)
		makeInvisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeVisible(maskBtn)

	elif GameState.playerActions["direction"] == GameState.Facing.OFFICE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeVisible(topBtn)
		makeVisible(camBtn)
		makeVisible(maskBtn)

	elif GameState.playerActions["direction"] == GameState.Facing.TABLE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerActions["direction"] == GameState.Facing.OUTSIDE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerActions["direction"] == GameState.Facing.MUSIC_BOX:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		makeInvisible(leftBtn)
		makeInvisible(rightBtn)
		makeInvisible(topBtn)
		makeVisible(camBtn)
		makeVisible(maskBtn)

	else:
		print("Invalid State")
		pass

func turnPlayer() -> void:
	var tween = create_tween()
	# Turning Up
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		var rotationX: float = lerp_angle(
			GameState.playerNode.rotation.x, 
			deg_to_rad(90),
			1
		)

		tween.tween_property(
			GameState.playerNode, 
			"rotation",
			Vector3(rotationX, 0, 0), 
			0.25
		)

		return

	# Turning Left and Right
	var rotationY: float = lerp_angle(
		GameState.playerNode.rotation.y, 
		GameState.playerActions["direction"] * deg_to_rad(90), 
		1
	)
	
	tween.tween_property(
		GameState.playerNode, 
		"rotation",
		Vector3(0, rotationY, 0), 
		0.25
	)

func _turn_left() -> void:
	if GameState.playerDead: return
	if GameState.playerActions["mask"] || GameState.playerActions["cameras"]:
		return
	
	GameState.playerActions["direction"] += 1
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		GameState.playerActions["direction"] += 1

	GameState.playerActions["direction"] %= GameState.Facing.size()
	GameState.turn.emit()

func _turn_right() -> void:
	if GameState.playerDead: return
	if GameState.playerActions["mask"] || GameState.playerActions["cameras"]:
		return

	GameState.playerActions["direction"] -= 1
	if GameState.playerActions["direction"] < 0:
		GameState.playerActions["direction"] += GameState.Facing.size()
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		GameState.playerActions["direction"] -= 1
	
	GameState.turn.emit()

func _look_up() -> void:
	if GameState.playerDead: return
	if GameState.playerActions["mask"] || GameState.playerActions["cameras"]:
		return

	GameState.playerActions["direction"] = GameState.Facing.TOP_VENT
	GameState.turn.emit()

func _mask_btn() -> void:
	if GameState.playerDead: return

	if GameState.playerNode.get_node("Mask").adjustingMask || GameState.playerActions["cameras"]:
		return

	GameState.playerActions["mask"] = !GameState.playerActions["mask"]
	if GameState.playerActions["mask"]: 
		GameState.maskOn.emit()
	else: 
		GameState.maskOff.emit()

func _cam_btn() -> void:
	if GameState.playerDead: return
	
	if GameState.playerActions["direction"] == GameState.Facing.TOP_VENT:
		GameState.playerActions["direction"] = GameState.Facing.OFFICE
		GameState.turn.emit()
		return

	if GameState.playerActions["mask"]:
		return

	GameState.playerActions["cameras"]  = !GameState.playerActions["cameras"]
	if GameState.playerActions["cameras"]: 
		GameState.openCamera.emit()
	else: 
		GameState.closeCamera.emit()
