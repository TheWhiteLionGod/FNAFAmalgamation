"""
This Script Will Control Withered Chica's Behavior
"""
extends Animatronic

signal configReady
@export_range(0, 20) var AI_LEVEL: int
@export var config: WitheredConfig:
	set(value):
		config = value
		configReady.emit()

@onready var killStage: int = getKillStage()
var movementOpportunity: MovementOpportunity
var lock: bool = false

func _init():
	await configReady
	super(config.stages)
	movementOpportunity = MovementOpportunity.new(config.movementInterval)

func _ready() -> void:
	super._ready()
	GameState.flashlightOn.connect(useFlashlight)
	GameState.goldenFreddyCleared.connect(func(): 
		currentStage = 0
		moveToStageMarker()
	)

func handleStage() -> void:
	match currentStage:
		0, 1, 2:
			if lock:
				return

			# Failed Movement
			if !movementOpportunity.check(AI_LEVEL):
				return

			# Progressing Stage
			currentStage += 1
			moveToStageMarker()

		killStage:
			jumpscare(config.intensity, config.decayRate, config.direction)
			playerKilled()

		_:
			print(
				"Invalid Stage Reached for Withered Chica Animatronic: " + 
				str(currentStage)
				)

func useFlashlight() -> void:
	# Camera Stunning
	if !GameState.playerState.inCameras:
		return

	if currentStage == 0 and GameState.playerState.activeCamera != 5:
		return

	if currentStage == 1 and GameState.playerState.activeCamera != 8:
		return

	if currentStage == 2 and GameState.playerState.activeCamera != 1:
		return

	lock = true
	await GameState.wait(7) # Stunning for 7 Seconds
	lock = false
	return
