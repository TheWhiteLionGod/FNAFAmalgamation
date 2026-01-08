"""
Modifies Active Camera in Game State When User Clicks Button
"""
extends MarginContainer

func changeCamera(cameraName: String) -> void:
	var newCamera: GameState.Camera = GameState.Camera[cameraName]

	GameState.activeCamera = newCamera
	GameState.switchCamera.emit()
