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
	if GameState.playerState.inCameras:
		makeInvisible(leftBtn)
		makeInvisible(rightBtn)
		makeInvisible(topBtn)
		makeVisible(camBtn)
		makeInvisible(maskBtn)
	
	elif GameState.playerState.maskOn:
		makeInvisible(leftBtn)
		makeInvisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeVisible(maskBtn)

	elif GameState.playerState.facing == GameState.Facing.OFFICE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeVisible(topBtn)
		makeVisible(camBtn)
		makeVisible(maskBtn)

	elif GameState.playerState.facing == GameState.Facing.TABLE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerState.facing == GameState.Facing.OUTSIDE:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerState.facing == GameState.Facing.MUSIC_BOX:
		makeVisible(leftBtn)
		makeVisible(rightBtn)
		makeInvisible(topBtn)
		makeInvisible(camBtn)
		makeInvisible(maskBtn)

	elif GameState.playerState.facing == GameState.Facing.TOP_VENT:
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
	if GameState.playerState.facing == GameState.Facing.TOP_VENT:
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
		GameState.playerState.facing * deg_to_rad(90), 
		1
	)
	
	tween.tween_property(
		GameState.playerNode, 
		"rotation",
		Vector3(0, rotationY, 0), 
		0.25
	)

func _turn_left() -> void:
	if GameState.playerState.playerDead: return
	if GameState.playerState.maskOn || GameState.playerState.inCameras:
		return
	
	GameState.playerState.facing += 1
	if GameState.playerState.facing == GameState.Facing.TOP_VENT:
		GameState.playerState.facing += 1

	GameState.playerState.facing %= GameState.Facing.size()
	GameState.turn.emit()

func _turn_right() -> void:
	if GameState.playerState.playerDead: return
	if GameState.playerState.maskOn || GameState.playerState.inCameras:
		return

	GameState.playerState.facing -= 1
	if GameState.playerState.facing < 0:
		GameState.playerState.facing += GameState.Facing.size()
	if GameState.playerState.facing == GameState.Facing.TOP_VENT:
		GameState.playerState.facing -= 1
	
	GameState.turn.emit()

func _look_up() -> void:
	if GameState.playerState.playerDead: return
	if GameState.playerState.maskOn || GameState.playerState.inCameras:
		return

	GameState.playerState.facing = GameState.Facing.TOP_VENT
	GameState.turn.emit()

func _mask_btn() -> void:
	if GameState.playerState.playerDead: return

	if GameState.playerNode.get_node("Mask").adjustingMask || GameState.playerState.inCameras:
		return

	GameState.playerState.maskOn = !GameState.playerState.maskOn
	if GameState.playerState.maskOn: 
		GameState.maskOn.emit()
	else: 
		GameState.maskOff.emit()

func _cam_btn() -> void:
	if GameState.playerState.playerDead: return
	
	if GameState.playerState.facing == GameState.Facing.TOP_VENT:
		GameState.playerState.facing = GameState.Facing.OFFICE
		GameState.turn.emit()
		return

	if GameState.playerState.maskOn:
		return

	GameState.playerState.inCameras  = !GameState.playerState.inCameras
	if GameState.playerState.inCameras: 
		GameState.openCamera.emit()
	else: 
		GameState.closeCamera.emit()
