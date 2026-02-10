"""
Modifies Active Camera in Game State When User Clicks Button
"""
extends MarginContainer

@onready var springTrapBtn: Button = $"Cams/Bottom/SpringTrapBtn"

func _ready() -> void:
	GameState.sealVent.connect(updateVentText)

func changeCamera(cameraName: String) -> void:
	var newCamera: GameState.Camera = GameState.Camera[cameraName]
	GameState.switchCamera.emit(newCamera)

	if newCamera == GameState.Camera.CAM3 or newCamera == GameState.Camera.CAM4:
		if newCamera == GameState.sealedCam:
			springTrapBtn.text = "Sealed.."
		else:
			springTrapBtn.text = "Seal Vent"
	else:
		if newCamera == GameState.audioCam:
			springTrapBtn.text = "Audio.."
		else:
			springTrapBtn.text = "Place Audio Lure"

func updateVentText(sealedVent: GameState.Camera) -> void:
	if GameState.playerState.activeCamera == sealedVent:
		springTrapBtn.text = "Sealed.."

func springTrapBtnPressed() -> void:
	if GameState.playerState.activeCamera == GameState.Camera.CAM3 or GameState.playerState.activeCamera == GameState.Camera.CAM4:
		# Vent Already Sealed
		if GameState.sealedCam != -1:
			return
		
		# Sealing Vent
		GameState.sealVent.emit(GameState.playerState.activeCamera)
		return
	
	# Audio Lure Already Placed
	if GameState.audioCam != -1:
		return

	# Placing Audio Lure
	GameState.placeAudioLure.emit(GameState.playerState.activeCamera)
