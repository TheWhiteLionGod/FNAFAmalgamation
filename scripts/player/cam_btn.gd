"""
Modifies Active Camera in Game State When User Clicks Button
"""
extends MarginContainer

@onready var springTrapBtn: Button = $"Cams/Bottom/SpringTrapBtn"

func changeCamera(cameraName: String) -> void:
	var newCamera: GameState.Camera = GameState.Camera[cameraName]

	GameState.playerState.activeCamera = newCamera
	GameState.switchCamera.emit()

	if GameState.playerState.activeCamera == GameState.Camera.CAM3 || GameState.playerState.activeCamera == GameState.Camera.CAM4:
		springTrapBtn.text = "Seal Vent"
		return
	springTrapBtn.text = "Place Audio Lure"

func springTrapBtnPressed() -> void:
	if GameState.playerState.activeCamera == GameState.Camera.CAM3 || GameState.playerState.activeCamera == GameState.Camera.CAM4:
		# Sealing Vent
		GameState.sealVent.emit(GameState.playerState.activeCamera)
		return

	# Placing Audio Lure
	GameState.placeAudioLure.emit(GameState.playerState.activeCamera)
