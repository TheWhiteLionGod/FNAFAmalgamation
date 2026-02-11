extends Panel

func _play_game():
	GameState.restartGame.emit()
	visible = false

func showMenu():
	await GameState.wait(2)
	visible = true

func _ready():
	GameState.playerKilled.connect(showMenu)